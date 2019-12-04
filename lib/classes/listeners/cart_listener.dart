/*
A class to listen to Cart updates
*/

import 'package:flutter/material.dart';
import 'package:eatzie/model/item.dart';

abstract class CartListener {
  //method to call when Item object is added to cart
  void onItemAddedToCart({Item item, BuildContext context});
  void onItemRemovedFromCart({Item item, BuildContext context});
  void onItemDeletedFromCart({Item item, BuildContext context});
}
