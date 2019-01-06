import 'package:flutter/material.dart';

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
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            backgroundColor: Colors.deepOrange,
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
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  "Near You",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 15, 16),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 200.0,
                padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    NearbyLocationListViewItem(),
                    NearbyLocationListViewItem(),
                    NearbyLocationListViewItem(),
                    NearbyLocationListViewItem(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NearbyLocationListViewItem extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Card(
      child: Container(
        width: 150,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  child: Image.network(
                    "https://www.theriverside.co.uk/images/Inside-Restaurant.jpg",
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
                  bottom: 8,
                  left: 8,
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 10,
                            color: Colors.red,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 1.0, right: 1.0),
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
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.link,
                            color: Colors.red,
                            size: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            child: Text(
                              "4",
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
            Container(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: Container(
                child: Text(
                  "Madouk Cafe",
                  style: TextStyle(
                    color: Color.fromARGB(255, 17, 15, 16),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment(0, 0),
              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: Text(
                "9429 friends have been here",
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
    );
  }
}
