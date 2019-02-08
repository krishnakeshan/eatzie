import 'package:flutter/services.dart';
import 'package:eatzie/model/item.dart';

class Cart {
  //Properties
  String objectId;
  DateTime createdAt;

  String locationId;
  List<CartItem> cartItems = List();

  var cartPlatformChannel = MethodChannel("com.qrilt.eatzie/cart");

  //Constructors

  //default constructor
  Cart();

  //constructor to make a Cart object from a Map
  Cart.fromMap({var map}) {
    this.objectId = map["objectId"];
    this.createdAt = DateTime.parse(map["createdAt"]);
    this.locationId = map["location"];

    //get items
    for (var itemObject in map["items"]) {
      print("adding cartitem");
      CartItem newCartItem = CartItem();
      newCartItem.item.objectId = itemObject["item"];
      newCartItem.quantity = itemObject["quantity"];
      cartItems.add(newCartItem);

      //get item information
      // newCartItem.getItemInformation(itemObject["item"]);
    }
  }

  //Methods
  //method to add an Item to a cart
  void addItemToCart(Item newItem) async {
    //call platform method to add this item
    //newCartMap will contain the updated representation of the cart
    var newCartMap =
        cartPlatformChannel.invokeMethod("addItemToCart", newItem.objectId);
  }
}

class CartItem {
  //Properties
  Item item = Item();
  int quantity;

  var platformChannel = MethodChannel("com.qrilt.eatzie/main");

  //Constructors
  CartItem();
  // CartItem.newItem({this.item, this.quantity = 1});

  //Methods
  //method to get an Item object from server
  void getItemInformation(String itemId) async {
    print("getting item information");
    var itemObject =
        await platformChannel.invokeMethod("getItemObject", itemId);

    //load information into item object
    this.item = Item();
    this.item.objectId = itemObject["objectId"];
    this.item.imageURL = itemObject["imageURL"];
    this.item.name = itemObject["name"];
    this.item.description = itemObject["description"];
    this.item.ppu = itemObject["ppu"].toDouble();
  }
}
