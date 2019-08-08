import 'package:flutter/material.dart';

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

  //controllers for review text fields
  TextEditingController locationReviewController = TextEditingController();
  List<TextEditingController> itemReviewControllers = List();

  //rating fields
  int locationRating;
  Map itemRatings = Map();

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
          IconButton(
            icon: Icon(
              Icons.check_circle,
              size: 24,
            ),
            color: Colors.green,
            onPressed: () {
              //code to save this rating and exit this screen
              print("location $locationRating");
              print("item $itemRatings");
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
          itemReviewControllers.add(itemReviewController);

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
}
