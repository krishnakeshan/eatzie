import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'custom_widgets/card_image_view.dart';
import 'custom_widgets/list_view_items/location_menu_item.dart';

import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/item.dart';

class ViewLocationWidget extends StatefulWidget {
  //Properties
  final Location location;

  //Constructors
  ViewLocationWidget({this.location});

  //Methods
  @override
  _ViewLocationWidgetState createState() =>
      _ViewLocationWidgetState(location: location);
}

class _ViewLocationWidgetState extends State<ViewLocationWidget>
    with SingleTickerProviderStateMixin {
  //Properties
  Location location;
  List<Item> items = List();
  bool isBookmarked = false;
  TabController _tabController;

  static const platformChannel = MethodChannel("com.qrilt.eatzie/main");

  //Constructors
  _ViewLocationWidgetState({this.location});

  //Mutable Widgets
  Icon bookmarkIcon;

  //Photos Tab View
  Widget photosTab = CustomScrollView(
    slivers: <Widget>[
      SliverList(
        delegate: SliverChildBuilderDelegate((buildContext, index) {
          return CardImageView(
            source:
                "https://cdn.pixabay.com/photo/2014/11/05/15/57/salmon-518032_960_720.jpg",
          );
        }, childCount: 3),
      )
    ],
  );

  Widget photosTabView = ListView(
    padding: EdgeInsets.only(top: 10),
    children: <Widget>[
      CardImageView(
        source:
            "https://cdn.pixabay.com/photo/2014/11/05/15/57/salmon-518032_960_720.jpg",
      ),
      CardImageView(
        source:
            "https://cdn.pixabay.com/photo/2014/11/05/15/57/salmon-518032_960_720.jpg",
      ),
    ],
  );

  //Methods
  @override
  void initState() {
    super.initState();

    //initialize tab controller
    _tabController = TabController(length: 4, vsync: this);

    //get items for this location
    _getItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    //decide widget states
    if (isBookmarked) {
      bookmarkIcon = Icon(
        Icons.bookmark,
        color: Colors.deepOrange,
      );
    } else {
      bookmarkIcon = Icon(
        Icons.bookmark_border,
      );
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(buildContext).padding.top),
        child: NestedScrollView(
          headerSliverBuilder: (buildContext, isInnerBoxScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: Border(),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      //Close / Back Button
                      Container(
                        child: Align(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(buildContext);
                            },
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      //Name and Bookmark Row
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                location.getName(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            //Bookmark Button
                            AnimatedCrossFade(
                              duration: Duration(milliseconds: 500),
                              firstChild: IconButton(
                                icon: Icon(Icons.bookmark),
                                color: Color.fromARGB(255, 252, 100, 100),
                                iconSize: 28,
                                tooltip: "Bookmarked!",
                                onPressed: () {
                                  setState(() {
                                    isBookmarked = !isBookmarked;
                                  });
                                },
                              ),
                              secondChild: IconButton(
                                icon: Icon(Icons.bookmark_border),
                                color: Color.fromARGB(255, 252, 100, 100),
                                iconSize: 28,
                                tooltip: "Bookmark this location",
                                onPressed: () {
                                  setState(() {
                                    isBookmarked = !isBookmarked;
                                  });
                                },
                              ),
                              crossFadeState: isBookmarked
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                            ),
                            //Share Button
                            IconButton(
                              icon: Icon(Icons.share),
                              color: Color.fromARGB(255, 252, 100, 100),
                              tooltip: "Share",
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      //About Row
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Tea, and Biscuits",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Rating Row
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //Rating Text
                            Container(
                              margin: EdgeInsets.only(right: 4.0),
                              child: Text(
                                "4.3",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 252, 100, 100),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            //Rating Star
                            Container(
                              child: Icon(
                                FontAwesomeIcons.solidStar,
                                size: 14,
                                color: Color.fromARGB(255, 252, 100, 100),
                              ),
                            ),
                            //Tap to see reviews Text
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                "Tap to see reviews",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    isScrollable: false,
                    controller: _tabController,
                    indicatorColor: Colors.deepOrange,
                    indicatorWeight: 2.5,
                    labelColor: Color.fromARGB(255, 252, 100, 100),
                    unselectedLabelColor: Colors.blueGrey,
                    tabs: <Widget>[
                      Tab(
                        text: "Menu",
                      ),
                      Tab(
                        text: "Photos",
                      ),
                      Tab(
                        text: "Offers",
                      ),
                      Tab(
                        text: "Contact",
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Container(
            //TabBarView
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                getMenuTabView(),
                photosTabView,
                Text("Third"),
                Text("Fourth"),
              ],
            ),
          ),
        ),
      ),
    );
  }

//method to get Menu Tab View
  Widget getMenuTabView() {
    return Builder(builder: (buildContext) {
      return Container(
        child: Column(
          children: <Widget>[
            //Search Bar Card
            Card(
              elevation: 4,
              margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
              shape: StadiumBorder(),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                //Search Bar Inner Row
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Search Icon
                    Icon(
                      Icons.search,
                      color: Colors.deepOrange,
                      size: 16,
                    ),
                    //Search Text Field
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 12),
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Search dishes, categories, etc.",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Items List View
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (buildContext, index) {
                  return LocationMenuListViewItem(
                    item: items[index],
                  );
                },
                itemCount: items.length,
              ),
            ),
          ],
        ),
      );
    });
  }

  //method to get items for this location
  Future<void> _getItems() async {
    print("inside getItems");
    //'items' will be a list of LinkedHashMaps each repre. a Item Parse Object
    var items = await platformChannel.invokeMethod(
        "getItemsForLocation", location.getObjectId());

    //for each item LinkedHashMap create an Item object
    List<Item> newItems = List();
    for (var item in items) {
      Item newItem = Item();
      newItem.objectId = item["objectId"];
      newItem.setCreatedAt(item["createdAt"]);
      newItem.imageURL = item["imageURL"];
      newItem.name = item["name"];
      newItem.description = item["description"];
      newItem.ppu = item["ppu"].toDouble();
      newItems.add(newItem);
    }

    //call setState
    setState(() {
      this.items.clear();
      this.items.addAll(newItems);
    });
  }
}

// class _ViewLocationWidgetState extends State<ViewLocationWidget>
//     with SingleTickerProviderStateMixin {
//   //Properties
//   bool isBookmarked = false;
//   TabController _tabController;

//   //Mutable Widgets
//   Icon bookmarkIcon;

//   //Inner Widgets
//   //Menu Tab View
//   Widget menuTabView = Container(
//     child: Column(
//       children: <Widget>[
//         Card(
//           elevation: 4,
//           margin: EdgeInsets.fromLTRB(12, 16, 12, 0),
//           shape: StadiumBorder(),
//           color: Colors.white,
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               vertical: 10,
//               horizontal: 10,
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Icon(
//                   Icons.search,
//                   color: Colors.deepOrange,
//                   size: 16,
//                 ),
//                 Expanded(
//                   child: Container(
//                     margin: EdgeInsets.only(left: 12),
//                     child: TextField(
//                       decoration: InputDecoration.collapsed(
//                         hintText: "Search dishes, categories, etc.",
//                         hintStyle: TextStyle(
//                           fontSize: 14,
//                           color: Colors.blueGrey,
//                         ),
//                       ),
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );

//   //Photos Tab View
//   Widget photosTabView = ListView(
//     padding: EdgeInsets.only(top: 10),
//     children: <Widget>[
//       CardImageView(
//         source:
//             "https://cdn.pixabay.com/photo/2014/11/05/15/57/salmon-518032_960_720.jpg",
//       ),
//       Container(
//         margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
//         child: Card(
//           elevation: 4,
//           color: Colors.grey,
//           margin: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Image.network(
//             "https://cdn.pixabay.com/photo/2014/11/05/15/57/salmon-518032_960_720.jpg",
//             fit: BoxFit.fitWidth,
//           ),
//           clipBehavior: Clip.antiAlias,
//         ),
//       ),
//     ],
//   );

//   //Methods
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext buildContext) {
//     //decide widget states
//     if (isBookmarked) {
//       bookmarkIcon = Icon(
//         Icons.bookmark,
//         color: Colors.deepOrange,
//       );
//     } else {
//       bookmarkIcon = Icon(
//         Icons.bookmark_border,
//       );
//     }
//     return Scaffold(
//       body: ListView(
//         children: <Widget>[
//           //Header. Contains: Close, Name and Bookmark, Rating
//           Card(
//             margin: EdgeInsets.zero,
//             elevation: 2,
//             shape: Border(),
//             color: Colors.white,
//             child: Column(
//               children: <Widget>[
//                 //Close / Back Button
//                 Container(
//                   child: Align(
//                     child: IconButton(
//                       icon: Icon(Icons.arrow_back),
//                       onPressed: () {
//                         Navigator.pop(buildContext);
//                       },
//                     ),
//                     alignment: Alignment.centerLeft,
//                   ),
//                 ),
//                 //Name and Bookmark Row
//                 Container(
//                   padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: Text(
//                           "Madouk Cafe",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       //Bookmark Button
//                       AnimatedCrossFade(
//                         duration: Duration(milliseconds: 500),
//                         firstChild: IconButton(
//                           icon: Icon(Icons.bookmark),
//                           color: Color.fromARGB(255, 252, 100, 100),
//                           iconSize: 28,
//                           tooltip: "Bookmarked!",
//                           onPressed: () {
//                             setState(() {
//                               isBookmarked = !isBookmarked;
//                             });
//                           },
//                         ),
//                         secondChild: IconButton(
//                           icon: Icon(Icons.bookmark_border),
//                           color: Color.fromARGB(255, 252, 100, 100),
//                           iconSize: 28,
//                           tooltip: "Bookmark this location",
//                           onPressed: () {
//                             setState(() {
//                               isBookmarked = !isBookmarked;
//                             });
//                           },
//                         ),
//                         crossFadeState: isBookmarked
//                             ? CrossFadeState.showFirst
//                             : CrossFadeState.showSecond,
//                       ),
//                       //Call Button
//                       IconButton(
//                         icon: Icon(Icons.call),
//                         color: Color.fromARGB(255, 252, 100, 100),
//                         tooltip: "Call",
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//                 ),
//                 //About Row
//                 Container(
//                   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                   child: Row(
//                     children: <Widget>[
//                       Text(
//                         "Seafood, Tea, and Biscuits",
//                         style: TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 //Rating Row
//                 Container(
//                   padding: EdgeInsets.fromLTRB(20, 10, 20, 12),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       //Rating Text
//                       Container(
//                         margin: EdgeInsets.only(right: 4.0),
//                         child: Text(
//                           "4.3",
//                           style: TextStyle(
//                             color: Color.fromARGB(255, 252, 100, 100),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       //Rating Star
//                       Container(
//                         child: Icon(
//                           FontAwesomeIcons.solidStar,
//                           size: 14,
//                           color: Color.fromARGB(255, 252, 100, 100),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           //TabBar
//           TabBar(
//             isScrollable: false,
//             controller: _tabController,
//             indicatorColor: Colors.deepOrange,
//             indicatorWeight: 2.5,
//             labelColor: Color.fromARGB(255, 252, 100, 100),
//             unselectedLabelColor: Colors.blueGrey,
//             tabs: <Widget>[
//               Tab(
//                 text: "Menu",
//               ),
//               Tab(
//                 text: "Photos",
//               ),
//               Tab(
//                 text: "Map",
//               ),
//               Tab(
//                 text: "Contact",
//               ),
//             ],
//           ),
//           //TabBarView
//           Container(
//             height: MediaQuery.of(buildContext).size.height,
//             child: TabBarView(
//               controller: _tabController,
//               children: <Widget>[
//                 menuTabView,
//                 photosTabView,
//                 Text("Third"),
//                 Text("Fourth"),
//               ],
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }
