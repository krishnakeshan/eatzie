import 'package:flutter/material.dart';

import 'custom_widgets/list_view_items//active_order_list_view_item.dart';

class OrdersTabWidget extends StatefulWidget {
  @override
  _OrdersTabWidgetState createState() {
    return _OrdersTabWidgetState();
  }
}

class _OrdersTabWidgetState extends State<OrdersTabWidget> {
  //Widgets

  //Methods
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
                    return ActiveOrderListViewItem();
                  },
                  itemCount: 6,
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
}
