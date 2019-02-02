import 'package:flutter/material.dart';

class ItemReviewListViewItem extends StatefulWidget {
  @override
  _ItemReviewListViewItemState createState() {
    return _ItemReviewListViewItemState();
  }
}

class _ItemReviewListViewItemState extends State<ItemReviewListViewItem> {
  @override
  Widget build(BuildContext buildContext) {
    return Container(
      //Main Container
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.all(16),
      child: Column(
        //Main Column
        children: <Widget>[
          Row(
            //User Image, Name, and Rating Row
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                //User Image Oval
                child: Image.network(
                  //User Image
                  "https://cdn.pixabay.com/photo/2015/09/02/13/24/girl-919048_960_720.jpg",
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                //User Name Expanded
                child: Container(
                  //User Name Container
                  margin: EdgeInsets.only(left: 12),
                  child: Text(
                    //User Name Text
                    "Jane Doe",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Icon(
                //User Item Rating Star Icon
                Icons.star,
                size: 14,
                color: Colors.deepOrange,
              ),
              Container(
                //User Rating Text Container
                margin: EdgeInsets.only(left: 2, right: 8),
                child: Text(
                  //User Rating Text
                  "3.2",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Align(
            //User Review Title Align
            alignment: Alignment.centerLeft,
            child: Container(
              //User Review Title Container
              margin: EdgeInsets.only(top: 12),
              child: Text(
                //User Review Title Text
                "Kind of good",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Align(
            //User Review Text Align
            alignment: Alignment.centerLeft,
            child: Container(
              //User Review Text Container
              margin: EdgeInsets.only(top: 8),
              child: Text(
                //User Review Text
                "Great food with amazing packing. I had the penne arrabiata pasta which was excellent. Though a little less in quantity. The sauce was perfect",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              //Review Feedback Buttons Row
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  //Upvote Button Gesture Detector
                  child: Icon(
                    //Upvote Button Icon
                    Icons.thumb_up,
                    color: Colors.black,
                    size: 12,
                  ),
                ),
                Container(
                  //Upvote Count Container
                  margin: EdgeInsets.only(left: 4),
                  child: Text(
                    //Upvote Count Text
                    "43",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  //Downvote Button Container
                  margin: EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    //Downvote Button Gesture Detector
                    child: Icon(
                      //Downvote Button Icon
                      Icons.thumb_down,
                      color: Colors.grey,
                      size: 12,
                    ),
                  ),
                ),
                Container(
                  //Downvote Count Container
                  margin: EdgeInsets.only(left: 4),
                  child: Text(
                    //Downvote Count Text
                    "12",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
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
}
