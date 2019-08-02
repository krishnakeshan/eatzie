/*
A class to listen to Cart updates
*/

import 'package:eatzie/model/item.dart';

abstract class CartListener {
  //method to call when Item object is added to cart
  void onItemAddedToCart(Item item);
  void onItemRemovedFromCart(Item item);
}
