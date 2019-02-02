import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eatzie/custom_widgets/star_rating_widget.dart';
import 'package:eatzie/view_item.dart';

/*
A class for the items in an order. Used in list view with builders mostly.
*/

class OrderItemListViewItem extends StatefulWidget {
  @override
  _OrderItemListViewItemState createState() {
    return _OrderItemListViewItemState();
  }
}

class _OrderItemListViewItemState extends State<OrderItemListViewItem> {
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          //Main Container
          child: Column(
            //Main Column
            children: <Widget>[
              Row(
                //Item Info Row
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //Item Image Container
                    child: Card(
                      //Item Image Card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        //Item Image! xD
                        "https://cdn.pixabay.com/photo/2015/09/02/12/43/meal-918639_960_720.jpg",
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    //Item Name and Price Expanded
                    child: Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //Item Name Text
                            "Tea",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            //Item Price Container
                            margin: EdgeInsets.only(top: 4),
                            child: Text(
                              //Item Price Text
                              "Rs. 12",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    //Quantity Card
                    color: Colors.blueGrey,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        //Quantity Text
                        "x3",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Item Rating and Total Row
              Divider(
                height: 20,
              ),
              Container(
                // margin: EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      //Existing Rating Star Icon
                      Icons.star,
                      size: 12,
                      color: Colors.deepOrange,
                    ),
                    Container(
                      //Existing Rating Text Container
                      margin: EdgeInsets.only(left: 2),
                      child: Text(
                        //Existing Rating Text
                        "3.4",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      //User Rating Expanded
                      child: Container(
                          // alignment: Alignment.center,
                          // child: StarRatingWidget(),
                          ),
                    ),
                    Container(
                      //Item Total Container
                      child: Text(
                        //Item Total Text
                        "Rs. 36",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewItemWidget();
            },
          ),
        );
      },
    );
  }
}
