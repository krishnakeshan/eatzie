import 'package:flutter/material.dart';

class OrderPlacedConfirmationScreen extends StatefulWidget {
  //Properties
  //Constructors
  //Methods
  @override
  _OrderPlacedConfirmationScreenState createState() {
    return _OrderPlacedConfirmationScreenState();
  }
}

class _OrderPlacedConfirmationScreenState
    extends State<OrderPlacedConfirmationScreen> {
  //Properties
  //Constructors
  //Methods
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Confirmation Icon
          Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
          ),

          //Order Placed Text
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 32),
            child: Text(
              "Order Placed!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Updates Information
          Container(
            margin: EdgeInsets.only(top: 24, left: 32, right: 32),
            child: Text(
              "You will receive updates from the vendor soon",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          ),

          //Button to view order
          Container(
            margin: EdgeInsets.only(top: 32),
            child: RaisedButton.icon(
              color: Colors.green,
              label: Text(
                "View Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              onPressed: () {
                //open View Order screen
              },
            ),
          ),

          //Button to close this screen
          Container(
            margin: EdgeInsets.only(top: 16),
            child: FlatButton.icon(
              label: Text(
                "Close",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              icon: Icon(
                Icons.close,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () {
                //close this screen
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
