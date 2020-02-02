import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/main.dart';

import 'package:eatzie/auth_screens/phone_number_screen.dart';

class WelcomeScreenWidget extends StatefulWidget {
  //Methods
  @override
  _WelcomeScreenWidgetState createState() {
    return _WelcomeScreenWidgetState();
  }
}

class _WelcomeScreenWidgetState extends State<WelcomeScreenWidget> {
  //Properties
  static const authChannel = const MethodChannel("com.qrilt.eatzie/auth");
  bool isLoggingIn = false;
  bool isLoggedIn = false;

  //Methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  isLoggingIn
                      ? "Logging You In, One Moment..."
                      : "Welcome To Eatzie",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //if login not in progress, show get started button
              Container(
                margin: EdgeInsets.only(top: 24),
                child: RaisedButton(
                  color: Colors.white,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    //call method to initiate login
                    // _initiateLogin();

                    //open phone number screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (buildContext) {
                          return PhoneNumberScreen();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //method to initiate login
  Future<void> _initiateLogin() async {
    bool loginResult = await authChannel.invokeMethod("initiateLogin");

    //set state accordingly
    if (mounted) {
      setState(() {
        isLoggedIn = loginResult;
      });

      //if user logged in, open home screen
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (buildContext) {
              return HomePage();
            },
          ),
        );
      }
    }
  }
}
