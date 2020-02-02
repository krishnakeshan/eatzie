import 'package:eatzie/AppManager.dart';
import 'package:flutter/material.dart';

import 'package:eatzie/model/review.dart';
import 'package:eatzie/model/user.dart';

class EntityReviewListViewItem extends StatefulWidget {
  //Properties
  final Review review;

  //Constructors
  EntityReviewListViewItem({this.review});

  //Methods
  @override
  _EntityReviewListViewItemState createState() {
    return _EntityReviewListViewItemState(
      review: review,
    );
  }
}

class _EntityReviewListViewItemState extends State<EntityReviewListViewItem> {
  //Properties
  final Review review;
  User user;

  //Constructors
  _EntityReviewListViewItemState({this.review});

  //Methods
  @override
  void initState() {
    super.initState();

    //get user
    // _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //User Info and Rating Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //User Name
              Text(
                user != null ? user.name : "John",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),

              //Rating Star Icon
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.red,
                ),
              ),

              //Rating Text
              Container(
                margin: EdgeInsets.only(left: 4),
                child: Text(
                  "${review.rating}",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          //User Review Text
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              review.review,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //method to get user for review
  _getUser() async {
    var result = await AppManager.getInstance().getUserById(
      userId: review.fromId,
    );

    //call setState
    if (mounted) {
      setState(() {
        user = result;
      });
    }
  }
}
