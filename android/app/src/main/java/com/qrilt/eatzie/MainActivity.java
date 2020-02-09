package com.qrilt.eatzie;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.FirebaseException;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.PhoneAuthCredential;
import com.google.firebase.auth.PhoneAuthProvider;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;
import com.google.firebase.messaging.FirebaseMessaging;
import com.parse.DeleteCallback;
import com.parse.FindCallback;
import com.parse.FunctionCallback;
import com.parse.GetCallback;
import com.parse.LogInCallback;
import com.parse.Parse;
import com.parse.ParseCloud;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;
import com.parse.SaveCallback;
import com.razorpay.Checkout;
import com.razorpay.PaymentData;
import com.razorpay.PaymentResultWithDataListener;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.TimeUnit;

import io.flutter.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements PaymentResultWithDataListener {
    // Properties
    private static final String authChannelName = "com.qrilt.eatzie/auth";
    private static final String mainChannelName = "com.qrilt.eatzie/main";
    private static final String cartChannelName = "com.qrilt.eatzie/cart";
    private static final String orderChannelName = "com.qrilt.eatzie/order";
    private static final String walletChannelName = "com.qrilt.eatzie/wallet";

    private DatabaseHelper databaseHelper = new DatabaseHelper();
    private MethodChannel authChannel;
    private MethodChannel mainChannel;
    private MethodChannel cartChannel;
    private MethodChannel orderChannel;
    private MethodChannel walletChannel;

    PhoneAuthCredential phoneAuthCredential;

    // Methods
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        // register auth channel and handler
        authChannel = new MethodChannel(getFlutterView(), authChannelName);
        authChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                // method to get current auth status
                if (methodCall.method.equals("getAuthStatus")) {
                    // first check with Firebase
                    if (FirebaseAuth.getInstance().getCurrentUser() != null) {
                        // logged in with Firebase, check with Parse
                        if (ParseUser.getCurrentUser() != null) {
                            // logged in with both, return true
                            result.success(true);
                            return;
                        }
                    }

                    // not logged in with anything, send back false
                    result.success(false);
                    return;
                }

                // method to send phone number verification code
                else if (methodCall.method.equals("startPhoneVerification")) {
                    // get arguments
                    String countryCode = methodCall.argument("countryCode");
                    String phoneNumber = methodCall.argument("phoneNumber");
                    String numberToVerify = "+" + countryCode + phoneNumber;

                    // define callbacks
                    PhoneAuthProvider.OnVerificationStateChangedCallbacks callbacks = new PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
                        @Override
                        public void onVerificationCompleted(PhoneAuthCredential credential) {
                            // store phoneAuthCredential for use later
                            phoneAuthCredential = credential;
                            // send message to flutter about completion of verification
                            authChannel.invokeMethod("verificationCompleted", null);
                        }

                        @Override
                        public void onVerificationFailed(FirebaseException e) {
                            authChannel.invokeMethod("verificationFailed", null);
                        }

                        @Override
                        public void onCodeSent(@NonNull String verificationId,
                                               @NonNull PhoneAuthProvider.ForceResendingToken token) {
                            HashMap<String, Object> arguments = new HashMap<>();
                            arguments.put("verificationId", verificationId);
                            authChannel.invokeMethod("verificationCodeSent", arguments);
                        }
                    };

                    // start verification
                    PhoneAuthProvider.getInstance().verifyPhoneNumber(numberToVerify, 60, TimeUnit.SECONDS,
                            MainActivity.this, callbacks);

                    // return true result
                    result.success(true);
                }

                // method to verify phone number with code
                else if (methodCall.method.equals("verifyPhoneWithCode")) {
                    // create result
                    HashMap<String, Object> resultMap = new HashMap<>();
                    // check if phoneAuthCredential is assigned
                    if (phoneAuthCredential == null) {
                        // phone auth credential was not assigned, get arguments to create it
                        String verificationCode = methodCall.argument("verificationCode");
                        String verificationId = methodCall.argument("verificationId");

                        // create phone credential object
                        phoneAuthCredential = PhoneAuthProvider.getCredential(verificationId, verificationCode);
                    }

                    // sign in with Firebase
                    FirebaseAuth.getInstance().signInWithCredential(phoneAuthCredential)
                            .addOnSuccessListener(new OnSuccessListener<AuthResult>() {
                                @Override
                                public void onSuccess(AuthResult authResult) {
                                    // call cloud function to get token for parse
                                    HashMap<String, Object> params = new HashMap<String, Object>();
                                    params.put("firebaseUserId", FirebaseAuth.getInstance().getCurrentUser().getUid());
                                    params.put("phoneNumber",
                                            FirebaseAuth.getInstance().getCurrentUser().getPhoneNumber());
                                    ParseCloud.callFunctionInBackground("logInUser", params,
                                            new FunctionCallback<HashMap<String, Object>>() {
                                                @Override
                                                public void done(HashMap<String, Object> object, ParseException e) {
                                                    if (e == null) {
                                                        if ((boolean) object.get("success")) {
                                                            // got session token, log in with Parse
                                                            ParseUser.becomeInBackground(
                                                                    (String) object.get("parseSessionToken"),
                                                                    new LogInCallback() {
                                                                        @Override
                                                                        public void done(ParseUser user,
                                                                                         ParseException e) {
                                                                            if (e == null) {
                                                                                // logged in with Parse, return true
                                                                                resultMap.put("success", true);
                                                                                result.success(resultMap);
                                                                            }
                                                                        }
                                                                    });
                                                        }
                                                    } else {
                                                        // error executing cloud function
                                                        e.printStackTrace();
                                                    }
                                                }
                                            });
                                }
                            }).addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            // failed to verify phone number, return false result
                            resultMap.put("success", false);
                            result.success(resultMap);
                        }
                    });
                }
            }
        });

        // register main channel and handler
        mainChannel = new MethodChannel(getFlutterView(), mainChannelName);
        mainChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                // method to get an object by id
                if (methodCall.method.equals("getObjectWithId")) {
                    // get arguments
                    String className = methodCall.argument("className");
                    String objectId = methodCall.argument("objectId");
                    boolean fromLocalDatastore = methodCall.argument("fromLocalDatastore");

                    // create parse query
                    ParseQuery<ParseObject> objectQuery = new ParseQuery<ParseObject>(className);

                    // determine source for data
                    if (fromLocalDatastore)
                        objectQuery.fromLocalDatastore();

                    // execute query
                    objectQuery.getInBackground(objectId, new GetCallback<ParseObject>() {
                        @Override
                        public void done(ParseObject object, ParseException e) {
                            if (e == null) {
                                // convert and send back a map
                                result.success(databaseHelper.parseObjectToMap(object));
                            } else {
                                // error occurred, return false
                                result.success(false);
                            }
                        }
                    });
                }

                // method to get all objects by class
                else if (methodCall.method.equals("getAllObjectsWithClass")) {
                    // get arguments
                    String className = methodCall.argument("className");
                    boolean fromLocalDatastore = methodCall.argument("fromLocalDatastore");

                    // create query
                    ParseQuery<ParseObject> objectsQuery = new ParseQuery<>(className);
                    if (fromLocalDatastore)
                        objectsQuery.fromLocalDatastore();
                    objectsQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                // found objects, return
                                result.success(databaseHelper.parseObjectsToMaps(objects));
                            } else {
                                // error occurred, return false
                                result.success(false);
                            }
                        }
                    });
                }

                // method to get locations
                else if (methodCall.method.equals("getLocations")) {
                    // create query
                    ParseQuery<ParseObject> locationsQuery = new ParseQuery<>("Location");
                    locationsQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                result.success(databaseHelper.parseObjectsToMaps(objects));
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }

                // method to get items for a location
                else if (methodCall.method.equals("getItemsForLocation")) {
                    // get arguments
                    String locationId = methodCall.argument("locationId");

                    // create query
                    ParseQuery<ParseObject> itemsQuery = new ParseQuery<>("Item");
                    itemsQuery.whereEqualTo("location", locationId);
                    itemsQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                // got objects, convert and return
                                result.success(databaseHelper.parseObjectsToMaps(objects));
                            } else {
                                // error, return false
                                result.success(false);
                            }
                        }
                    });
                }
            }
        });

        // register cart channel and handler
        cartChannel = new MethodChannel(getFlutterView(), cartChannelName);
        cartChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                // method to get the user's carts
                if (methodCall.method.equals("getUserCartObjects")) {
                    // create query
                    ParseQuery<ParseObject> cartsQuery = new ParseQuery<>("Cart");
                    cartsQuery.whereEqualTo("user", ParseUser.getCurrentUser().getObjectId());
                    cartsQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                result.success(databaseHelper.parseObjectsToMaps(objects));
                            }
                        }
                    });
                }

                // method to get a user's cart for a particular location
                else if (methodCall.method.equals("getUserCartForLocation")) {
                    // get arguments
                    String locationId = methodCall.argument("locationId");

                    // create query
                    ParseQuery<ParseObject> cartQuery = new ParseQuery<>("Cart");
                    cartQuery.whereEqualTo("user", ParseUser.getCurrentUser().getObjectId());
                    cartQuery.whereEqualTo("location", locationId);
                    cartQuery.getFirstInBackground(new GetCallback<ParseObject>() {
                        @Override
                        public void done(ParseObject object, ParseException e) {
                            if (e == null) {
                                // convert and return
                                result.success(databaseHelper.parseObjectToMap(object));
                            }
                        }
                    });
                }

                // method to add an item to a cart
                else if (methodCall.method.equals("addItemToCart")) {
                    // prepare parameters to call cloud function
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("userId", ParseUser.getCurrentUser().getObjectId());
                    params.put("itemId", methodCall.argument("itemId"));

                    // call cloud func
                    ParseCloud.callFunctionInBackground("addItemToCart", params, new FunctionCallback<Object>() {
                        @Override
                        public void done(Object object, ParseException e) {
                            if (e == null) {
                                // return true
                                result.success(true);
                            } else {
                                // return false
                                result.success(false);
                            }
                        }
                    });
                }

                // method to remove an item from cart
                else if (methodCall.method.equals("removeItemFromCart")) {
                    // prepare params to call cloud function
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("userId", ParseUser.getCurrentUser().getObjectId());
                    params.put("itemId", methodCall.argument("itemId"));

                    // call cloud function
                    ParseCloud.callFunctionInBackground("removeItemFromCart", params, new FunctionCallback<Object>() {
                        @Override
                        public void done(Object object, ParseException e) {
                            if (e == null) {
                                // return true
                                result.success(true);
                            } else {
                                // return false
                                result.success(false);
                            }
                        }
                    });
                }

                // method to check if a cart exists for a location and a user
                else if (methodCall.method.equals("doesCartExist")) {
                    // get arguments
                    String locationId = methodCall.argument("locationId");

                    // create query
                    ParseQuery<ParseObject> cartQuery = new ParseQuery<>("Cart");
                    cartQuery.whereEqualTo("user", ParseUser.getCurrentUser().getObjectId());
                    cartQuery.whereEqualTo("location", locationId);
                    cartQuery.selectKeys(Collections.singletonList("items"));
                    cartQuery.getFirstInBackground(new GetCallback<ParseObject>() {
                        @Override
                        public void done(ParseObject object, ParseException e) {
                            if (e == null) {
                                // return true if cart exists and isn't empty
                                if (object != null && object.getJSONArray("items").length() != 0) {
                                    result.success(true);
                                } else {
                                    // return false
                                    result.success(false);
                                }
                            }
                        }
                    });
                }

                //method to clear this cart
                else if (methodCall.method.equals("clearCart")) {
                    //get arguments
                    String cartId = methodCall.argument("cartId");

                    //call cloud function to clear this cart
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("cartId", cartId);
                    ParseCloud.callFunctionInBackground("clearCart", params, new FunctionCallback<Object>() {
                        @Override
                        public void done(Object object, ParseException e) {
                            if (e == null) {
                                result.success(object);
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }
            }
        });

        // register order channel and handler
        orderChannel = new MethodChannel(getFlutterView(), orderChannelName);
        orderChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                // method to sync user's active orders
                if (methodCall.method.equals("syncUserActiveOrders")) {
                    // create query to get orders
                    ParseQuery<ParseObject> ordersQuery = new ParseQuery<>("Order");
                    ordersQuery.whereEqualTo("user", ParseUser.getCurrentUser().getObjectId());
                    ordersQuery.whereLessThan("statusCode", 4);
                    ordersQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                // unpin all with this tag
                                ParseObject.unpinAllInBackground("activeOrders", new DeleteCallback() {
                                    @Override
                                    public void done(ParseException e) {
                                        if (e == null) {
                                            // unpinned, now pin new ones
                                            ParseObject.pinAllInBackground("activeOrders", objects, new SaveCallback() {
                                                @Override
                                                public void done(ParseException e) {
                                                    if (e == null) {
                                                        // pinned, return true
                                                        result.success(true);
                                                    } else {
                                                        result.success(false);
                                                    }
                                                }
                                            });
                                        } else {
                                            result.success(false);
                                        }
                                    }
                                });
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }

                // method to sync user past orders
                else if (methodCall.method.equals("syncUserPastOrders")) {
                    // create query to get orders
                    ParseQuery<ParseObject> ordersQuery = new ParseQuery<>("Order");
                    ordersQuery.whereEqualTo("user", ParseUser.getCurrentUser().getObjectId());
                    ordersQuery.whereEqualTo("statusCode", 4);
                    ordersQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                // unpin all with this tag
                                ParseObject.unpinAllInBackground("pastOrders", new DeleteCallback() {
                                    @Override
                                    public void done(ParseException e) {
                                        if (e == null) {
                                            // unpinned, now pin new ones
                                            ParseObject.pinAllInBackground("pastOrders", objects, new SaveCallback() {
                                                @Override
                                                public void done(ParseException e) {
                                                    if (e == null) {
                                                        // pinned, return true
                                                        result.success(true);
                                                    } else {
                                                        result.success(false);
                                                    }
                                                }
                                            });
                                        } else {
                                            result.success(false);
                                        }
                                    }
                                });
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }

                // method to retrieve user's active orders
                else if (methodCall.method.equals("getUserActiveOrders")) {
                    // get query source
                    boolean fromLocalDatastore = methodCall.argument("fromLocalDatastore");

                    // create query
                    ParseQuery<ParseObject> ordersQuery = new ParseQuery<>("Order");
                    ordersQuery.whereEqualTo("user", ParseUser.getCurrentUser().getObjectId());
                    ordersQuery.whereLessThan("statusCode", 4);

                    if (fromLocalDatastore)
                        ordersQuery.fromLocalDatastore();

                    // execute query
                    ordersQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                result.success(databaseHelper.parseObjectsToMaps(objects));
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }

                // method to retrieve user's past orders
                else if (methodCall.method.equals("getUserPastOrders")) {
                    // get query source
                    boolean fromLocalDatastore = methodCall.argument("fromLocalDatastore");

                    // create query
                    ParseQuery<ParseObject> ordersQuery = new ParseQuery<>("Order");
                    ordersQuery.whereEqualTo("user", ParseUser.getCurrentUser().getObjectId());
                    ordersQuery.whereEqualTo("statusCode", 4);

                    if (fromLocalDatastore)
                        ordersQuery.fromLocalDatastore();

                    // execute query
                    ordersQuery.findInBackground(new FindCallback<ParseObject>() {
                        @Override
                        public void done(List<ParseObject> objects, ParseException e) {
                            if (e == null) {
                                result.success(databaseHelper.parseObjectsToMaps(objects));
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }

                //method to create Order Razorpay Order
                else if (methodCall.method.equals("checkoutWithRazorpay")) {
                    //get arguments
                    String cartId = methodCall.argument("cartId");

                    //prepare params
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("userId", ParseUser.getCurrentUser().getObjectId());
                    params.put("cartId", cartId);

                    //call cloud function to create order
                    ParseCloud.callFunctionInBackground("createOrder", params, new FunctionCallback<HashMap<String, Object>>() {
                        @Override
                        public void done(HashMap<String, Object> object, ParseException e) {
                            if (e == null) {
                                //call function to create Razorpay order
                                HashMap<String, Object> rpParams = new HashMap<>();
                                rpParams.put("orderId", object.get("orderId"));

                                ParseCloud.callFunctionInBackground("createRazorpayOrder", rpParams, new FunctionCallback<HashMap<String, Object>>() {
                                    @Override
                                    public void done(HashMap<String, Object> object, ParseException e) {
                                        if (e == null) {
                                            //Razorpay order created, now initiate payment
                                            result.success(object);
                                        }
                                    }
                                });
                            }
                        }
                    });
                }

                //method to verify Order Razorpay payment
                else if (methodCall.method.equals("verifyOrderRazorpayPayment")) {
                    //get arguments
                    String orderId = methodCall.argument("orderId");
                    String razorpayOrderId = methodCall.argument("razorpayOrderId");
                    String razorpayPaymentId = methodCall.argument("razorpayPaymentId");
                    String razorpayPaymentSignature = methodCall.argument("razorpayPaymentSignature");

                    //call cloud function
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("orderId", orderId);
                    params.put("razorpayOrderId", razorpayOrderId);
                    params.put("razorpayPaymentId", razorpayPaymentId);
                    params.put("razorpayPaymentSignature", razorpayPaymentSignature);
                    ParseCloud.callFunctionInBackground("verifyOrderRazorpayPayment", params, new FunctionCallback<Object>() {
                        @Override
                        public void done(Object object, ParseException e) {
                            if (e == null) {
                                result.success(object);
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }

                // method to start checkout for user
                else if (methodCall.method.equals("checkoutUser")) {
                    // call method to preload payment methods
                    Checkout.preload(MainActivity.this);

                    // get arguments
                    String cartId = methodCall.argument("cartId");

                    // prepare params
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("userId", ParseUser.getCurrentUser().getObjectId());
                    params.put("cartId", cartId);

                    // call cloud function to create order
                    ParseCloud.callFunctionInBackground("createOrder", params,
                            new FunctionCallback<HashMap<String, Object>>() {
                                @Override
                                public void done(HashMap<String, Object> result, ParseException e) {
                                    if (e == null) {
                                        // call function to create razorpay order
                                        HashMap<String, Object> rpParams = new HashMap<>();
                                        rpParams.put("orderId", result.get("orderId"));

                                        ParseCloud.callFunctionInBackground("createRazorPayOrder", rpParams,
                                                new FunctionCallback<HashMap<String, Object>>() {
                                                    @Override
                                                    public void done(HashMap<String, Object> result, ParseException e) {
                                                        if (e == null) {
                                                            // RazorPay order created, now initiate payment
                                                            try {
                                                                Checkout checkout = new Checkout();
                                                                JSONObject options = new JSONObject();
                                                                options.put("name", "Eatzie");
                                                                options.put("description", "paying to mnb");
                                                                options.put("order_id",
                                                                        result.get("razorpay_order_id"));
                                                                options.put("currency", "INR");
                                                                options.put("amount", 5000);
                                                                checkout.open(MainActivity.this, options);
                                                            } catch (Exception exception) {
                                                                Log.d("DebugK", "JSON Exception occurred "
                                                                        + exception.getMessage());
                                                            }
                                                        }
                                                    }
                                                });
                                    }
                                }
                            });
                }

                // method to save a review for an order
                else if (methodCall.method.equals("saveReview")) {
                    // get arguments
                    String forId = methodCall.argument("forId");
                    int rating = methodCall.argument("rating");
                    String review = methodCall.argument("review");
                    String reviewType = methodCall.argument("reviewType");

                    // prepare arguments, and call cloud function
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("forId", forId);
                    params.put("rating", rating);
                    params.put("review", review);
                    params.put("reviewType", reviewType);

                    ParseCloud.callFunctionInBackground("saveReview", params, new FunctionCallback<Object>() {
                        @Override
                        public void done(Object object, ParseException e) {
                            if (e == null) {
                                result.success(object);
                            } else {
                                result.success(false);
                            }
                        }
                    });
                }
            }
        });

        // register wallet channel and handler
        walletChannel = new MethodChannel(getFlutterView(), walletChannelName);
        walletChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                // method to get wallet balance
                if (call.method.equals("getWalletBalance")) {
                    // call cloud function to get balance
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("userId", ParseUser.getCurrentUser().getObjectId());

                    ParseCloud.callFunctionInBackground("getWalletBalance", params,
                            new FunctionCallback<HashMap<String, Object>>() {
                                @Override
                                public void done(HashMap<String, Object> object, ParseException e) {
                                    if (e == null) {
                                        // return result map
                                        result.success(object);
                                    }
                                }
                            });
                }

                // method to create wallet recharge order
                else if (call.method.equals("createWalletRechargeOrder")) {
                    // get arguments
                    int amount = call.argument("amount");

                    // call cloud function to create order
                    HashMap<String, Object> params = new HashMap<>();
                    params.put("userId", ParseUser.getCurrentUser().getObjectId());
                    params.put("amount", amount);

                    ParseCloud.callFunctionInBackground("createWalletRechargeOrder", params,
                            new FunctionCallback<HashMap<String, Object>>() {
                                @Override
                                public void done(HashMap<String, Object> object, ParseException e) {
                                    if (e == null) {
                                        // return result map
                                        result.success(object);
                                    }
                                }
                            });
                }
            }
        });

        // call method to update FCM Token
        updateFCMToken();

        // call method to register notification channels
        registerNotificationChannels();
    }

    // method to updateFCMToken
    private void updateFCMToken() {
        if (ParseUser.getCurrentUser() != null) {
            FirebaseInstanceId.getInstance().getInstanceId()
                    .addOnSuccessListener(new OnSuccessListener<InstanceIdResult>() {
                        @Override
                        public void onSuccess(InstanceIdResult instanceIdResult) {
                            // got token, update it
                            HashMap<String, Object> params = new HashMap<>();
                            params.put("userId", ParseUser.getCurrentUser().getObjectId());
                            params.put("fcmToken", instanceIdResult.getToken());
                            ParseCloud.callFunctionInBackground("updateUserFCMToken", params);
                        }
                    }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                    // failed to retrieve token, log it
                    Log.d("DebugK", "Failed to retrieve FCM Token " + e.getMessage());
                }
            });
        }
    }

    // method to register notification channels
    private void registerNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String channelName = "main";
            String description = "Main Channel";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mainChannel = new NotificationChannel("main", channelName, importance);
            mainChannel.setDescription(description);

            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(mainChannel);
        }
    }

    @Override
    public void onPaymentSuccess(String paymentId, PaymentData paymentData) {

    }

    @Override
    public void onPaymentError(int code, String description, PaymentData paymentData) {

    }
}
