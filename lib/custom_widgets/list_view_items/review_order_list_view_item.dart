import 'package:flutter/material.dart';

import 'package:eatzie/custom_widgets/star_rating_widget.dart';

import 'package:eatzie/model/item.dart';

class ReviewOrderListViewItem extends StatefulWidget {
  //Properties
  final Item item;
  final RatingListener ratingListener;
  final TextEditingController reviewController;

  //Constructors
  ReviewOrderListViewItem(
      {this.item, this.ratingListener, this.reviewController});

  //Methods
  @override
  _ReviewOrderListViewItemState createState() {
    return _ReviewOrderListViewItemState(
      item: item,
      ratingListener: ratingListener,
      reviewController: reviewController,
    );
  }
}

class _ReviewOrderListViewItemState extends State<ReviewOrderListViewItem> {
  //Properties
  Item item;
  RatingListener ratingListener;
  TextEditingController reviewController;

  //Constructors
  _ReviewOrderListViewItemState(
      {this.item, this.ratingListener, this.reviewController});

  //Methods
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.name),
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 12),
              child: StarRatingWidget(
                id: item.objectId,
                ratingListener: ratingListener,
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
                  controller: reviewController,
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
