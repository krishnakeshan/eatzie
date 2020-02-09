import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/cart.dart';
import 'package:eatzie/model/item.dart';

import 'package:eatzie/order_placed_confirmation_screen.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:eatzie/custom_widgets/list_view_items/cart_item_list_view_item.dart';

import 'package:eatzie/classes/listeners/cart_listener.dart';

import 'package:eatzie/AppManager.dart';

class ViewLocationCartScreen extends StatefulWidget {
  //Properties
  final String locationId;

  //Constructors
  ViewLocationCartScreen({this.locationId});

  //Methods
  @override
  _ViewLocationCartScreenState createState() {
    return _ViewLocationCartScreenState(locationId: locationId);
  }
}

class _ViewLocationCartScreenState extends State<ViewLocationCartScreen>
    implements CartListener {
  //Properties
  String locationId;
  Location location;
  Cart cart;
  num walletBalance;

  bool showLoadingOverlay = false;
  String loadingOverlayTitle = "One Moment...";
  String loadingOverlaySubtitle = "Redirecting you to payment gateway";

  var orderCreationResult;

  Razorpay _razorpay;

  static const mainChannel = MethodChannel("com.qrilt.eatzie/main");
  static const cartChannel = MethodChannel("com.qrilt.eatzie/cart");

  //Constructors
  _ViewLocationCartScreenState({this.locationId});

  //Methods
  @override
  void initState() {
    super.initState();

    //init Razorpay
    _razorpay = Razorpay();

    //set callbacks for Razorpay
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    //get location
    _getLocation();

    //get cart
    _getCart();

    //get wallet balance
    _getWalletBalance();
  }

  //dispose
  @override
  void dispose() {
    super.dispose();

    //clear Razorpay methods
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Cart"),
              actions: <Widget>[
                //Delete Cart Button
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    //show dialog to clear cart
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text(
                            "Clear Cart",
                          ),
                          content: Text(
                            "Are you sure you want to clear this cart?",
                          ),
                          actions: <Widget>[
                            //Cancel Button
                            FlatButton(
                              child: Text(
                                "Cancel",
                              ),
                              onPressed: () {
                                //pop dialog
                                Navigator.pop(dialogContext);
                              },
                            ),

                            //Clear Button
                            FlatButton(
                              child: Text(
                                "Clear",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                //close this dialog
                                Navigator.pop(dialogContext);
                                //call method to clear cart
                                _clearCart();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  tooltip: "Clear Cart",
                ),
              ],
            ),

            //Main Body List View
            body: Column(
              children: <Widget>[
                //Location Name Text
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    location != null ? location.getName() : "          ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //Location address Text xD
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    location != null ? location.getAddress() : "          ",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                  ),
                ),

                //Divider
                Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  height: 0.5,
                  color: Colors.grey,
                ),

                //Cart Summary Title
                Container(
                  margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: Text(
                    "SUMMARY",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //cart items list
                Expanded(
                  child: Container(
                    child: ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemBuilder: (buildContext, index) {
                        return CartItemListViewItem(
                          cartItem: cart.cartItems[index],
                          cartListener: this,
                        );
                      },
                      separatorBuilder: (buildContext, index) {
                        return Container(
                          height: 0.5,
                          color: Colors.grey,
                        );
                      },
                      itemCount:
                          cart != null && cart.cartItems.first.item.name != null
                              ? cart.cartItems.length
                              : 0,
                    ),
                  ),
                ),

                //Checkout Row
                InkWell(
                  child: Ink(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        //Order Total Text
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Rs. ${_getCartTotal()}",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //Checkout Text
                        Expanded(
                          child: Container(
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        //Right Arrow
                        Container(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  splashColor: Colors.orange,
                  onTap: () {
                    //show payment method dialog
                    _showPaymentMethods();
                  },
                ),
              ],
            ),
          ),
        ),

        //loading overlay
        showLoadingOverlay
            ? Positioned.fill(
                child: Scaffold(
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //Title
                        Container(
                          child: Text(
                            loadingOverlayTitle,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //Subtitle
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 32),
                          child: Text(loadingOverlaySubtitle),
                        ),

                        //Loading Bar
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 32),
                          child: LinearProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  //method to get Location
  void _getLocation() async {
    //call method channel
    var locationMap = await AppManager.getInstance().getObjectWithId(
      className: "Location",
      objectId: locationId,
    );

    //create map if result not null
    if (locationMap != null && mounted) {
      setState(() {
        location = Location.fromMap(locationMap);
      });
    }
  }

  //method to get Cart for this Location and user
  void _getCart() async {
    var result = await cartChannel.invokeMethod(
      "getUserCartForLocation",
      {
        "locationId": locationId,
      },
    );

    //result should contain cart object
    if (result != null) {
      if (mounted) {
        setState(() {
          cart = Cart.fromMap(map: result);
        });
      }
    }

    //get cart items
    await cart.getCartItems();

    //call setState
    if (mounted) {
      setState(() {});
    }
  }

  //method to get Wallet balance
  _getWalletBalance() async {
    var result =
        await AppManager.walletChannel.invokeMethod("getWalletBalance");
    if (result["result"]) {
      if (mounted) {
        setState(() {
          walletBalance = result["walletBalance"];
        });
      }
    }
  }

  //method to show payment methods dialog
  _showPaymentMethods() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(
            "Select Payment Method",
          ),
          children: [
            //Invisible Divider
            Divider(
              color: Colors.transparent,
            ),

            //Pay Using Wallet Option
            SimpleDialogOption(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Wallet Icon
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),

                  //Pay with Wallet Text
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        walletBalance != null
                            ? "Eatzie Wallet (Rs. $walletBalance)"
                            : "Eatzie Wallet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  //Add Money button
                  FlatButton(
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              onPressed: () {
                //close dialog
                Navigator.pop(dialogContext);

                //process with wallet
              },
            ),

            Divider(),

            //Other Payment Options
            SimpleDialogOption(
              child: Row(
                children: [
                  //Credit Card Icon
                  Icon(
                    Icons.credit_card,
                    color: Colors.green,
                  ),

                  //Payment Methods Text
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Card, UPI, Wallets, Net Banking, etc.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                //remove this dialog
                Navigator.pop(dialogContext);

                //open payment screen
                _openPaymentScreen();
              },
            ),

            Divider(),

            //Pay At Vendor Option
            SimpleDialogOption(
              child: Row(
                children: [
                  //Location Icon
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),

                  //Payment Methods Text
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Pay At Vendor (Cash, Payment Apps, etc.)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                //close dialog
                Navigator.pop(dialogContext);

                //paying at vendor
              },
            ),

            Divider(),

            //Cancel Button
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //method to open payment screen
  _openPaymentScreen() async {
    //show overlay
    if (mounted) {
      setState(() {
        showLoadingOverlay = true;
      });
    }

    //first create order in backend
    var orderCreationResult = await AppManager.orderChannel.invokeMethod(
      "checkoutWithRazorpay",
      {
        "cartId": cart.objectId,
      },
    );

    //assign local variable
    this.orderCreationResult = orderCreationResult;

    var options = {
      'key': orderCreationResult['razorpay_key'],
      'amount': orderCreationResult['order_total'],
      'name': 'Eatzie',
      'currency': 'INR',
      'buttontext': 'Pay',
      'order_id': orderCreationResult['razorpay_order_id'],
    };
    _razorpay.open(options);
  }

  //method to get cart total
  dynamic _getCartTotal() {
    double total = 0;
    if (cart != null && cart.cartItems.isNotEmpty) {
      for (CartItem cartItem in cart.cartItems) {
        if (cartItem.item.ppu != null && cartItem.quantity != null)
          total += cartItem.item.ppu * cartItem.quantity;
      }

      return total / 100;
    } else {
      return "-";
    }
  }

  //method to show "Clear Cart" dialog
  _clearCart() async {
    //call cloud function to clear cart
  }

  //CartListener methods
  void onItemAddedToCart({Item item, BuildContext context}) async {
    //increment quantity on local object
    int i = 0;
    for (; i < cart.cartItems.length; i++) {
      CartItem cartItem = cart.cartItems[i];
      if (cartItem.item.objectId == item.objectId) {
        if (mounted) {
          setState(() {
            cart.cartItems[i].quantity += 1;
          });
        }
        break;
      }
    }

    //call platform channel method to update db
    var success = await cartChannel.invokeMethod(
      "addItemToCart",
      {
        "itemId": item.objectId,
      },
    );

    //revert count if update failed
    if (!success) {
      setState(() {
        cart.cartItems[i].quantity--;
      });
    }
  }

  void onItemRemovedFromCart({Item item, BuildContext context}) async {
    //decrement quantity on local object
    int i = 0;
    for (; i < cart.cartItems.length; i++) {
      CartItem cartItem = cart.cartItems[i];
      if (cartItem.item.objectId == item.objectId) {
        if (mounted) {
          setState(() {
            cart.cartItems[i].quantity -= 1;
          });
        }
        break;
      }
    }

    //call platform channel method to update db
    var success = await cartChannel.invokeMethod(
      "removeItemFromCart",
      {
        "itemId": item.objectId,
      },
    );

    //revert count if update failed
    if (!success) {
      setState(() {
        cart.cartItems[i].quantity--;
      });
    }
  }

  void onItemDeletedFromCart({Item item, BuildContext context}) async {}

  //Razorpay Methods
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //show verifying text
    if (mounted) {
      setState(() {
        loadingOverlayTitle = "One last step...";
        loadingOverlaySubtitle = "Verifying your payment";
      });
    }

    //verify payment
    var result = await AppManager.orderChannel.invokeMethod(
      "verifyOrderRazorpayPayment",
      {
        'orderId': orderCreationResult['order_id'],
        'razorpayOrderId': response.orderId,
        'razorpayPaymentId': response.paymentId,
        'razorpayPaymentSignature': response.signature
      },
    );

    if (result['result']) {
      //payment was successful, show confirmation screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (buildContext) {
            return OrderPlacedConfirmationScreen();
          },
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //dismiss loading overlay
    if (mounted) {
      setState(() {
        showLoadingOverlay = false;
      });
    }

    //show dialog for payment error
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Oops, we couldn't process your payment :("),
          content: Text(
            "Your transaction was either cancelled or an error occurred, please try again.\n\nAny deducted amount will be refunded to you.",
          ),
          actions: <Widget>[
            //OK Button
            FlatButton(
              child: Text(
                "OK",
              ),
              onPressed: () {
                //dismiss this dialog
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}
