import 'package:flutter/material.dart';

import 'package:eatzie/custom_icons/custom_icons_icons.dart';

class ProfileTabWidget extends StatefulWidget {
  @override
  _ProfileTabWidgetState createState() {
    return _ProfileTabWidgetState();
  }
}

class _ProfileTabWidgetState extends State<ProfileTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        //Main Body List View
        children: <Widget>[
          Center(
            //Center Widget for Profile Picture Stack View
            child: Container(
              //Container for Profile Picture Stack View to give top margin
              margin: EdgeInsets.only(top: 32),
              child: Stack(
                //Profile Picture Stack View
                children: <Widget>[
                  ClipOval(
                    //ClipOval object to make image rounded
                    child: Image.network(
                      //Main Image Object
                      "https://cdn.pixabay.com/photo/2015/09/02/13/24/girl-919048_960_720.jpg",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    //Positioned Object to position edit button
                    right: 0,
                    bottom: 0,
                    child: Container(
                      //Container to restrict edit button's size
                      width: 30,
                      height: 30,
                      child: FloatingActionButton(
                        //FAB for edit button
                        child: Icon(
                          Icons.edit,
                          size: 18,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            //Center Widget for Name Text Widget
            child: Container(
              //Container to give Name Text Widget a top margin
              margin: EdgeInsets.only(top: 30),
              child: Text(
                //Name Text Widget
                "John Doe",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Center(
            //Center widget for Edit button
            child: Container(
              //Container for Edit button
              child: FlatButton(
                //Main Flat Button
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ),

          //Account Information Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Phone Number
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //Title
                      Expanded(
                        child: Text(
                          "Phone Number",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      //Value
                      Expanded(
                        child: Text(
                          "9483009001",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 32,
                ),

                //Orders Placed
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //Title
                      Expanded(
                        child: Text(
                          "Orders Placed",
                          style: TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      //Value
                      Expanded(
                        child: Text(
                          "3",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Log out Button
          FlatButton.icon(
            splashColor: Colors.red,
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            label: Text(
              "Sign Out",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
