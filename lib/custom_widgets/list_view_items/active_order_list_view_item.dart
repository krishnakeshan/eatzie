import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/view_order.dart';

import 'package:eatzie/model/order.dart';
import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/item.dart';

class ActiveOrderListViewItem extends StatefulWidget {
  //Properties
  final Order order;

  //Constructors
  ActiveOrderListViewItem({this.order});

  //Methods
  @override
  _ActiveOrderListViewItemState createState() {
    return _ActiveOrderListViewItemState(order: order);
  }
}

class _ActiveOrderListViewItemState extends State<ActiveOrderListViewItem> {
  //Properties
  Order order;
  Location location;
  List<Item> items = new List();

  static const platformChannel = MethodChannel("com.qrilt.eatzie/main");

  //Constructors
  _ActiveOrderListViewItemState({this.order});

  //Methods
  @override
  void initState() {
    super.initState();

    //get location for this order
    _getLocation();

    //get items for this order
    _getItems();
  }

  @override
  Widget build(BuildContext buildContext) {
    //if not loaded, show loading
    if (location == null) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Container(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
          ),
        ),
      );
    }

    //if location and items loaded, show order
    return GestureDetector(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 2),
        padding: EdgeInsets.all(16),
        //Main Column
        child: Column(
          children: <Widget>[
            //Restaurant Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  //Restaurant Image Container
                  child: Card(
                    //Restaurant Image Card
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      //Restaurant Image xD
                      location.getImageURL(),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //Restaurant Text Info Expanded
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Name Text
                        Text(
                          location.getName(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                        //Address Text
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Text(
                            location.getAddress(),
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Order Status
                _getOrderStatusWidget(),
              ],
            ),
            //Order Items List
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Order:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        _getOrderItemsSummary(),
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Order Timestamp
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ordered on:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        order.createdAt,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Order Total
            Container(
              //Total Text Container
              margin: EdgeInsets.only(top: 6),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  //Order Total Text
                  "Rs. ${order.total}",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        //go to "ViewOrder" route
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewOrderWidget(
                order: order,
                location: location,
                items: items,
              );
            },
          ),
        );
      },
    );
  }

  //method to get order status widget
  Widget _getOrderStatusWidget() {
    if (order.statusCode == 0) {
      return Chip(
        backgroundColor: Colors.grey,
        label: Text(
          "Placed",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else if (order.statusCode == 1) {
      return Chip(
        backgroundColor: Colors.blue,
        label: Text(
          "Accepted",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else if (order.statusCode == 2) {
      return Chip(
        backgroundColor: Colors.red,
        label: Text(
          "In Progress",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else if (order.statusCode == 3) {
      return Chip(
        backgroundColor: Colors.green,
        label: Text(
          "Ready",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else {
      return Chip(
        backgroundColor: Colors.purple,
        label: Text(
          "Completed",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    }
  }

  //method to get summary of order items
  String _getOrderItemsSummary() {
    if (items.isNotEmpty) {
      String summary = "";
      for (OrderItem orderItem in order.orderItems) {
        //find matching Item from orderItem
        for (Item item in items) {
          if (item.objectId == orderItem.itemId) {
            //found matching object
            summary += "${orderItem.quantity} x ${item.name} | ";
          }
        }
      }
      return summary;
    }

    //else return empty string
    else {
      return "";
    }
  }

  //method to get Location for this order
  void _getLocation() async {
    var result = await platformChannel.invokeMethod(
      "getObjectWithId",
      {
        "className": "Location",
        "objectId": order.location,
      },
    );

    //call setState
    if (mounted) {
      setState(() {
        location = Location.fromMap(result);
      });
    }
  }

  //method to get Items for this order
  void _getItems() async {
    List<Item> items = List();
    for (OrderItem orderItem in order.orderItems) {
      var result = await platformChannel.invokeMethod(
        "getObjectWithId",
        {
          "className": "Item",
          "objectId": orderItem.itemId,
        },
      );

      //create Item objects and add to local list
      items.add(Item.fromMap(map: result));
    }

    //call setState
    if (mounted) {
      setState(() {
        this.items = items;
      });
    }
  }
}
