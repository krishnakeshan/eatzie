import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eatzie/custom_widgets/list_view_items/order_item_list_view_item.dart';
import 'package:eatzie/review_order.dart';
import 'package:eatzie/custom_widgets/order_progress.dart';

class ViewOrderWidget extends StatefulWidget {
  @override
  _ViewOrderWidgetState createState() {
    return _ViewOrderWidgetState();
  }
}

class _ViewOrderWidgetState extends State<ViewOrderWidget> {
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
                    "Madouk Cafe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
          Container(
            //Location Address
            margin: EdgeInsets.only(top: 4),
            child: Text(
              "#3, Whitefield, Bangalore-32",
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
                    "20851",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
          Container(
            //Time Title
            margin: EdgeInsets.only(top: 10),
            child: Text("Placed On"),
          ),
          Container(
            //Time Text
            margin: EdgeInsets.only(top: 8),
            child: Text(
              "19 January, 2019 at 18:40",
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
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: <Widget>[
                Text(
                  "Order Status: ",
                  style: TextStyle(),
                ),
                Text(
                  "In Progress",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          OrderProgressWidget(),
          GestureDetector(
            //Review prompt gesture detector
            onTap: () {
              //open ReviewOrderWidget
              Navigator.push(
                buildContext,
                new MaterialPageRoute(
                  builder: (buildContext) {
                    return new ReviewOrderWidget();
                  },
                ),
              );
            },
            child: Card(
              //Review prompt card
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
                    Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(left: 8),
                      child: FloatingActionButton(
                        heroTag: "rateOrderFAB",
                        elevation: 2,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //open ReviewOrderWidget
                          Navigator.push(
                            buildContext,
                            new MaterialPageRoute(
                              builder: (buildContext) {
                                return new ReviewOrderWidget();
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
          Container(
            //Order Summary Title
            margin: EdgeInsets.only(top: 8),
            child: Text(
              "Order Summary",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            //Order Summary Column
            margin: EdgeInsets.only(top: 16),
            child: Column(
              children: <Widget>[
                OrderItemListViewItem(),
                OrderItemListViewItem(),
                OrderItemListViewItem(),
                OrderItemListViewItem(),
                OrderItemListViewItem(),
                OrderItemListViewItem(),
                OrderItemListViewItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
