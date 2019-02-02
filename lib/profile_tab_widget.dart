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
          Divider(),
          Container(
            //Container for User Stats Row, to give it some padding
            padding: EdgeInsets.all(16),
            child: Row(
              //Row for User Stats
              children: <Widget>[
                Expanded(
                  //Expanded Widget to make sure all stats take up equal space
                  child: Column(
                    children: <Widget>[
                      Icon(
                        CustomIcons.followers,
                        size: 24,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Text(
                          "Followers",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Text(
                          "52",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  //Expanded Widget to make sure all stats take up equal space
                  child: Column(
                    children: <Widget>[
                      Icon(
                        CustomIcons.following,
                        size: 24,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Text(
                          "Following",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Text(
                          "100",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
