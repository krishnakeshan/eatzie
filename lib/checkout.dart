import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/model/cart.dart';

class CheckoutScreen extends StatefulWidget {
  //Properties
  final Cart cart;

  //Constructors
  CheckoutScreen({this.cart});

  //Methods
  @override
  _CheckoutScreenState createState() {
    return _CheckoutScreenState(
      cart: cart,
    );
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  //Properties
  Cart cart;

  static const orderChannel = MethodChannel("com.qrilt.eatzie/order");

  //Constructors
  _CheckoutScreenState({this.cart});

  //Methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Select Payment Method Title
          Container(
            color: Colors.deepOrange,
            padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Text(
              "Select Payment Method",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Payment Methods
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: <Widget>[
                //Pay Now
                Card(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      children: <Widget>[
                        //Pay Now Text
                        Container(
                          color: Colors.white70,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Pay Now",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        //Methods Available Text
                        Text(
                          "Methods Available",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 32,
          ),

          //Proceed Button
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: RaisedButton.icon(
              color: Colors.deepOrange,
              label: Text(
                "Proceed",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
              onPressed: () {
                //redirect
                _checkoutUser();
              },
            ),
          ),
        ],
      ),
    );
  }

  //method to check out the user
  void _checkoutUser() async {
    //call method on platform channel
    var result = await orderChannel.invokeMethod(
      "checkoutUser",
      {
        "cartId": cart.objectId,
      },
    );
  }
}
