import UIKit
import Flutter
import AccountKit
import Firebase
import FirebaseAuth
import Parse
import Razorpay
import PlugNPlay

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    //MARK: Properties
    var flutterResults: [String : FlutterResult] = [:]
    let databaseHelper = DatabaseHelper()
    var cartHelper = CartHelper()
    var orderHelper = OrderHelper()
    var accountKit: AccountKitManager!
    var razorPay: Razorpay!
    
    //MARK: Methods
    func initStuff() {
        //Configure Firebase
        FirebaseApp.configure()
        
        //Initialize Parse
        let parseClientConfiguration = ParseClientConfiguration {
            $0.isLocalDatastoreEnabled = true
            $0.applicationId = "87c27ca0-2133-400c-aadf-beb43d430315"
            $0.server = "http://34.73.142.234:1337/eatzie"
        }
        Parse.initialize(with: parseClientConfiguration)
        
        //initialize Razorpay
        razorPay = Razorpay.initWithKey("rzp_test_pGg7BFZv2anSv9", andDelegateWithData: self)
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        
        //initialize stuff
        initStuff()
        
        //get a view controller
        let viewController: FlutterViewController = window.rootViewController! as! FlutterViewController
        
        //declare channels
        let authChannel = FlutterMethodChannel(name: "com.qrilt.eatzie/auth", binaryMessenger: viewController as! FlutterBinaryMessenger)
        let mainChannel = FlutterMethodChannel(name: "com.qrilt.eatzie/main", binaryMessenger: viewController as! FlutterBinaryMessenger)
        let cartChannel = FlutterMethodChannel(name: "com.qrilt.eatzie/cart", binaryMessenger: viewController as! FlutterBinaryMessenger)
        let orderChannel = FlutterMethodChannel(name: "com.qrilt.eatzie/order", binaryMessenger: viewController as! FlutterBinaryMessenger)
        
        //set method call handlers
        //set method call handler for auth channel
        authChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            //method to get current auth status
            if (flutterMethodCall.method == "getAuthStatus") {
                //first check if logged in with Firebase
                if Auth.auth().currentUser != nil {
                    //logged in with Firebase, check with Parse
                    if PFUser.current() != nil {
                        //logged in with Parse, return true
                        flutterResult(true)
                        return
                    }
                }
                
                //reaching here means not logged in, return false
                flutterResult(false)
                return
            }
                
                //method to start phone verification
            else if flutterMethodCall.method == "startPhoneVerification" {
                //get arguments
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let countryCode = arguments["countryCode"] as! String
                let phoneNumber = arguments["phoneNumber"] as! String
                let numberToVerify = "+" + countryCode + phoneNumber
                
                //start verification
                PhoneAuthProvider.provider().verifyPhoneNumber(numberToVerify, uiDelegate: nil, completion: { (verificationId, error) in
                    //check if error occured
                    if let error = error {
                        //call method on auth channel
                        authChannel.invokeMethod("verificationFailed", arguments: nil)
                    }
                    
                        //no errors, call auth channel method to store id
                    else {
                        var arguments = [String : Any]()
                        arguments["verificationId"] = verificationId!
                        authChannel.invokeMethod("verificationCodeSent", arguments: arguments)
                    }
                })
                
                //return true result
                flutterResult(true)
            }
                
                //method to verify phone with code
            else if flutterMethodCall.method == "verifyPhoneWithCode" {
                //get arguments
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let verificationId = arguments["verificationId"] as! String
                let verificationCode = arguments["verificationCode"] as! String
                
                //create result map
                var resultMap = [String : Any]()
                
                //create credential and sign in with Firebase
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
                Auth.auth().signIn(with: credential, completion: { (result, error) in
                    if error == nil {
                        //user signed in with Firebase, sign in with Parse
                        let params = [
                            "firebaseUserId": Auth.auth().currentUser!.uid,
                            "phoneNumber": Auth.auth().currentUser!.phoneNumber!
                        ]
                        PFCloud.callFunction(inBackground: "logInUser", withParameters: params, block: { (result, error) in
                            print("debugk called log in user")
                            if error == nil {
                                let resultDict = result as! [String : Any]
                                
                                //got parse token, sign in
                                if resultDict["success"] as! Bool {
                                    PFUser.become(inBackground: resultDict["parseSessionToken"] as! String, block: { (user, error) in
                                        if error == nil {
                                            //signed in with everything, return true
                                            resultMap["success"] = true
                                            flutterResult(resultMap)
                                        }
                                    })
                                } else {
                                    //error occurred, return false
                                    resultMap["success"] = false
                                    flutterResult(resultMap)
                                }
                            } else {
                                //error occurred, return false
                                resultMap["success"] = false
                                flutterResult(resultMap)
                            }
                        })
                    } else {
                        //user not signed in
                        resultMap["success"] = false
                        flutterResult(resultMap)
                    }
                })
            }
                
                //method to initiate login
            else if flutterMethodCall.method == "initiateLogin" {
                //set result object
                self.flutterResults["accountKit"] = flutterResult
                
                //start Account Kit login flow
                self.initiateLogin(rootViewController: viewController)
            }
        }
        
        //set method call handler for main channel
        mainChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            //determine which method called and perform actions accordingly
            //method to get an object with id
            if flutterMethodCall.method == "getObjectWithId" {
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let className = arguments["className"] as! String
                let objectId = arguments["objectId"] as! String
                self.databaseHelper.getObjectWithId(className: className, objectId: objectId, flutterResult: flutterResult)
            }
                
                //method to get locations for user
            else if flutterMethodCall.method == "getLocations" {
                self.databaseHelper.getLocations(flutterResult: flutterResult)
            }
                
                //method to get items for a given location
            else if flutterMethodCall.method == "getItemsForLocation" {
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let locationId = arguments["locationId"] as! String
                self.databaseHelper.getItemsForLocation(locationId: locationId, flutterResult: flutterResult)
            }
            
            //method to get reviews for an entity
            else if flutterMethodCall.method == "getReviewsForId" {
                //get arguments
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let forId = arguments["forId"] as! String
                
                //create query
                let reviewsQuery = PFQuery(className: "Review")
                reviewsQuery.whereKey("forId", equalTo: forId)
                reviewsQuery.findObjectsInBackground(block: { (reviews, error) in
                    if error == nil {
                        //convert and return
                        flutterResult(self.databaseHelper.objConverter.createMapsFromObjects(parseObjects: reviews!))
                    } else {
                        flutterResult(false)
                    }
                })
            }
        }
        
        //set method call handler for cart channel
        cartChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            //method to get all cart objects for this user
            if flutterMethodCall.method == "getUserCartObjects" {
                self.cartHelper.getUserCartObjects(flutterResult: flutterResult)
            }
                
                //method to get cart for a location for this user
            else if (flutterMethodCall.method == "getUserCartForLocation") {
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let locationId = arguments["locationId"] as! String
                self.cartHelper.getUserCartForLocation(locationId: locationId, flutterResult: flutterResult)
            }
                
                //method to add an item to the cart
            else if flutterMethodCall.method == "addItemToCart" {
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let itemId = arguments["itemId"] as! String
                self.cartHelper.addItemToCart(itemId: itemId, flutterResult: flutterResult);
            }
                
                //method to remove an item from cart
            else if flutterMethodCall.method == "removeItemFromCart" {
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let itemId = arguments["itemId"] as! String
                self.cartHelper.removeItemFromCart(itemId: itemId, flutterResult: flutterResult)
            }
                
                //method to check if a cart exists for a given location
            else if flutterMethodCall.method == "doesCartExist" {
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let locationId = arguments["locationId"] as! String
                self.cartHelper.doesCartExist(locationId: locationId, flutterResult: flutterResult)
            }
        }
        
        //set method call handler for order channel
        orderChannel.setMethodCallHandler { (flutterMethodCall, flutterResult) in
            //method to sync user's active orders
            if flutterMethodCall.method == "syncUserActiveOrders" { 
                //create query to get orders
                let activeOrdersQuery = PFQuery(className: "Order")
                activeOrdersQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
                activeOrdersQuery.whereKey("statusCode", lessThan: 4)
                activeOrdersQuery.findObjectsInBackground(block: { (activeOrders, error) in
                    if error == nil {
                        //unpin all objects with this tag
                        PFObject.unpinAllObjectsInBackground(withName: "activeOrders", block: { (success, error) in
                            if error == nil && success {
                                //now pin newly acquired objects
                                PFObject.pinAll(inBackground: activeOrders!, withName: "activeOrders", block: { (success, error) in
                                    if error == nil && success {
                                        flutterResult(true)
                                    } else {
                                        //error pinning, return false
                                        flutterResult(false)
                                    }
                                })
                            } else {
                                //error unpinning, return false
                                flutterResult(false)
                            }
                        })
                    } else {
                        //error retrieving from server, return false
                        flutterResult(false)
                    }
                })
            }
                
            //method to sync user's past orders
            else if flutterMethodCall.method == "syncUserPastOrders" {
                //create query to get orders
                let pastOrdersQuery = PFQuery(className: "Order")
                pastOrdersQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
                pastOrdersQuery.whereKey("statusCode", equalTo: 4)
                pastOrdersQuery.findObjectsInBackground(block: { (pastOrders, error) in
                    if error == nil {
                        //unpin all objects with this tag
                        PFObject.unpinAllObjectsInBackground(withName: "pastOrders", block: { (success, error) in
                            if error == nil && success {
                                //now pin newly acquired objects
                                PFObject.pinAll(inBackground: pastOrders!, withName: "pastOrders", block: { (success, error) in
                                    if error == nil && success {
                                        flutterResult(true)
                                    } else {
                                        //error pinning, return false
                                        flutterResult(false)
                                    }
                                })
                            } else {
                                //error unpinning, return false
                                flutterResult(false)
                            }
                        })
                    } else {
                        //error retrieving from server, return false
                        flutterResult(false)
                    }
                })
            }
                
                //method to get user's active orders
            else if flutterMethodCall.method == "getUserActiveOrders" {
                //get arguments
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let fromLocalDatastore = arguments["fromLocalDatastore"] as! Bool
                
                //create query
                let ordersQuery = PFQuery(className: "Order")
                ordersQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
                ordersQuery.whereKey("statusCode", lessThan: 4)
                
                //determine source
                if fromLocalDatastore {
                    ordersQuery.fromLocalDatastore()
                }
                
                //execute query
                ordersQuery.findObjectsInBackground(block: { (orderObjects, error) in
                    if error == nil {
                        //return results
                        flutterResult(self.databaseHelper.objConverter.createMapsFromObjects(parseObjects: orderObjects!))
                    } else {
                        //error getting orders, return false
                        flutterResult(false)
                    }
                })
            }
                
                //method to get user's past orders
            else if flutterMethodCall.method == "getUserPastOrders" {
                //get arguments
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let fromLocalDatastore = arguments["fromLocalDatastore"] as! Bool
                
                //create query
                let ordersQuery = PFQuery(className: "Order")
                ordersQuery.whereKey("user", equalTo: PFUser.current()!.objectId!)
                ordersQuery.whereKey("statusCode", equalTo: 4)
                
                //determine source
                if fromLocalDatastore {
                    ordersQuery.fromLocalDatastore()
                }
                
                //execute query
                ordersQuery.findObjectsInBackground(block: { (orderObjects, error) in
                    if error == nil {
                        //return results
                        flutterResult(self.databaseHelper.objConverter.createMapsFromObjects(parseObjects: orderObjects!))
                    } else {
                        //error getting orders, return false
                        flutterResult(false)
                    }
                })
            }
            
            //method to get user's all orders
            else if flutterMethodCall.method == "getUserOrders" {
                self.orderHelper.getUserOrders(flutterResult: flutterResult)
            }
                
                //method to get user's active orders
            else if flutterMethodCall.method == "getUserActiveOrders" {
                self.orderHelper.getUserActiveOrders(flutterResult: flutterResult)
            }
                
                //method to get user's past orders
            else if flutterMethodCall.method == "getUserPastOrders" {
                self.orderHelper.getUserPastOrders(flutterResult: flutterResult)
            }
                
                //method to checkout user
            else if flutterMethodCall.method == "checkoutUser" {
                //get arguments
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let cartId = arguments["cartId"] as! String
                
                //prepare params
                let params = [
                    "userId": PFUser.current()!.objectId!,
                    "cartId": cartId
                ]
                
                //call cloud function to create order
                PFCloud.callFunction(inBackground: "createOrder", withParameters: params, block: { (result, error) in
                    if error == nil {
                        let resultMap = result as! [String : Any]
                        //call function to create RazorPay order
                        let rpParams = [
                            "orderId": resultMap["orderId"] as! String
                        ]
                        PFCloud.callFunction(inBackground: "createRazorPayOrder", withParameters: rpParams, block: { (result, error) in
                            if error == nil {
                                let rpResult = result as! [String : Any]
                                let checkoutOptions = [
                                    "name": "Eatzie",
                                    "description": "paying to mnb",
                                    "order_id": rpResult["razorpay_order_id"] as! String,
                                    "currency": "INR",
                                    "amount": "100"
                                ]
                                self.razorPay.open(checkoutOptions)
                            }
                        })
                    }
                })
            }
                
                //method to start checkout for user
//            else if flutterMethodCall.method == "checkoutUser" {
//                //get arguments
//                let arguments = flutterMethodCall.arguments as! [String : Any]
//                let cartId = arguments["cartId"] as! String
//
//                //prepare params
//                let params = [
//                    "userId": PFUser.current()!.objectId!,
//                    "cartId": cartId
//                ]
//
//                //call cloud function to create order
//                PFCloud.callFunction(inBackground: "createOrder", withParameters: params, block: { (result, error) in
//                    if error == nil {
//                        var resultDict = result as! [String : Any]
//
//                        //call method to get hash for order
//                        let params = [
//                            "userId": PFUser.current()!.objectId!,
//                            "orderId": resultDict["orderId"] as! String
//                        ]
//
//                        //call cloud function to generate hash for payment gateway
//                        PFCloud.callFunction(inBackground: "generateHashForOrder", withParameters: params, block: { (result, error) in
//                            if error == nil {
//                                let hashDict = result as! [String : Any]
//
//                                //got hash, start payu sequence
//                                print(String(resultDict["orderTotal"] as! Double))
//                                let txnParams = PUMTxnParam()
//                                txnParams.phone = "9483009001"
//                                txnParams.email = "krishnakeshan@gmail.com"
//                                txnParams.amount = String(resultDict["orderTotal"] as! Int)
//                                txnParams.environment = PUMEnvironment.production
//                                txnParams.firstname = "krishna"
//                                txnParams.key = "cSMqjMtA"
//                                txnParams.merchantid = "6780337"
//                                txnParams.txnID = (resultDict["orderId"] as! String)
//                                txnParams.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
//                                txnParams.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
//                                txnParams.productInfo = "food"
//                                txnParams.udf1 = "udf1"; txnParams.udf2 = "udf2"; txnParams.udf3 = "udf3";
//                                txnParams.udf4 = "udf4"; txnParams.udf5 = "udf5";
//                                txnParams.hashValue = (hashDict["hash"] as! String)
//
//                                //open payment view controller
//                                PlugNPlay.presentPaymentViewController(withTxnParams: txnParams, on: viewController, withCompletionBlock: { (response, error, id) in
//                                    if error != nil {
//                                        print(error!)
//                                    }
//
//                                    if response != nil {
//                                        print(response)
//                                    }
//
//                                    print(id)
//                                })
//                            }
//                        })
//                    }
//                })
//            }

            //method to save review
            else if flutterMethodCall.method == "saveReview" {
                //get arguments
                let arguments = flutterMethodCall.arguments as! [String : Any]
                let forId = arguments["forId"] as! String
                let rating = arguments["rating"] as! Int
                let review = arguments["review"] as! String
                let reviewType = arguments["reviewType"] as! String

                //call cloud function
                let params : [String : Any] = [
                    "fromId": PFUser.current()!.objectId!,
                    "forId": forId,
                    "rating": rating,
                    "review": review,
                    "reviewType": reviewType
                ]
                PFCloud.callFunction(inBackground: "saveReview", withParameters: params, block: { (result, error) in
                    //return result
                    if error == nil {
                        flutterResult(result)
                    } else {
                        flutterResult(false)
                    }
                })
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

//RazorPay Methods
extension AppDelegate: RazorpayPaymentCompletionProtocolWithData {
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
    }
}
