import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/auth_screens/welcome_screen.dart';
import 'package:eatzie/auth_screens/phone_number_screen.dart';
import 'package:eatzie/custom_widgets/list_view_items/location_list_view_item.dart';
import 'cart.dart';
import 'orders_tab_widget.dart';
import 'profile_tab_widget.dart';

import 'model/location.dart';

void main() => runApp(EatzieApp());

class EatzieApp extends StatelessWidget {
  //Methods
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
  //Methods
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Properties
  bool _isUserLoggedIn;
  int _selectedIndex = 0;
  final _tabTitles = ["Home", "Orders", "Profile"];
  final _children = [HomeWidget(), OrdersTabWidget(), ProfileTabWidget()];

  static const authChannel = MethodChannel("com.qrilt.eatzie/auth");

  //Methods
  @override
  void initState() {
    super.initState();

    //check authentication status
    _getAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    //return normal view if user logged in
    if (_isUserLoggedIn != null && _isUserLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            _tabTitles[_selectedIndex],
            style: TextStyle(
              color: Colors.deepOrange,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.deepOrange,
              tooltip: "Cart(s)",
              onPressed: () {
                //open cart widget
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (buildContext) {
                      return CartWidget();
                    },
                  ),
                );
              },
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
          backgroundColor: Color.fromARGB(255, 240, 240, 240),
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.deepOrange,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.brightness_1,
                color: Colors.deepOrange,
              ),
              title: Text(
                "Orders",
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.face,
                color: Colors.deepOrange,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
              backgroundColor: Colors.white,
            ),
          ],
          onTap: (int selected) {
            setState(() {
              _selectedIndex = selected;
            });
          },
        ),
      );
    }

    //if auth status is being checked, return a loading screen
    else {
      return Scaffold(
        body: Center(
          child: Container(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  //method to get auth status
  void _getAuthStatus() async {
    //call auth channel method
    var authStatus = await authChannel.invokeMethod("getAuthStatus");

    //set authStatus
    if (mounted) {
      setState(() {
        _isUserLoggedIn = authStatus;
      });

      //if user is not logged in, show welcome screen
      if (!authStatus) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (buildContext) {
              return WelcomeScreenWidget();
            },
          ),
        );
      }
    }
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  //Properties
  static const platformChannel = MethodChannel("com.qrilt.eatzie/main");
  List<Location> locations = [];

  //Methods
  @override
  void initState() {
    super.initState();

    //fetch locations near this user
    getLocations();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Column(
      children: <Widget>[
        //Search Bar
        Card(
          //Search Bar Card
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          margin: EdgeInsets.zero,
          color: Colors.white,
          elevation: 0,
          child: Container(
            //Search Bar Row
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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

        //Small Divider
        Divider(
          color: Colors.grey,
          height: 0,
        ),

        //Locations ListView
        Expanded(
          child: ListView.builder(
            itemBuilder: (buildContext, index) {
              return LocationListViewItem(
                location: locations[index],
              );
            },
            itemCount: locations.length,
          ),
        ),
      ],
    );
  }

  //method to get locations near this user
  Future<void> getLocations() async {
    //locations will be an array of LinkedHashMaps, each one being a Location Parse Object
    var locations = await platformChannel.invokeMethod("getLocations");

    //create Location objects and push them onto locations array
    List<Location> newLocationsArray = List();
    for (var locationMap in locations) {
      newLocationsArray.add(Location.fromMap(locationMap));
    }

    //set state of widget
    setState(() {
      this.locations.clear();
      this.locations.addAll(newLocationsArray);
    });
  }
}
