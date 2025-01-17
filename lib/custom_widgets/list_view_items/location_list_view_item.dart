import 'package:flutter/material.dart';

import 'package:eatzie/view_location.dart';

import 'package:eatzie/model/location.dart';

class LocationListViewItem extends StatefulWidget {
  //Properties
  final Location location;

  //Constructors
  LocationListViewItem({this.location});

  //Methods
  @override
  _LocationListViewItemState createState() {
    return new _LocationListViewItemState(location: location);
  }
}

class _LocationListViewItemState extends State<LocationListViewItem> {
  //Properties
  Location location;

  //Constructors
  _LocationListViewItemState({this.location});

  //Methods
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      //Gesture Detector to Detect Taps on Main Container
      child: Container(
        //Main Container to give padding of 16
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
                  //Image View for Restaurant Image
                  location.getImageURL(),
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
                    location.getName(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  //Description Text
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text(
                      location.getDescription(),
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
            //Share Button
            IconButton(
              icon: Icon(Icons.share),
              iconSize: 20,
              color: Colors.deepOrange,
              tooltip: "Share this",
              onPressed: () {},
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewLocationWidget(
                location: location,
              );
            },
          ),
        );
      },
    );
  }
}
