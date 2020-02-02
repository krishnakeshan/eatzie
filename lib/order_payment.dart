import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:eatzie/AppManager.dart';

class OrderPaymentScreen extends StatefulWidget {
  //Properties
  final String orderId;
  final dynamic transactionInitResult;

  //Constructors
  OrderPaymentScreen({this.orderId, this.transactionInitResult});

  //Methods
  @override
  _OrderPaymentScreenState createState() {
    return _OrderPaymentScreenState(
      orderId: orderId,
      transactionInitResult: transactionInitResult,
    );
  }
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  //Properties
  final String orderId;
  final dynamic transactionInitResult;
  dynamic paymentModesInfo;

  final AppManager appManager = AppManager.getInstance();

  //Constructors
  _OrderPaymentScreenState({this.orderId, this.transactionInitResult});

  //Methods
  @override
  void initState() {
    super.initState();

    //get payment modes for this order
    _getPaymentModes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "We\'re Almost Done!",
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          //Amount Due Row
          Container(
            color: Color.fromARGB(15, 0, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //To Pay Title
                Expanded(
                  child: Text(
                    "To Pay : ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //Amount Text
                Text(
                  "Rs. ${transactionInitResult["total"]}",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          //Select Payment Method Title
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 12, top: 24, bottom: 8),
            child: Text(
              "Payment Method",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Divider
          Divider(
            height: 16,
          ),

          //get payment methods column
          _getPaymentMethodsColumn(),
        ],
      ),
    );
  }

  //method to get payment methods column
  Widget _getPaymentMethodsColumn() {
    //create list of widgets to put in column
    List<Widget> children = List();

    //add a widget for each available payment mode
    if (paymentModesInfo != null)
      for (var paymentMode in paymentModesInfo["body"]["merchantPayOption"]
          ["paymentModes"]) {
        children.add(
          _getWidgetForPaymentMethod(
            paymentMethodInfo: paymentMode,
          ),
        );

        //add a divider
        children.add(Divider());
      }

    return Column(
      children: children,
    );
  }

  //method to get the widget for an individual payment mode
  Widget _getWidgetForPaymentMethod({dynamic paymentMethodInfo}) {
    IconData iconData;

    switch (paymentMethodInfo["paymentMode"]) {
      case "BALANCE":
        iconData = Icons.account_balance_wallet;
        break;

      case "CREDIT_CARD":
        iconData = Icons.credit_card;
        break;

      case "DEBIT_CARD":
        iconData = Icons.credit_card;
        break;

      case "NET_BANKING":
        iconData = Icons.account_balance;
        break;
    }

    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            //Payment Method Name Text
            Expanded(
              child: Text(
                paymentMethodInfo["displayName"],
              ),
            ),

            //Payment Method Icon
            Icon(
              iconData,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
      onTap: () {
        //do something
      },
    );
  }

  //method to get available payment modes for this order
  _getPaymentModes() async {
    // print("getting payment modes");
    // //----------change this to production later
    // //got mid and transaction token, now make http call
    // final String url =
    //     "https://securegw-stage.paytm.in/fetchPaymentOptions?mid=${transactionInitResult["mid"]}&orderId=$orderId";
    // print("created modes link $url");
    // var response = await http.post(
    //   url,
    //   headers: {
    //     "Content-Type": "application/json",
    //   },
    //   body: jsonEncode(
    //     {
    //       "head": {
    //         "txnToken": transactionInitResult["transactionToken"],
    //       },
    //     },
    //   ),
    // );

    // if (mounted) {
    //   setState(() {
    //     paymentModesInfo = jsonDecode(response.body);
    //   });
    // }
  }
}
