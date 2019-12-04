import 'dart:async';

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
      CartItem newCartItem = CartItem();
      newCartItem.item.objectId = itemObject["itemId"];
      newCartItem.quantity = itemObject["quantity"];
      cartItems.add(newCartItem);
    }
  }

  //Methods
  //method to get Item objects for this Cart
  Future<void> getCartItems() async {
    for (CartItem cartItem in cartItems) {
      await cartItem.getItemObject();
    }
  }

  //method to update this cart from a map (similar to using the constructor)
  void updateFromMap(var map) {
    this.objectId = map["objectId"];
    this.createdAt = DateTime.parse(map["createdAt"]);
    this.locationId = map["location"];

    //get items
    cartItems.clear();
    for (var itemObject in map["items"]) {
      CartItem newCartItem = CartItem();
      newCartItem.item.objectId = itemObject["itemId"];
      newCartItem.quantity = itemObject["quantity"];
      cartItems.add(newCartItem);
    }
  }

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

  static const platformChannel = MethodChannel("com.qrilt.eatzie/main");

  //Constructors
  CartItem();

  //Methods
  //method to get an Item object from server
  Future<void> getItemObject() async {
    var itemObjectMap = await platformChannel.invokeMethod(
      "getObjectWithId",
      {
        "className": "Item",
        "objectId": this.item.objectId,
      },
    );

    //load information into item object
    this.item = Item.fromMap(map: itemObjectMap);
  }
}
