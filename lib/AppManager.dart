import 'dart:async';

import 'package:flutter/services.dart';

import 'package:eatzie/model/order.dart';

class AppManager {
  //Properties
  static AppManager instance;
  static const authChannel = MethodChannel("com.qrilt.eatzie/auth");
  static const mainChannel = MethodChannel("com.qrilt.eatzie/main");
  static const orderChannel = MethodChannel("com.qrilt.eatzie/order");

  //method to get singleton instance of this class
  static AppManager getInstance() {
    if (instance == null) instance = AppManager();
    return instance;
  }

  //method to get an object with id
  Future<dynamic> getObjectWithId({String className, String objectId}) async {
    //call platform channel method
    var result = await mainChannel.invokeMethod(
      "getObjectWithId",
      {
        "className": className,
        "objectId": objectId,
      },
    );

    //return result
    return result;
  }

  //method to sync user's active orders
  Future<bool> syncUserActiveOrders() async {
    var result = await orderChannel.invokeMethod("syncUserActiveOrders");
    return result;
  }

  //method to sync user's past orders
  Future<bool> syncUserPastOrders() async {
    var result = await orderChannel.invokeMethod("syncUserPastOrders");
    return result;
  }

  //method to get user's active orders
  Future<List<Order>> getUserActiveOrders(
      {bool fromLocalDatastore = false}) async {
    var result = await orderChannel.invokeMethod(
      "getUserActiveOrders",
      {
        "fromLocalDatastore": fromLocalDatastore,
      },
    );

    //result contains maps of order objects, convert them and return
    return Order.createListFromMaps(result);
  }

  //method to get user's past orders
  Future<List<Order>> getUserPastOrders(
      {bool fromLocalDataStore = false}) async {
    var result = await orderChannel.invokeMethod(
      "getUserPastOrders",
      {
        "fromLocalDatastore": fromLocalDataStore,
      },
    );

    //result contains maps of order objects, convert them and return
    return Order.createListFromMaps(result);
  }
}
