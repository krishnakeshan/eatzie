import 'package:flutter/material.dart';

import 'package:eatzie/view_location.dart';

class LocationListViewItem extends StatefulWidget {
  @override
  _LocationListViewItemState createState() {
    return new _LocationListViewItemState();
  }
}

class _LocationListViewItemState extends State<LocationListViewItem> {
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 2),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Card(
                elevation: 3,
                color: Colors.white54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  "https://cdn.pixabay.com/photo/2015/09/02/12/43/meal-918639_960_720.jpg",
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Name Text Widget
                  Text(
                    "Madouk Cafe",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  //Description Text
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text(
                      "Tea, Coffee, and Shawarma",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  //Box below Description
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Row(
                      children: <Widget>[
                        //Star Icon for Rating
                        Icon(
                          Icons.star,
                          color: Colors.deepOrange,
                          size: 11,
                        ),
                        //Rating Text
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            "4.5",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        //Friends Been Here Container
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.person,
                            color: Colors.blueGrey,
                            size: 11,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(
                            "34",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
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
      ),
      onTap: () {
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewLocationWidget();
            },
          ),
        );
      },
    );
  }
}
