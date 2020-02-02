import 'package:flutter/material.dart';

import 'package:eatzie/AppManager.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class ViewWalletScreen extends StatefulWidget {
  //Properties

  //Constructors
  ViewWalletScreen();

  //Methods
  @override
  _ViewWalletScreenState createState() {
    return _ViewWalletScreenState();
  }
}

class _ViewWalletScreenState extends State<ViewWalletScreen> {
  //Properties
  TextEditingController amountController = TextEditingController();
  bool showAmountDialog = false;
  Razorpay _razorpay = Razorpay();

  //Constructors
  _ViewWalletScreenState();

  //Methods
  @override
  void initState() {
    super.initState();

    //setup Razorpay payment callbacks
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Eatzie Wallet",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Available Balance Text
                Container(
                  margin: EdgeInsets.only(top: 18),
                  child: Text(
                    "Available Balance",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Available Balance Value
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text(
                    "Rs. 84",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Divider
                Divider(
                  height: 36,
                ),

                //Transactions Text
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Transactions",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                //Transactions List
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: ListView(),
                  ),
                ),

                //Add Money Button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: RaisedButton.icon(
                    color: Colors.red,
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Add Money",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      //open alert requesting amount
                      _getAmount();
                    },
                  ),
                ),
              ],
            ),
          ),

          //Recharge Amount Dialog
          showAmountDialog
              ? Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //Enter Amount Text
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: Text(
                              "Enter Amount",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),

                          //Amount Text Field
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: TextField(
                              controller: amountController,
                              decoration: InputDecoration(
                                hintText: "Rs.",
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),

                          //Proceed Button
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: RaisedButton.icon(
                              color: Colors.green,
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Proceed",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                //open payment screen
                                _startWalletRecharge();
                              },
                            ),
                          ),

                          //Cancel Button
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: FlatButton.icon(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              label: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                //close dialog
                                _closeAmountDialog();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  //method to show amount dialog
  _getAmount() {
    //set showAmountDialog to true
    if (mounted) {
      setState(() {
        showAmountDialog = true;
      });
    }
  }

  //method to close amount dialog
  _closeAmountDialog() {
    if (mounted) {
      setState(() {
        showAmountDialog = false;
      });
    }
  }

  //method to start wallet recharge
  _startWalletRecharge() async {
    //create order for wallet recharge
    print("starting wallet recharge");
    var rechargeOrderResult = await AppManager.walletChannel.invokeMethod(
      "createWalletRechargeOrder",
      {
        "amount": int.parse(amountController.text),
      },
    );
    print("created order ${rechargeOrderResult["razorpay_order_id"]}");

    //open payment screen
    var options = {
      'key': 'rzp_test_pGg7BFZv2anSv9',
      'order_id': rechargeOrderResult["razorpay_order_id"],
      'amount': int.parse(amountController.text) * 100,
      'currency': 'INR',
      'name': 'Eatzie',
      'description': 'Wallet Recharge',
      'buttontext': 'Add Money'
    };
    _razorpay.open(options);
  }

  //method to handle payment success
  _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        "payment successful ${response.orderId} ${response.paymentId} ${response.signature}");
  }

  //method to handle payment error
  _handlePaymentError(PaymentFailureResponse response) {
    print("payment failed ${response.code} ${response.message}");
  }
}
