import 'package:flutter/material.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() {
    return _CartWidgetState();
  }
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ViewCartWidget(),
    );
  }
}

class CartLocationListViewItem extends StatelessWidget {
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
                    "https://cdn.pixabay.com/photo/2015/09/02/13/24/girl-919048_960_720.jpg",
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
                      "Madouk Cafe",
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
                  "4 items",
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
}

class ViewCartWidget extends StatefulWidget {
  @override
  _ViewCartWidgetState createState() {
    return _ViewCartWidgetState();
  }
}

class _ViewCartWidgetState extends State<ViewCartWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      //Main List View
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Text(
          //Location Name Text
          "Madouk Cafe",
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
            "Somewhere nearby, Bangalore 45",
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
        CartItemListViewItem(),
        CartItemListViewItem(),
        CartItemListViewItem(),
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
          "Rs. 540",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CartItemListViewItem extends StatefulWidget {
  @override
  _CartItemListViewItemState createState() {
    return _CartItemListViewItemState();
  }
}

class _CartItemListViewItemState extends State<CartItemListViewItem> {
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
                    "https://cdn.pixabay.com/photo/2015/04/08/13/13/food-712665_960_720.jpg",
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
                          "Croissant",
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
                            "Rs. 60",
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
                            "Total: Rs. 180",
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
                      //Inkwell to respond to Icon touches
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          //Reduce quantity button
                          Icons.remove_circle,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        //Item Quantity Text
                        "3",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          //Add Quantity Icon
                          Icons.add_circle,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      onTap: () {},
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
}
