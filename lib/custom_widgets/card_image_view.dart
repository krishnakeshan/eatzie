import 'package:flutter/material.dart';

class CardImageView extends StatelessWidget {
  //Properties
  final String source;
  final double height;
  final double width;
  final BoxFit fit;
  final EdgeInsets margin;

  //Constructors
  CardImageView({this.source, this.height, this.width, this.fit, this.margin});

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      margin: margin != null ? margin : EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Card(
        color: Colors.white30,
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.network(
          source,
          fit: fit != null ? fit : BoxFit.fitWidth,
          width: width,
          height: height,
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
