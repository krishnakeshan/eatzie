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
    var accountKit: AKFAccountKit! = nil
    
    //MARK: Methods
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
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
        
        //set method call handlers
        //set method call handler for main channel
        mainChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            //determine which method called and perform actions accordingly
            if flutterMethodCall.method == "initiateLogin" {
                //set result object
                self.flutterResults["accountKit"] = flutterResult
                
                //start Account Kit login flow
                self.initiateLogin(rootViewController: viewController)
            }
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //method to start FB Account Kit login
    func initiateLogin(rootViewController: FlutterViewController) {
        accountKit = AKFAccountKit(responseType: .accessToken)
        
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
            loginViewController.enableGetACall = true
            loginViewController.enableSendToFacebook = true
            
            //proceed to show if loginViewController is not nil
            if loginViewController != nil {
                rootViewController.present(loginViewController, animated: true, completion: nil)
            }
        }
    }
    
    //method to log in user on server side
    func logInUser(accessToken: AKFAccessToken) {
        //get account kit parameters, to pass to cloud function
        accountKit.requestAccount { (accountKitAccount, error) in
            if error == nil && accountKitAccount != nil {
                print("successfully verified number, calling cloud function")
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
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        logInUser(accessToken: accessToken)
    }
}
