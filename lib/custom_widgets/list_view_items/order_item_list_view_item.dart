import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eatzie/custom_widgets/star_rating_widget.dart';
import 'package:eatzie/view_item.dart';

import 'package:eatzie/model/order.dart';
import 'package:eatzie/model/item.dart';

class OrderItemListViewItem extends StatefulWidget {
  //Properties
  final OrderItem orderItem;
  final Item item;

  //Constructors
  OrderItemListViewItem({this.orderItem, this.item});

  //Methods
  @override
  _OrderItemListViewItemState createState() {
    return _OrderItemListViewItemState(
      orderItem: orderItem,
      item: item,
    );
  }
}

class _OrderItemListViewItemState extends State<OrderItemListViewItem> {
  //Properties
  OrderItem orderItem;
  Item item;

  //Constructors
  _OrderItemListViewItemState({this.orderItem, this.item});

  //Methods
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          //Main Container
          child: Column(
            //Main Column
            children: <Widget>[
              Row(
                //Item Info Row
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //Item Image Container
                    child: Card(
                      //Item Image Card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        //Item Image! xD
                        item.imageURL,
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    //Item Name and Price Expanded
                    child: Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //Item Name Text
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            //Item Price Container
                            margin: EdgeInsets.only(top: 4),
                            child: Text(
                              //Item Price Text
                              "Rs. ${orderItem.ppu}",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    //Quantity Card
                    color: Colors.blueGrey,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        //Quantity Text
                        "x${orderItem.quantity}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //Item Rating and Total Row
              Divider(
                height: 20,
              ),
              Container(
                // margin: EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      //Existing Rating Star Icon
                      Icons.star,
                      size: 12,
                      color: Colors.deepOrange,
                    ),
                    Container(
                      //Existing Rating Text Container
                      margin: EdgeInsets.only(left: 2),
                      child: Text(
                        //Existing Rating Text
                        "3.4",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      //User Rating Expanded
                      child: Container(
                          // alignment: Alignment.center,
                          // child: StarRatingWidget(),
                          ),
                    ),
                    Container(
                      //Item Total Container
                      child: Text(
                        //Item Total Text
                        "Rs. ${orderItem.ppu * orderItem.quantity}",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
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
      onTap: () {
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (buildContext) {
              return ViewItemWidget();
            },
          ),
        );
      },
    );
  }
}
