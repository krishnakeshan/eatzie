import 'package:flutter/material.dart';

import 'package:eatzie/model/cart.dart';

import 'package:eatzie/custom_widgets/card_image_view.dart';
import 'package:eatzie/custom_widgets/item_quantity_tuner.dart';

import 'package:eatzie/classes/listeners/cart_listener.dart';

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
      cartItem: cartItem,
      cartListener: cartListener,
    );
  }
}

class _CartItemListViewItemState extends State<CartItemListViewItem> {
  //Properties
  CartItem cartItem;
  CartListener cartListener;

  //Constructors
  _CartItemListViewItemState({this.cartItem, this.cartListener});

  //Methods
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      //Main Row
      child: Row(
        children: <Widget>[
          //Item image
          CardImageView(
            source: cartItem.item.imageURL,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
            margin: EdgeInsets.zero,
          ),

          //Item info column
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Name Text
                  Text(
                    cartItem.item.name,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  //Description Text
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      cartItem.item.description,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Quantity Tuner
          ItemQuantityTuner(
            count: cartItem.quantity,
            onIncremented: () {
              //call method on cart listener
              cartListener.onItemAddedToCart(item: cartItem.item);
            },
            onDecremented: () {
              //call method on cart listener
              cartListener.onItemRemovedFromCart(item: cartItem.item);
            },
          ),
        ],
      ),
    );
  }
}
