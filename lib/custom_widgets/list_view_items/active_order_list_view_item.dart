import 'package:flutter/material.dart';

import 'package:eatzie/view_order.dart';

class ActiveOrderListViewItem extends StatefulWidget {
  @override
  _ActiveOrderListViewItemState createState() {
    return _ActiveOrderListViewItemState();
  }
}

class _ActiveOrderListViewItemState extends State<ActiveOrderListViewItem> {
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      onTap: () {
        //go to "ViewOrder" route
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewOrderWidget();
            },
          ),
        );
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 2),
        padding: EdgeInsets.all(16),
        //Main Column
        child: Column(
          children: <Widget>[
            //Restaurant Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  //Restaurant Image Container
                  child: Card(
                    //Restaurant Image Card
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      //Restaurant Image xD
                      "https://cdn.pixabay.com/photo/2015/09/02/12/43/meal-918639_960_720.jpg",
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //Restaurant Text Info Expanded
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Name Text
                        Text(
                          "Madouk Cafe",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                        //Address Text
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Text(
                            "Whitefield, Bangalore",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Order Status
                Chip(
                  backgroundColor: Colors.green,
                  label: Text(
                    "Ready!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            //Order Items List
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Order:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        "1 x Tea, 2 x Coffee",
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
            //Order Timestamp
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ordered on:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        "12 March 2019, 19:45",
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
            //Order Total
            Container(
              //Total Text Container
              margin: EdgeInsets.only(top: 6),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  //Order Total Text
                  "Rs. 130",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
