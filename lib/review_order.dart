import 'package:flutter/material.dart';

import 'package:eatzie/custom_widgets/star_rating_widget.dart';
import 'package:eatzie/custom_widgets/list_view_items/review_order_list_view_item.dart';

class ReviewOrderWidget extends StatefulWidget {
  @override
  _ReviewOrderWidgetState createState() {
    return _ReviewOrderWidgetState();
  }
}

class _ReviewOrderWidgetState extends State<ReviewOrderWidget> {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rate Your Experience",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            color: Colors.green,
            onPressed: () {
              //code to save this rating and exit this screen
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Center(
            child: Text(
              //Location Name Text
              "Madouk Cafe",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            //Location Rating Stars Center
            child: Container(
              //Location Rating Stars Container
              margin: EdgeInsets.only(top: 16, bottom: 16),
              child: StarRatingWidget(
                //Location Rating Stars Widget
                starIconSize: 24,
              ),
            ),
          ),
          ClipRRect(
            //Review Box Clip for Rounded Corners
            borderRadius: BorderRadius.circular(4),
            child: Container(
              //Review Text Field Container
              color: Color.fromARGB(255, 225, 225, 225),
              // margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(8),
              child: TextField(
                //Review Text Field
                decoration: InputDecoration.collapsed(
                  hintText: "Write a review?",
                ),
                textAlign: TextAlign.center,
                maxLines: null,
              ),
            ),
          ),
          Divider(
            height: 24,
          ),
          ReviewOrderListViewItem(),
          ReviewOrderListViewItem(),
          ReviewOrderListViewItem(),
          ReviewOrderListViewItem(),
          ReviewOrderListViewItem(),
        ],
      ),
    );
  }
}
