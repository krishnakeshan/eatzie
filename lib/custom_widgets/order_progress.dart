import 'package:flutter/material.dart';

import 'package:eatzie/classes/Constants.dart';

class OrderProgressWidget extends StatefulWidget {
  //Properties
  final int statusCode;

  //Constructors
  OrderProgressWidget({this.statusCode});

  //Methods
  @override
  _OrderProgressWidgetState createState() {
    return _OrderProgressWidgetState(
      statusCode: statusCode,
    );
  }
}

class _OrderProgressWidgetState extends State<OrderProgressWidget> {
  //Properties
  int statusCode;

  //Constructors
  _OrderProgressWidgetState({this.statusCode});

  //Methods
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress1FAB",
                backgroundColor: statusCode >= 0
                    ? Constants.OrderStatusColors[0]
                    : Colors.grey,
                elevation: 2,
                child: Icon(Icons.cloud_upload),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: statusCode >= 0
                  ? Constants.OrderStatusColors[0]
                  : Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress2FAB",
                backgroundColor: statusCode >= 1
                    ? Constants.OrderStatusColors[1]
                    : Colors.grey,
                elevation: 2,
                child: Icon(Icons.check_circle),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: statusCode >= 1
                  ? Constants.OrderStatusColors[1]
                  : Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress3FAB",
                backgroundColor: statusCode >= 2
                    ? Constants.OrderStatusColors[2]
                    : Colors.grey,
                elevation: 2,
                child: Icon(Icons.hourglass_full),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: statusCode >= 2
                  ? Constants.OrderStatusColors[2]
                  : Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress4FAB",
                backgroundColor: statusCode >= 3
                    ? Constants.OrderStatusColors[3]
                    : Colors.grey,
                elevation: 2,
                child: Icon(Icons.shopping_basket),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: statusCode >= 3
                  ? Constants.OrderStatusColors[3]
                  : Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress5FAB",
                backgroundColor: statusCode >= 4
                    ? Constants.OrderStatusColors[4]
                    : Colors.grey,
                elevation: 2,
                child: Icon(Icons.check),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
