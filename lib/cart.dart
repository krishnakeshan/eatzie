import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eatzie/classes/listeners/cart_listener.dart';

import 'package:eatzie/model/item.dart';
import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/cart.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() {
    return _CartWidgetState();
  }
}

class _CartWidgetState extends State<CartWidget> {
  //Properties
  List<Cart> cartObjects;

  static const cartPlatformChannel = MethodChannel("com.qrilt.eatzie/cart");

  //Methods
  @override
  void initState() {
    super.initState();

    //get cart objects for this user
    _getUserCartObjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: _getBody(),
    );
  }

  //method to get body for this screen based on how many carts exist
  Widget _getBody() {
    //if cartObjects is null, return a loading screen
    if (cartObjects == null) {
      Widget loadingWidget = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(
              value: null,
            ),
            Container(
              margin: EdgeInsets.only(top: 36),
              child: Text(
                "Loading Carts, One Moment...",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );

      return loadingWidget;
    }

    //return a "No Carts" widget if cartObjects != null and no carts are there
    else if (cartObjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              color: Colors.blueGrey,
              size: 36,
            ),
            Container(
              margin: EdgeInsets.only(top: 36),
              child: Text(
                "You haven't created any carts...",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    //return a single cart view if there's only one cart
    else if (cartObjects.length == 1) {
      return ViewCartWidget(
        cartObject: cartObjects.first,
      );
    }

    //return a list of carts if more than one carts
    else {
      Widget cartsList = ListView.builder(
        itemBuilder: (buildContext, index) {
          //return a widget
          CartLocationListViewItem(
            cart: cartObjects[index],
          );
        },
        itemCount: cartObjects.length,
      );

      return cartsList;
    }
  }

  //method to get the cart objects for this user
  Future<void> _getUserCartObjects() async {
    var cartObjects =
        await cartPlatformChannel.invokeMethod("getUserCartObjects");

    //initialize cartObjects since search finished
    setState(() {
      this.cartObjects = List();
    });

    //if cartObjects were found, initialize them and load into array
    if (cartObjects.isNotEmpty) {
      List<Cart> tempArray = new List();
      for (var cartObject in cartObjects) {
        var newCartObject = Cart.fromMap(map: cartObject);
        tempArray.add(newCartObject);
      }

      //call setState
      setState(() {
        this.cartObjects.clear();
        this.cartObjects.addAll(tempArray);
      });
    }
  }
}

class CartLocationListViewItem extends StatefulWidget {
  //Properties
  final Cart cart;

  //Constructors
  CartLocationListViewItem({this.cart});

  //Methods
  @override
  _CartLocationListViewItemState createState() {
    return _CartLocationListViewItemState(
      cart: this.cart,
    );
  }
}

class _CartLocationListViewItemState extends State<CartLocationListViewItem> {
  //Properties
  Cart cart;
  Location location = Location();
  var platformChannel = MethodChannel("com.qrilt.eatzie/main");

  //Constructors
  _CartLocationListViewItemState({this.cart});

  //Methods
  @override
  void initState() {
    super.initState();

    //get location object
    _getLocationObject();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //Main Card
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Container(
        //Container to give content some padding
        padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          //Main Column
          children: <Widget>[
            Row(
              //Location Name and Image Row
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  //ClipOval to make image rounded
                  child: Image.network(
                    //Location Image
                    location.getImageURL(),
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  //Expanded Widget for name to cover rest of row
                  child: Container(
                    //Container for Location Name Text
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      location.getName(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.blueGrey,
                    size: 14,
                  ),
                ),
                Text(
                  "${cart.cartItems.length} items",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              //Container for Checkout Row
              margin: EdgeInsets.only(top: 12),
              child: Row(
                //Main Row For Checkout and Discard buttons
                children: <Widget>[
                  FlatButton(
                    //Discard Flat Button
                    child: Row(
                      //Row Containing the Text and Icon for Discard Flat Button
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          //Container for Discard Icon, to give it a margin
                          margin: EdgeInsets.only(right: 8),
                          child: Icon(
                            //Discard Icon
                            Icons.cancel,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                        Text(
                          //Discard Cart Text Widget
                          "Discard Cart",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    //Expanded Widget to Stretch the Align Object
                    child: Align(
                      //Align Object to right-align the Checkout button
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        //Checkout raised button
                        color: Colors.green,
                        child: Row(
                          //Child row for checkout button containing the text and icon
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Checkout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //method to get the corresponding location for this cart
  void _getLocationObject() async {
    var location = await platformChannel.invokeMethod(
        "getLocationObject", cart.locationId);

    //call setState
    setState(() {
      this.location = location;
    });
  }
}

class ViewCartWidget extends StatefulWidget {
  //Properties
  final Cart cartObject;

  //Constructors
  ViewCartWidget({this.cartObject});

  //Methods
  @override
  _ViewCartWidgetState createState() {
    return _ViewCartWidgetState(cart: this.cartObject);
  }
}

class _ViewCartWidgetState extends State<ViewCartWidget>
    implements CartListener {
  //Properties
  Cart cart;
  Location location = Location();
  var platformChannel = MethodChannel("com.qrilt.eatzie/main");
  var cartPlatformChannel = MethodChannel("com.qrilt.eatzie/cart");

  //Constructors
  _ViewCartWidgetState({this.cart});

  //Methods
  @override
  void initState() {
    super.initState();

    //get location object
    _getLocationObject();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      //Main List View
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Text(
          //Location Name Text
          location.getName() != null ? location.getName() : "",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          //Location Address Container for top margin
          margin: EdgeInsets.only(top: 4),
          child: Text(
            //Location Address Text
            location.getAddress() != null ? location.getAddress() : "",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Divider(),
        Container(
          //Container for Cart Summary Title
          margin: EdgeInsets.only(top: 8, bottom: 16),
          child: Row(
            //Row to contain title and icon
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                //Cart Summary Title Text
                "Cart Summary",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                //Cart Summary Icon Container for left margin
                margin: EdgeInsets.only(left: 8),
                child: Icon(
                  //Cart Summary Icon
                  Icons.shopping_cart,
                  color: Colors.blueGrey,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        _getCartItemsWidget(),
        Divider(),
        Container(
          //Order Total Title Container for top margin
          margin: EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            //Order Total Title Text
            "Order Total:",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          _getCartTotal() != null ? "Rs. ${_getCartTotal()}" : "...",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //method to get the list of CartItemListViewItems
  Widget _getCartItemsWidget() {
    List<Widget> cartItemsList = List();
    for (var cartItem in cart.cartItems) {
      cartItemsList.add(
        CartItemListViewItem(
          cartItem: cartItem,
          cartListener: this,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: cartItemsList,
    );
  }

  //method to get location object for this cart
  Future<void> _getLocationObject() async {
    var locationObject = await platformChannel.invokeMethod(
        "getLocationObject", cart.locationId);

    //call setState
    setState(() {
      location = Location.fromMap(map: locationObject);
    });
  }

  //method to get total for this cart
  double _getCartTotal() {
    double total = 0;
    for (var cartItem in cart.cartItems) {
      //if any cartItems's Item's ppu is null, return null because total cannot be computed
      if (cartItem.item.ppu == null) {
        return null;
      }

      //this cartItem's Item's ppu is available, add it to the total
      else {
        total += (cartItem.quantity * cartItem.item.ppu);
      }
    }

    //if reached till here, total has been computed, return it
    return total;
  }

  //CartListener method implementations
  //method for when an item is added to the cart
  void onItemAddedToCart(Item item) async {
    print("debugk item added to cart ${item.name}");
    var updatedCart = await cartPlatformChannel
        .invokeMethod("addItemToCart", [item.objectId, true]);

    //update this cart with this map
    setState(() {
      this.cart.updateFromMap(updatedCart);
    });
  }

  //method for when an item is removed from the cart
  void onItemRemovedFromCart(Item item) async {
    print("debugk item removed from cart ${item.name}");
    var updatedCart = await cartPlatformChannel
        .invokeMethod("removeItemFromCart", [item.objectId, true]);

    //update this cart with this map
    setState(() {
      this.cart.updateFromMap(updatedCart);
    });
  }
}

class CartItemListViewItem extends StatefulWidget {
  //Properties
  final CartItem cartItem;
  final CartListener cartListener;

  //Constructors
  CartItemListViewItem({this.cartItem, this.cartListener});

  //Methods
  @override
  _CartItemListViewItemState createState() {
    return _CartItemListViewItemState(
      cartItem: this.cartItem,
      cartListener: this.cartListener,
    );
  }
}

class _CartItemListViewItemState extends State<CartItemListViewItem> {
  //Properties
  CartItem cartItem;
  CartListener cartListener;
  var platformChannel = MethodChannel("com.qrilt.eatzie/main");

  //Constructors
  _CartItemListViewItemState({this.cartItem, this.cartListener});

  //Methods
  @override
  void initState() {
    super.initState();

    //get item information
    _getItemInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //Main Card
      margin: EdgeInsets.only(bottom: 8),
      child: Container(
        //Container to give padding to the Card's contents
        padding: EdgeInsets.all(12),
        child: Column(
          //Main Column
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(
                  //ClipOval to make image rounded
                  child: Image.network(
                    //Order Item Image
                    cartItem.item.imageURL != null
                        ? cartItem.item.imageURL
                        : "",
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  //Expanded for Main Info Column
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      //Main Info Column
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          //Item Name Text
                          cartItem.item.name != null ? cartItem.item.name : "",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Text(
                            //Item Price Text
                            cartItem.item.ppu != null
                                ? "Rs. ${cartItem.item.ppu}"
                                : "",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Text(
                            //Item Total Text
                            _getItemTotal() != null
                                ? "Sub-Total: Rs. ${_getItemTotal()}"
                                : "",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  //Quantity Widgets Row
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      //Reduce Quantity InkWell
                      splashColor: Colors.blueGrey,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          //Reduce quantity button
                          Icons.remove,
                          color: Colors.blueGrey,
                          size: 16,
                        ),
                      ),
                      onTap: () {
                        if (cartItem.item.name != null) {
                          cartListener.onItemRemovedFromCart(cartItem.item);
                        }
                      },
                      borderRadius: BorderRadius.circular(5),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        //Item Quantity Text
                        "${cartItem.quantity}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    InkWell(
                      //Increase quantity InkWell
                      splashColor: Colors.green,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          //Add Quantity Icon
                          Icons.add,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                      onTap: () {
                        //call method on listener if this cartItem's Item isn't null
                        print("reduce item onTap");
                        if (cartItem.item.name != null) {
                          print("cartItem name not null");
                          cartListener.onItemAddedToCart(cartItem.item);
                        }
                      },
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //method to get item information for this CartItem
  Future<void> _getItemInformation() async {
    var itemObject = await platformChannel.invokeMethod(
        "getItemObject", cartItem.item.objectId);

    //load information into this cartItem
    setState(() {
      this.cartItem.item = Item.fromMap(map: itemObject);
    });
  }

  //method to get total for this cart
  double _getItemTotal() {
    if (cartItem.item.ppu != null) {
      return cartItem.quantity * cartItem.item.ppu;
    }

    return null;
  }
}
