import 'package:flutter/material.dart';

class SmallTextChipWidget extends StatelessWidget {
  //Constructors
  SmallTextChipWidget({this.text});

  //Properties
  final String text;

  //Methods
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.all(4),
        color: Colors.blueGrey,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
