import UIKit
import Flutter
import AccountKit
import Firebase
import FirebaseAuth
import Parse

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    //MARK: Properties
    var flutterResults: [String : FlutterResult] = [:]
    let databaseHelper = DatabaseHelper()
    var cartHelper = CartHelper()
    var accountKit: AccountKitManager!
    
    //MARK: Methods
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        
        //Configure Firebase
        FirebaseApp.configure()
        
        //Initialize Parse
        let parseClientConfiguration = ParseClientConfiguration {
            $0.applicationId = "87c27ca0-2133-400c-aadf-beb43d430315"
            $0.server = "http://34.73.142.234:1337/eatzie"
        }
        
        Parse.initialize(with: parseClientConfiguration)
        
        //get a view controller
        let viewController: FlutterViewController = window.rootViewController! as! FlutterViewController
        
        //declare channels
        let mainChannel = FlutterMethodChannel(name: "com.qrilt.eatzie/main", binaryMessenger: viewController)
        let cartChannel = FlutterMethodChannel(name: "com.qrilt.eatzie/cart", binaryMessenger: viewController)
        
        //set method call handlers
        //set method call handler for main channel
        mainChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            //determine which method called and perform actions accordingly
            //method to initiate login
            if flutterMethodCall.method == "initiateLogin" {
                //set result object
                self.flutterResults["accountKit"] = flutterResult
                
                //start Account Kit login flow
                self.initiateLogin(rootViewController: viewController)
            }
            
            //method to get locations for user
            else if flutterMethodCall.method == "getLocations" {
                self.databaseHelper.getLocations(flutterResult: flutterResult)
            }
            
            //method to get items for a given location
            else if flutterMethodCall.method == "getItemsForLocation" {
                let locationId = flutterMethodCall.arguments as! String
                self.databaseHelper.getItemsForLocation(locationId: locationId, flutterResult: flutterResult)
            }
            
            //method to get Cart object for a given location
            else if flutterMethodCall.method == "getCartForLocation" {
                let locationId = flutterMethodCall.arguments as! String
                self.databaseHelper.getCartForLocation(locationId: locationId, flutterResult: flutterResult)
            }
                
                //method to get Location object from server
            else if flutterMethodCall.method == "getLocationObject" {
                let locationId = flutterMethodCall.arguments as! String
                self.databaseHelper.getLocationObject(locationId: locationId, flutterResult: flutterResult)
            }
                
            //method to get Item object from server
            else if flutterMethodCall.method == "getItemObject" {
                let itemId = flutterMethodCall.arguments as! String
                self.databaseHelper.getItemObject(itemId: itemId, flutterResult: flutterResult)
            }
        }
        
        //set method call handler for cart channel
        cartChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            //method to get all cart objects for this user
            if flutterMethodCall.method == "getUserCartObjects" {
                self.cartHelper.getUserCartObjects(flutterResult: flutterResult)
            }
                
            //method to add an item to the cart
            else if flutterMethodCall.method == "addItemToCart" {
                let itemId = flutterMethodCall.arguments as! String
                self.cartHelper.addItemToCart(itemId: itemId, flutterResult: flutterResult);
            }
            
            //method to check if a cart exists for a given location
            else if flutterMethodCall.method == "doesCartExist" {
                let locationId = flutterMethodCall.arguments as! String
                self.cartHelper.doesCartExist(locationId: locationId, flutterResult: flutterResult)
            }
        }
        
        //register plugin registrant?
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //method to start FB Account Kit login
    func initiateLogin(rootViewController: FlutterViewController) {
        accountKit = AccountKitManager(responseType: .accessToken)
        
        //check if existing account kit token is there
        if accountKit.currentAccessToken != nil {
            //there's an existing account kit token, use it further
            logInUser(accessToken: accountKit.currentAccessToken!)
        } else {
            //there's no existing account kit token, show login screen to get one
            let inputState = UUID().uuidString
            let loginViewController: (UIViewController & AKFViewController)! = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState)
            
            //prepare loginViewController
            loginViewController.delegate = self
            loginViewController.isSendToFacebookEnabled = true
            
            //proceed to show if loginViewController is not nil
            if loginViewController != nil {
                rootViewController.present(loginViewController, animated: true, completion: nil)
            }
        }
    }
    
    //method to log in user on server side
    func logInUser(accessToken: AccessToken) {
        //get account kit parameters, to pass to cloud function
        accountKit.requestAccount { (accountKitAccount, error) in
            if error == nil && accountKitAccount != nil {
                //prepare params to call cloud function
                let params = [
                    "accountKitId": accountKitAccount!.accountID,
                    "accessToken": accessToken.tokenString,
                    "lastRefresh": accessToken.lastRefresh.description,
                    "phoneCountryCode": accountKitAccount!.phoneNumber!.countryCode,
                    "phoneNumber": accountKitAccount!.phoneNumber!.phoneNumber
                ]
                
                //call cloud function
                PFCloud.callFunction(inBackground: "logInUser", withParameters: params, block: { (result, error) in
                    if error == nil {
                        //cloud function returns tokens to log in to Parse and Firebase
                        //get tokens
                        let parseSessionToken = String((result as! String).split(separator: "|")[0])
                        let firebaseSessionToken = String((result as! String).split(separator: "|")[1])

                        //log into Parse
                        PFUser.become(inBackground: parseSessionToken, block: { (parseUser, error) in
                            if error == nil {
                                //logged into Parse, now log into Firebase
                                Auth.auth().signIn(withCustomToken: firebaseSessionToken) { (user, error) in
                                    if error == nil {
                                        //signed in with Firebase, return to Flutter
                                        let accountKitResult = self.flutterResults["accountKit"]!
                                        accountKitResult(true)
                                    }
                                }
                            }
                        })
                        
                    }
                })
            }
        }
    }
}

//Account Kit View Controller Delegate Methods
extension AppDelegate: AKFViewControllerDelegate {
    //method to handle successful login
    func viewController(_ viewController: (UIViewController & AKFViewController), didCompleteLoginWith accessToken: AccessToken, state: String) {
        logInUser(accessToken: accessToken)
    }
}
