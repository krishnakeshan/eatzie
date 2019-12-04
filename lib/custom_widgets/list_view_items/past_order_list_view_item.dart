import 'package:eatzie/AppManager.dart';
import 'package:flutter/material.dart';

import 'package:eatzie/model/order.dart';
import 'package:eatzie/model/location.dart';

import 'package:eatzie/view_order.dart';

class PastOrderListViewItem extends StatefulWidget {
  //Properties
  final Order order;

  //Constructors
  PastOrderListViewItem({this.order});

  //Methods
  @override
  _PastOrderListViewItemState createState() {
    return _PastOrderListViewItemState(
      order: order,
    );
  }
}

class _PastOrderListViewItemState extends State<PastOrderListViewItem> {
  //Properties
  Order order;
  Location location;

  AppManager appManager = AppManager.getInstance();

  //Constructors
  _PastOrderListViewItemState({this.order});

  //Methods
  @override
  void initState() {
    super.initState();

    //get location
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              //Location Information Column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Location Name
                  Text(
                    location != null ? location.getName() : "        ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  //Location Address
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Text(
                      location != null ? location.getAddress() : "     ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Vertical Divider
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: 1,
              height: 50,
              color: Colors.black26,
            ),

            //Order Time and Date
            Column(
              children: <Widget>[
                //Order date
                Text(
                  "${order.createdAtDate.day}/${order.createdAtDate.month}/${order.createdAtDate.year}",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),

                //At Text
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "@",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),

                //Order Time
                Container(
                  child: Text(
                    "${order.createdAtDate.hour}:${order.createdAtDate.minute}",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        //open view order screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewOrderWidget(
                order: order,
                location: location,
              );
            },
          ),
        );
      },
    );
  }

  //method to get location for this order
  void _getLocation() async {
    var result = await appManager.getObjectWithId(
      className: "Location",
      objectId: order.location,
    );

    //create location object from map
    if (mounted) {
      setState(() {
        location = Location.fromMap(result);
      });
    }
  }
}
