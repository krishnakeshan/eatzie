import 'package:flutter/material.dart';

class OrderProgressWidget extends StatefulWidget {
  @override
  _OrderProgressWidgetState createState() {
    return _OrderProgressWidgetState();
  }
}

class _OrderProgressWidgetState extends State<OrderProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress1FAB",
                backgroundColor: Colors.grey,
                elevation: 2,
                child: Icon(Icons.check),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress2FAB",
                backgroundColor: Colors.green,
                elevation: 2,
                child: Icon(Icons.hourglass_empty),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress3FAB",
                backgroundColor: Colors.grey,
                elevation: 2,
                child: Icon(Icons.shopping_basket),
                onPressed: () {},
              ),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Expanded(
            child: Container(
              height: 35,
              child: FloatingActionButton(
                heroTag: "orderProgress4FAB",
                backgroundColor: Colors.grey,
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
