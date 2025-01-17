import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';

class WelcomeScreenWidget extends StatefulWidget {
  @override
  _WelcomeScreenWidgetState createState() {
    return _WelcomeScreenWidgetState();
  }
}

class _WelcomeScreenWidgetState extends State<WelcomeScreenWidget> {
  //Properties
  static const platform = const MethodChannel("com.qrilt.eatzie/main");
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
                  "Welcome To Eatzie",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                    _initiateLogin();
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
    try {
      print("going native");
      bool loginResult = await platform.invokeMethod("initiateLogin");
      print("returned from native $loginResult");

      //set state accordingly
      setState(() {
        isLoggedIn = loginResult;
      });
    } on PlatformException catch (e) {
      print("error initiating login: ${e.message}");
    }
  }
}
