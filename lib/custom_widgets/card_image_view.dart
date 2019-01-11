import 'package:flutter/material.dart';

class CardImageView extends StatelessWidget {
  //Properties
  final String source;

  //Constructors
  CardImageView({this.source});

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Card(
        color: Colors.white30,
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.network(
          source,
          fit: BoxFit.fitWidth,
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
