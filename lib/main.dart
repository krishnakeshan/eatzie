import 'package:flutter/material.dart';

import 'package:eatzie/custom_widgets/list_view_items/location_list_view_item.dart';
import 'view_location.dart';
import 'orders_tab_widget.dart';

void main() => runApp(EatzieApp());

class EatzieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatzie',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //properties
  int _selectedIndex = 0;
  final _tabTitles = ["Home", "Feed", "Orders", "Inbox", "Profile"];
  final _children = [
    HomeWidget(),
    HomeWidget(),
    OrdersTabWidget(),
    HomeWidget(),
    HomeWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_selectedIndex]),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.deepOrange,
            tooltip: "Cart(s)",
            onPressed: () {},
          )
        ],
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            title: Text("Feed"),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_1),
            title: Text("Orders"),
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            title: Text("Inbox"),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            title: Text("Profile"),
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int selected) {
          print("something");
          setState(() {
            _selectedIndex = selected;
          });
        },
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext buildContext) {
    return Column(
      children: <Widget>[
        Card(
          //Search Bar Card
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          margin: EdgeInsets.zero,
          color: Colors.white,
          elevation: 0,
          child: Container(
            //Search Bar Row
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Search Icon
                Icon(
                  Icons.search,
                  color: Colors.deepOrange,
                  size: 16,
                ),
                //Search Text Field Expanded
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 15, 17, 16),
                        fontSize: 14,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText:
                            "Restaurants, dishes, categories, anything...",
                        hintStyle: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0,
        ),
        //Restaurants ListView
        Expanded(
          child: ListView.builder(
            itemBuilder: (buildContext, index) {
              return LocationListViewItem();
            },
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
