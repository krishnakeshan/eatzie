import 'package:flutter/material.dart';

import 'package:eatzie/classes/listeners/cart_listener.dart';
import 'package:eatzie/model/location.dart';
import 'package:eatzie/model/item.dart';

class LocationMenuListViewItem extends StatefulWidget {
  //Properties
  final Item item;
  final Location location;
  final CartListener cartListener;

  //Constructors
  LocationMenuListViewItem({this.item, this.location, this.cartListener});

  //Methods
  @override
  State<LocationMenuListViewItem> createState() =>
      _LocationMenuListViewItemState(
        item: item,
        location: location,
        cartListener: cartListener,
      );
}

class _LocationMenuListViewItemState extends State<LocationMenuListViewItem> {
  //Properties
  Location location;
  Item item;
  CartListener cartListener;

  //Constructors
  _LocationMenuListViewItemState({this.item, this.location, this.cartListener});

  //Methods
  @override
  Widget build(BuildContext buildContext) {
    return Container(
      //Main Container to give everything a padding of 16
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Product Image
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Card(
              color: Colors.grey,
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                item.imageURL,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ),
          //Main Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Name Text Widget
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                //Description Text Widget
                Container(
                  margin: EdgeInsets.only(top: 6),
                  child: Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                  ),
                ),
                //Price Text Widget
                Container(
                  margin: EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Rs. ${item.ppu}",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                      Container(
                        child: Icon(
                          Icons.star,
                          color: Colors.blueGrey,
                          size: 11,
                        ),
                        margin: EdgeInsets.only(left: 6, right: 2),
                      ),
                      Text(
                        "4.3",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            //Add To Cart Button Container
            width: 70,
            height: 30,
            child: RaisedButton(
              //Add to Cart Button
              child: Text(
                "Add",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 12,
                ),
              ),
              color: Colors.white,
              onPressed: () {
                //call method to add an item to the cart
                if (this.cartListener != null) {
                  this.cartListener.onItemAddedToCart(item);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
