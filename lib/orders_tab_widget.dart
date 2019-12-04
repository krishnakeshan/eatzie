import 'package:flutter/material.dart';
import 'package:eatzie/AppManager.dart';

import 'custom_widgets/list_view_items/active_order_list_view_item.dart';
import 'custom_widgets/list_view_items/past_order_list_view_item.dart';

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
  AppManager appManager = AppManager.getInstance();

  List<Order> activeOrders = new List();
  List<Order> pastOrders = new List();

  //Methods
  @override
  void initState() {
    super.initState();

    //get active orders
    _getActiveOrders();

    //get past orders
    _getPastOrders();
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
                //TabBarView for Active Orders
                ListView.builder(
                  itemBuilder: (BuildContext buildContext, int index) {
                    return ActiveOrderListViewItem(
                      order: activeOrders[index],
                    );
                  },
                  itemCount: activeOrders.length,
                ),

                //TabBarView for Past Orders
                ListView.builder(
                  itemBuilder: (buildContext, index) {
                    return PastOrderListViewItem(
                      order: pastOrders[index],
                    );
                  },
                  itemCount: pastOrders.length,
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
    //call appManager method
    var result =
        await appManager.getUserActiveOrders(fromLocalDatastore: false);

    //create list of objects
    print("got orders $result");
    if (mounted) {
      setState(() {
        activeOrders = result;
      });
    }
  }

  //method to get past orders for this user
  void _getPastOrders() async {
    //call appManager method
    var result = await appManager.getUserPastOrders(fromLocalDataStore: false);

    //create list of objects
    if (mounted) {
      setState(() {
        pastOrders = result;
      });
    }
  }
}
