import 'package:flutter/material.dart';

import 'package:eatzie/custom_widgets/list_view_items/location_list_view_item.dart';
import 'view_location.dart';

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
  final _tabTitles = ["Home", "Feed", "Inbox", "Orders", "Profile"];
  final _children = [
    HomeWidget(),
    HomeWidget(),
    HomeWidget(),
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
        centerTitle: false,
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 16,
            color: Colors.black,
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
          //Search Bar
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          margin: EdgeInsets.only(bottom: 8),
          color: Colors.white,
          elevation: 2,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.deepOrange,
                  size: 16,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 15, 17, 16),
                        fontSize: 14,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: "Find a Restaurant",
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

class NearbyLocationListViewItem extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        margin: EdgeInsets.fromLTRB(6, 10, 6, 10),
        child: Container(
          width: 150,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Image.network(
                          "https://www.theriverside.co.uk/images/Inside-Restaurant.jpg",
                          width: 150,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 2,
                        child: IconButton(
                          icon: Icon(Icons.bookmark),
                          color: Colors.white,
                          tooltip: "Bookmark",
                          onPressed: () {
                            print("bookmarked");
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Card(
                          color: Colors.white,
                          shape: StadiumBorder(),
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  size: 10,
                                  color: Colors.red,
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 1.0, right: 1.0),
                                  child: Text(
                                    "2.4",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
                child: Text(
                  "Madouk Cafe",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 15, 16),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment(0, 0),
                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                child: Text(
                  "12 friends have been here",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment(0, 0),
                  child: Text(
                    "0.5 kms away",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 4.0,
        clipBehavior: Clip.antiAlias,
      ),
      onTap: () {
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewLocationWidget();
            },
          ),
        );
      },
    );
  }
}
