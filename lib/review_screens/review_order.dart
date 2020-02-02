import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/custom_widgets/star_rating_widget.dart';
import 'package:eatzie/custom_widgets/list_view_items/review_order_list_view_item.dart';

import 'package:eatzie/model/order.dart';
import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/item.dart';

class ReviewOrderScreen extends StatefulWidget {
  //Properties
  final Location location;
  final Order order;
  final List<Item> items;

  //Constructors
  ReviewOrderScreen({this.location, this.order, this.items});

  //Methods
  @override
  _ReviewOrderScreenState createState() {
    return _ReviewOrderScreenState(
      location: location,
      order: order,
      items: items,
    );
  }
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen>
    implements RatingListener {
  //Properties
  Location location;
  Order order;
  List<Item> items;
  bool showThankYouMessage = false;

  var orderChannel = MethodChannel("com.qrilt.eatzie/order");

  //controllers for review text fields
  TextEditingController locationReviewController = TextEditingController();

  //rating fields
  int locationRating;
  Map<String, int> itemRatings = Map();
  Map<String, TextEditingController> itemReviews = Map();

  //Constructors
  _ReviewOrderScreenState({this.location, this.order, this.items});

  //Methods
  @override
  void initState() {
    super.initState();
  }

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
          Visibility(
            visible: !showThankYouMessage,
            child: IconButton(
              icon: Icon(
                Icons.check_circle,
                size: 24,
              ),
              color: Colors.green,
              onPressed: () {
                //code to save this rating and exit this screen
                _saveReviews();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          //Main Content (the other content is the thank you message)
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Center(
                  child: Text(
                    //Location Name Text
                    location.getName(),
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
                      id: location.getObjectId(),
                      ratingListener: this,
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
                      controller: locationReviewController,
                      textAlign: TextAlign.center,
                      maxLines: null,
                    ),
                  ),
                ),
                Divider(
                  height: 24,
                ),
                Column(
                  children: _getOrderItemReviewItems(),
                ),
              ],
            ),
          ),

          //Thank you message dialog
          Positioned.fill(
            child: Visibility(
              visible: showThankYouMessage,
              child: Container(
                color: Colors.black87,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //Some Icon
                      Container(
                        margin: EdgeInsets.only(top: 32),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.done_outline,
                          color: Colors.green,
                          size: 48,
                        ),
                      ),

                      //Thank You Text
                      Container(
                        margin: EdgeInsets.only(top: 32, left: 32, right: 32),
                        child: Text(
                          "Thank You For Your Review!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      //Thank You Text 2
                      Container(
                        margin: EdgeInsets.only(top: 16, left: 32, right: 32),
                        child: Text(
                          "Your reviews help maintain the quality of the platform",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      //Continue Button
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: FlatButton(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.green,
                          onPressed: () {
                            //close this screen
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //method to get review items for order items
  List<Widget> _getOrderItemReviewItems() {
    //create list of widgets
    List<Widget> reviewItems = List();

    for (OrderItem orderItem in order.orderItems) {
      //find corresponding Item for OrderItem
      for (Item item in items) {
        if (item.objectId == orderItem.itemId) {
          //create controller for item review and add to list
          TextEditingController itemReviewController = TextEditingController();
          itemReviews[item.objectId] = itemReviewController;

          //found Item
          reviewItems.add(
            ReviewOrderListViewItem(
              item: item,
              ratingListener: this,
              reviewController: itemReviewController,
            ),
          );

          //break from inner loop
          break;
        }
      }
    }

    //return created list
    return reviewItems;
  }

  //RatingListener Methods
  void onRatingSet(String id, int rating) {
    //rating was set for Location
    if (id == location.getObjectId()) {
      if (mounted) {
        setState(() {
          locationRating = rating;
          return;
        });
      }
    }

    //rating was set for Item
    else {
      if (mounted) {
        setState(() {
          itemRatings[id] = rating;
        });
      }
    }
  }

  //method to save reviews
  void _saveReviews() async {
    //show message of reviews being saved
    if (mounted) {
      setState(() {
        showThankYouMessage = true;
      });
    }

    //call method to save location review
    orderChannel.invokeMethod(
      "saveReview",
      {
        "forId": location.getObjectId(),
        "rating": locationRating,
        "review": locationReviewController.text,
        "reviewType": "location",
      },
    );

    //call method to save reviews for items
    for (OrderItem orderItem in order.orderItems) {
      if (itemRatings[orderItem.itemId] != null) {
        orderChannel.invokeMethod(
          "saveReview",
          {
            "forId": orderItem.itemId,
            "rating": itemRatings[orderItem.itemId],
            "review": itemReviews[orderItem.itemId].text,
            "reviewType": "item",
          },
        );
      }
    }
  }
}
