import 'package:flutter/material.dart';

class ActiveOrderListViewItem extends StatefulWidget {
  @override
  _ActiveOrderListViewItemState createState() {
    return _ActiveOrderListViewItemState();
  }
}

class _ActiveOrderListViewItemState extends State<ActiveOrderListViewItem> {
  @override
  Widget build(BuildContext buildContext) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 2),
      padding: EdgeInsets.all(16),
      //Main Row
      child: Row(
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
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(child: )
        ],
      ),
    );
  }
}
