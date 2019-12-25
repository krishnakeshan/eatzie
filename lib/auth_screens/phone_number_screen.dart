import 'dart:async';

import 'package:eatzie/main.dart';
import 'package:flutter/material.dart';

import 'package:eatzie/AppManager.dart';
import 'package:flutter/services.dart';

class PhoneNumberScreen extends StatefulWidget {
  //Methods
  @override
  _PhoneNumberScreenState createState() {
    return _PhoneNumberScreenState();
  }
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  //Properties
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();
  bool showPhoneNumberScreen = true;
  bool verifyingPhoneWithCode = false;
  BuildContext lowerBuildContext;

  String verificationId = "";

  MethodChannel authChannel = MethodChannel("com.qrilt.eatzie/auth");

  //Methods
  @override
  void initState() {
    super.initState();

    //set handler for auth channel
    authChannel.setMethodCallHandler(
      (MethodCall methodCall) {
        //called when verification completes
        if (methodCall.method == "verificationCompleted") {
          //login the user
          _verifyPhoneNumberWithCode();
        }

        //called when verification fails
        else if (methodCall.method == "verificationFailed") {
          _showVerificationFailedMessage();
        }

        //called when verification code is sent
        else if (methodCall.method == "verificationCodeSent") {
          //retrieve verification id
          verificationId = methodCall.arguments["verificationId"];
        }

        return Future.value(0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (buildContext) {
        lowerBuildContext = buildContext;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: AnimatedCrossFade(
            crossFadeState: showPhoneNumberScreen
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _getPhoneNumberWidget(),
            secondChild: _getVerificationWidget(),
            duration: Duration(milliseconds: 500),
          ),
        );
      },
    );
  }

  Widget _getPhoneNumberWidget() {
    return Builder(
      builder: (buildContext) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Icon
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Icon(
                Icons.local_dining,
                color: Colors.blueAccent,
                size: 100,
              ),
            ),

            //Get Started Title
            Container(
              margin: EdgeInsets.only(left: 36, right: 36),
              child: Text(
                "Get Started",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Divider(
            //   height: 32,
            //   indent: 32,
            //   endIndent: 32,
            //   color: Colors.black54,
            // ),

            //Enter Phone Number Text
            Container(
              margin: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
              child: Text(
                "Please enter your phone number below to get started",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            //Phone Number Text Field
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  fillColor: Color.fromARGB(255, 50, 50, 50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Eg: 9876543210",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  prefix: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "+91",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.phone,
              ),
            ),

            //Verify Button
            Container(
              margin: EdgeInsets.only(top: 16),
              child: FlatButton.icon(
                icon: Icon(
                  Icons.arrow_forward,
                ),
                label: Text(
                  "CONTINUE",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                textColor: Colors.blueAccent[700],
                onPressed: () {
                  //call method to send verification code
                  _startPhoneVerification();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //method to get verification widget
  Widget _getVerificationWidget() {
    return Builder(
      builder: (buildContext) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Back Icon
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                iconSize: 24,
                onPressed: () {
                  _editPhoneNumber();
                },
              ),
            ),
            //We're Verifying Text
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "We\'re Verifying Your Number",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //Progress Indicator
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: LinearProgressIndicator(
                value: null,
              ),
            ),

            //Intimation Text
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              child: Text(
                "You may receive a verification code via SMS, please enter it below",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            //Code Text Field
            Container(
              width: 300,
              margin: EdgeInsets.only(top: 32, bottom: 32),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 50, 50, 50),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                decoration: InputDecoration.collapsed(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                keyboardType: TextInputType.number,
              ),
            ),

            //Verify Button
            FlatButton.icon(
              icon: Icon(
                Icons.done,
                color: Colors.blue,
              ),
              label: Text(
                "VERIFY",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: !verifyingPhoneWithCode
                  ? () {
                      //call method to verify
                      _verifyPhoneNumberWithCode();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  //method to send verification code
  _startPhoneVerification() async {
    //proceed if phone number field is not empty
    if (phoneNumberController.text.isNotEmpty) {
      var result = await AppManager.authChannel.invokeMethod(
        "startPhoneVerification",
        {
          "countryCode": "+91",
          "phoneNumber": phoneNumberController.text,
        },
      );

      //if result is true, show next screen
      if (result) {
        setState(() {
          showPhoneNumberScreen = false;
        });
      }
    }

    //show message for empty phone number
    else if (lowerBuildContext != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a valid phone number",
          ),
        ),
      );
    }
  }

  //method to verify phone with code
  _verifyPhoneNumberWithCode({bool verificationCompleted}) async {
    //set bool flag to disable button
    if (mounted) {
      setState(() {
        verifyingPhoneWithCode = true;
      });
    }

    //call platform channel method
    var result = await AppManager.authChannel.invokeMethod(
      "verifyPhoneWithCode",
      {
        "verificationCode": verificationCodeController.text,
        "verificationId": verificationId != null ? verificationId : "",
      },
    );

    //if login was successful, open main page
    if (result["success"]) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (buildContext) {
            return HomePage();
          },
        ),
      );
    } else {
      //error logging in
      print("error logging in");
    }

    //show message if empty
    // else if (lowerBuildContext != null) {
    //   Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         "Please enter a valid code",
    //       ),
    //     ),
    //   );
    // }
  }

  //method to show message that phone verification failed
  _showVerificationFailedMessage() {
    //show dialog
    if (lowerBuildContext != null) {
      showDialog(
        context: lowerBuildContext,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text("Oops, Verification Failed..."),
            content: Text(
              "Your phone number could not be verified.\n\n"
              "Please make sure:\n"
              "1. You entered the correct phone number.\n"
              "2. You entered the correct verification code\n"
              "3. You are connected to the Internet.\n"
              "4. You are able to receive SMS\n\n"
              "Please try again in sometime.",
            ),
            actions: <Widget>[
              //Close Button
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );
    }
  }

  //method to let user edit phone number
  _editPhoneNumber() {
    if (mounted) {
      setState(() {
        showPhoneNumberScreen = true;
      });
    }
  }
}
