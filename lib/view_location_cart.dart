import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/cart.dart';
import 'package:eatzie/model/item.dart';

import 'package:eatzie/checkout.dart';
import 'package:eatzie/custom_widgets/list_view_items/cart_item_list_view_item.dart';

import 'package:eatzie/classes/listeners/cart_listener.dart';

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

  static const mainChannel = MethodChannel("com.qrilt.eatzie/main");
  static const cartChannel = MethodChannel("com.qrilt.eatzie/cart");

  //Constructors
  _ViewLocationCartScreenState({this.locationId});

  //Methods
  @override
  void initState() {
    super.initState();

    //get location
    _getLocation();

    //get cart
    _getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
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
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

          //Divider
          // Container(
          //   height: 0.5,
          //   color: Colors.black87,
          // ),

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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            splashColor: Colors.orange,
            onTap: () {
              //open checkout page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (buildContext) {
                    return CheckoutScreen(
                      cart: cart,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  //method to get Location
  void _getLocation() async {
    //call method channel
    var locationMap = await mainChannel.invokeMethod(
      "getObjectWithId",
      {
        "className": "Location",
        "objectId": locationId,
      },
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

  //method to get cart total
  dynamic _getCartTotal() {
    double total = 0;
    if (cart != null && cart.cartItems.isNotEmpty) {
      for (CartItem cartItem in cart.cartItems) {
        if (cartItem.item.ppu != null && cartItem.quantity != null)
          total += cartItem.item.ppu * cartItem.quantity;
      }

      return total;
    } else {
      return "-";
    }
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
    var success =
        await cartChannel.invokeMethod("addItemToCart", item.objectId);

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
    var success =
        await cartChannel.invokeMethod("removeItemFromCart", item.objectId);

    //revert count if update failed
    if (!success) {
      setState(() {
        cart.cartItems[i].quantity--;
      });
    }
  }

  void onItemDeletedFromCart({Item item, BuildContext context}) async {}
}
