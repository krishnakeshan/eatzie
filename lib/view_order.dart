import 'package:eatzie/AppManager.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eatzie/custom_widgets/list_view_items/order_item_list_view_item.dart';
import 'package:eatzie/review_screens/review_order.dart';
import 'package:eatzie/custom_widgets/order_progress.dart';

import 'package:eatzie/classes/Constants.dart';

import 'package:eatzie/model/order.dart';
import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/item.dart';

class ViewOrderWidget extends StatefulWidget {
  //Properties
  final String orderId;
  final Order order;
  final Location location;
  final List<Item> items;

  //Constructors
  ViewOrderWidget({this.orderId, this.order, this.location, this.items});

  //Methods
  @override
  _ViewOrderWidgetState createState() {
    return _ViewOrderWidgetState(
      orderId: orderId,
      order: order,
      location: location,
      items: items,
    );
  }
}

class _ViewOrderWidgetState extends State<ViewOrderWidget> {
  //Properties
  String orderId;
  Order order;
  Location location;
  List<Item> items;

  AppManager appManager = AppManager.getInstance();

  //Constructors
  _ViewOrderWidgetState({this.orderId, this.order, this.location, this.items});

  //Methods
  @override
  void initState() {
    super.initState();

    //get order if not supplied
    if (order == null) {
      _getOrder();
    }

    //get items if items not supplied
    if (order != null && items == null) {
      _getItems();
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Info",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        //Main ListView for Body Widgets
        padding: EdgeInsets.all(16),
        children: <Widget>[
          //From Title
          Text("From"),
          Container(
            //Location Name and Call button
            margin: EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    location != null ? location.getName() : "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //Call Button
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      (Icons.call),
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                  onTap: () {},
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),

          //Location Address
          Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              location != null ? location.getAddress() : "",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),

          //Divider
          Divider(
            height: 20,
          ),

          //Order ID Title
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text("Order ID"),
          ),

          //Order ID Text
          Container(
            child: Row(
              children: [
                //Order ID Text Expanded
                Expanded(
                  child: Text(
                    order != null ? order.objectId : "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //Order QR Code button
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.qrcode,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Divider(
            height: 10,
          ),

          //Time Title
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text("Placed On"),
          ),

          //Time Text
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              order != null ? _getOrderTimestampString() : "",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Divider(
            height: 24,
          ),

          //Order Status Title
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: <Widget>[
                Text(
                  "Order Status: ",
                  style: TextStyle(),
                ),
                Text(
                  order != null
                      ? Constants.OrderStatusStrings[order.statusCode]
                      : "",
                  style: TextStyle(
                    color: order != null
                        ? Constants.OrderStatusColors[order.statusCode]
                        : Colors.transparent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          //Order Progress Widget
          OrderProgressWidget(
            statusCode: order != null ? order.statusCode : 0,
          ),

          //Review Prompt
          Visibility(
            //only show if order is completed
            visible: order != null ? order.statusCode == 4 : false,
            child: GestureDetector(
              //Review prompt gesture detector
              onTap: () {
                //open ReviewOrderWidget
                Navigator.push(
                  buildContext,
                  new MaterialPageRoute(
                    builder: (buildContext) {
                      return ReviewOrderScreen(
                        order: order,
                        location: location,
                        items: items,
                      );
                    },
                  ),
                );
              },

              //Review prompt card
              child: Card(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  //Review prompt container
                  padding: EdgeInsets.all(16),
                  child: Row(
                    //Main Row
                    children: <Widget>[
                      // Icon(
                      //   Icons.rate_review,
                      //   color: Colors.blue,
                      // ),
                      Expanded(
                        //Review Prompt Text Expanded
                        child: Container(
                          // margin: EdgeInsets.only(left: 16),
                          child: Column(
                            //Review Prompt Text Column
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                //Prompt heading Text
                                "We'd love to hear from you!",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text(
                                  "Please take a moment and rate this order",
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

                      //Rate order FAB
                      Container(
                        width: 35,
                        height: 35,
                        margin: EdgeInsets.only(left: 8),
                        child: FloatingActionButton(
                          heroTag: "rateOrderFAB",
                          elevation: 2,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            //open ReviewOrderWidget
                            Navigator.push(
                              buildContext,
                              new MaterialPageRoute(
                                builder: (buildContext) {
                                  return ReviewOrderScreen(
                                    order: order,
                                    location: location,
                                    items: items,
                                  );
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
            ),
          ),

          //Divider
          Divider(
            height: 32,
          ),

          //Order Summary Title
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              "Order Summary",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            //Order Summary Column
            margin: EdgeInsets.only(top: 16),
            child: Column(
              children: _getOrderItemsList(),
            ),
          ),

          //Divider
          Divider(
            height: 32,
          ),

          //Order Total Text
          Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: <Widget>[
                //Order Total Title
                Container(
                  child: Text(
                    "TOTAL:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),

                //Total Value
                Expanded(
                  child: Container(
                    child: Text(
                      order != null ? "Rs. ${order.total}" : "",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //method to get list of order items
  List<Widget> _getOrderItemsList() {
    List<Widget> orderItems = List();

    if (items == null) {
      return orderItems;
    }

    //add each item in order
    for (OrderItem orderItem in order.orderItems) {
      //find corresponding Item for this orderItem
      for (Item item in items) {
        if (item.objectId == orderItem.itemId) {
          //item found, add to list
          orderItems.add(
            OrderItemListViewItem(
              orderItem: orderItem,
              item: item,
            ),
          );

          //break from inner loop
          break;
        }
      }
    }

    //return created list
    return orderItems;
  }

  //method to get order
  _getOrder() async {
    //call platform method to fetch an object
    var orderMap = await appManager.getObjectWithId(
      className: "Order",
      objectId: orderId,
    );

    if (mounted) {
      setState(() {
        this.order = Order.fromMap(orderMap);
      });
    }

    //get location and items
    _getLocation();
    _getItems();
  }

  //method to get Location
  _getLocation() async {
    var locationMap = await appManager.getObjectWithId(
      className: "Location",
      objectId: order.location,
    );

    if (mounted) {
      setState(() {
        this.location = Location.fromMap(locationMap);
      });
    }
  }

  //method to get items of order
  void _getItems() async {
    //create temporary list
    List<Item> tempItems = List();
    for (OrderItem orderItem in order.orderItems) {
      var itemMap = await appManager.getObjectWithId(
        className: "Item",
        objectId: orderItem.itemId,
      );

      tempItems.add(Item.fromMap(map: itemMap));
    }

    //call setState
    if (mounted) {
      setState(() {
        items = tempItems;
      });
    }
  }

  //method to get order timestamp string
  String _getOrderTimestampString() {
    DateTime orderDate = order.createdAt;
    return "${orderDate.day}/${orderDate.month}/${orderDate.year} @ ${orderDate.hour}:${orderDate.minute}";
  }
}
