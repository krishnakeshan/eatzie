import 'package:flutter/material.dart';

import 'package:eatzie/custom_widgets/star_rating_widget.dart';

class ReviewOrderListViewItem extends StatefulWidget {
  @override
  _ReviewOrderListViewItemState createState() {
    return _ReviewOrderListViewItemState();
  }
}

class _ReviewOrderListViewItemState extends State<ReviewOrderListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Tea"),
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 12),
              child: StarRatingWidget(),
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
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
