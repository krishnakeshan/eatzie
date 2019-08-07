import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_widgets/list_view_items/active_order_list_view_item.dart';

import 'package:eatzie/model/order.dart';

class OrdersTabWidget extends StatefulWidget {
  //Methods
  @override
  _OrdersTabWidgetState createState() {
    return _OrdersTabWidgetState();
  }
}

class _OrdersTabWidgetState extends State<OrdersTabWidget> {
  //Properties
  List<Order> orders = new List();

  static const orderChannel = MethodChannel("com.qrilt.eatzie/order");

  //Methods
  @override
  void initState() {
    super.initState();

    //get orders
    _getActiveOrders();
  }

  @override
  Widget build(BuildContext buildContext) {
    return DefaultTabController(
      //Default Tab Controller for Orders Tabs
      length: 2,
      child: Column(
        //Main Parent Column
        children: <Widget>[
          //Tab Bar
          TabBar(
            indicatorColor: Colors.deepOrange,
            indicatorWeight: 2,
            unselectedLabelColor: Colors.blueGrey,
            labelColor: Colors.deepOrange,
            tabs: <Widget>[
              Tab(
                text: "Active",
              ),
              Tab(
                text: "Past",
              ),
            ],
          ),
          //TabBarView
          Expanded(
            child: TabBarView(
              children: <Widget>[
                ListView.builder(
                  itemBuilder: (BuildContext buildContext, int index) {
                    return ActiveOrderListViewItem(
                      order: orders[index],
                    );
                  },
                  itemCount: orders.length,
                ),
                ListView(
                  children: <Widget>[
                    Text("Past Orders"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //method to get orders for this user
  void _getActiveOrders() async {
    //call method on order channel
    var result = await orderChannel.invokeMethod("getUserActiveOrders");

    //create list of objects
    print("got orders $result");
    if (mounted) {
      setState(() {
        orders = Order.createListFromMaps(result);
      });
    }
  }
}
