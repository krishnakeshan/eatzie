import 'package:flutter/material.dart';

import 'package:eatzie/custom_widgets/list_view_items/item_review_list_view_item.dart';
import 'package:eatzie/custom_widgets/star_rating_widget.dart';

class ViewItemWidget extends StatefulWidget {
  @override
  _ViewItemWidgetState createState() {
    return _ViewItemWidgetState();
  }
}

class _ViewItemWidgetState extends State<ViewItemWidget> {
  //Widgets
  //Widget for "About" TabBarView
  Widget aboutItemWidget = Container(
    child: ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Text(
          //Name Text
          "Croissant",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Text(
            "This classic Croissant is made with 100 percent butter to create a golden, crunchy top and soft, flakey layers inside. The perfect match for a cup of Pike Place Roast.",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );

  //Widget for "Reviews" TabBarView
  Widget itemReviewsWidget = Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Container(
        //Current User Rating Container
        margin: EdgeInsets.all(8),
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          //Current User Rating Column
          children: <Widget>[
            Text(
              //Current User Rating Title Text
              "Your Reviews",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              //User Rating Star Widget Container
              margin: EdgeInsets.only(top: 10),
              child: StarRatingWidget(
                //User Rating Star Widget
                starIconSize: 20,
              ),
            ),
            Container(
              //User Rating Title Text Field Container
              margin: EdgeInsets.only(top: 16),
              child: TextField(
                //User Rating Title Text Field
                decoration: InputDecoration.collapsed(
                  hintText: "Write something about this",
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        //User Reviews Expanded
        child: ListView.builder(
          //User Reviews ListView
          itemBuilder: (buildContext, index) {
            return ItemReviewListViewItem();
          },
          itemCount: 30,
        ),
      ),
    ],
  );

  //Methods
  @override
  Widget build(BuildContext buildContext) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Croissant",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "About",
              ),
              Tab(
                text: "Reviews",
              ),
              Tab(
                text: "Photos",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            aboutItemWidget,
            itemReviewsWidget,
            Text("Third"),
          ],
        ),
      ),
      length: 3,
    );
  }
}
