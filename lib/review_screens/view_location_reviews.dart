import 'package:eatzie/custom_widgets/list_view_items/entity_review_list_view_item.dart';
import 'package:flutter/material.dart';

import 'package:eatzie/AppManager.dart';

import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/review.dart';

class ViewLocationReviewsScreen extends StatefulWidget {
  //Properties
  final String locationId;

  //Constructors
  ViewLocationReviewsScreen({this.locationId});

  //Methods
  @override
  _ViewLocationReviewsScreenState createState() {
    return _ViewLocationReviewsScreenState(
      locationId: locationId,
    );
  }
}

class _ViewLocationReviewsScreenState extends State<ViewLocationReviewsScreen> {
  //Properties
  final String locationId;
  Location location;
  List<Review> reviews = List();
  double averageRating;
  bool isReviewsLoading = true;

  //Constructors
  _ViewLocationReviewsScreenState({this.locationId});

  //Methods
  @override
  void initState() {
    super.initState();

    //get location object
    _getLocation();

    //get reviews
    _getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${location != null ? location.getName() + " " : ""}Reviews",
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedCrossFade(
        crossFadeState: isReviewsLoading
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        //show normal body if reviews loaded
        firstChild: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //Average Rating Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Average Rating Text
                  Expanded(
                    child: Text(
                      "Average Rating",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //Average Rating Value
                  Container(
                    child: Text(
                      averageRating != null ? "$averageRating" : "...",
                      style: TextStyle(
                        color: averageRating != null
                            ? (averageRating >= 4
                                ? Colors.green
                                : averageRating >= 3 ? Colors.blue : Colors.red)
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Divider
            Divider(),

            //Reviews List
            Expanded(
              child: ListView.separated(
                itemBuilder: (buildContext, index) {
                  return EntityReviewListViewItem(
                    review: reviews[index],
                  );
                },
                separatorBuilder: (buildContext, index) {
                  return Divider();
                },
                itemCount: reviews.length,
              ),
            ),
          ],
        ),
        //show loading indicator if reviews are loading
        secondChild: Center(
          // child: Container(
          //   alignment: Alignment.center,
          //   width: 40,
          //   height: 40,
          //   child: CircularProgressIndicator(),
          // ),
          child: CircularProgressIndicator(),
        ),
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  //method to get location object
  _getLocation() async {
    //call AppManager method
    var locationMap = await AppManager.getInstance().getObjectWithId(
      className: "Location",
      objectId: locationId,
    );

    //create Location object from map
    if (mounted) {
      setState(() {
        location = Location.fromMap(locationMap);
      });
    }
  }

  _getReviews() async {
    //call platform channel method
    var reviewMaps = await AppManager.mainChannel.invokeMethod(
      "getReviewsForId",
      {
        "forId": locationId,
      },
    );

    //set loadingReviews to false
    if (mounted) {
      setState(() {
        isReviewsLoading = false;
      });
    }

    //create review objects from maps
    List<Review> reviews = List();
    for (var map in reviewMaps) {
      reviews.add(Review.fromMap(map));
    }

    //set reviews list
    if (mounted) {
      setState(() {
        this.reviews = reviews;

        //calculate average rating
        _calculateAverageRating();
      });
    }
  }

  //method to calculate average rating
  _calculateAverageRating() {
    double average = 0;
    if (reviews.isNotEmpty) {
      for (Review review in reviews) {
        average += review.rating;
      }

      if (mounted) {
        setState(() {
          averageRating = average / reviews.length;
        });
      }
    }
  }
}
