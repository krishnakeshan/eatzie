import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StarRatingWidget extends StatefulWidget {
  //Constructors
  StarRatingWidget({this.starIconSize = 14});

  //Properties
  final double starIconSize;

  //Methods
  @override
  _StarRatingWidgetState createState() {
    return _StarRatingWidgetState(starIconSize: this.starIconSize);
  }
}

class _StarRatingWidgetState extends State<StarRatingWidget>
    implements StarSelectionInterface {
  //Constructors
  _StarRatingWidgetState({this.starIconSize = 14});
  //Properties
  double starIconSize;
  int _currentRating = 0;

  //Methods
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buildStars(),
    );
  }

  //method to build stars
  List<Widget> buildStars() {
    List<RatingStarWidget> starWidgets = [];

    for (int i = 0; i < 5; i++) {
      if (i < (_currentRating)) {
        starWidgets.add(
          RatingStarWidget(
            starIconSize: starIconSize,
            starPosition: i,
            isSelected: true,
            starSelectionInterface: this,
          ),
        );
      } else {
        starWidgets.add(
          RatingStarWidget(
            starIconSize: starIconSize,
            starPosition: i,
            isSelected: false,
            starSelectionInterface: this,
          ),
        );
      }
    }

    //return built stars
    return starWidgets;
  }

  //Star Selection Interface Methods
  void onStarSelected(RatingStarWidget starWidget) {
    print("listener: star selected ${starWidget.starPosition}");

    setState(() {
      //a new, rating has been selected, update rating
      if (_currentRating == (starWidget.starPosition + 1)) {
        _currentRating = 0;
      }

      //same star as rating has been selected, set rating to 0
      else {
        _currentRating = (starWidget.starPosition + 1);
      }
    });
  }
}

class RatingStarWidget extends StatelessWidget {
  //Properties
  final double starIconSize;
  final int starPosition;
  final bool isSelected;
  final StarSelectionInterface starSelectionInterface;

  //Constructors
  RatingStarWidget({
    this.starIconSize = 14,
    this.starPosition,
    this.isSelected,
    this.starSelectionInterface,
  });

  //Methods
  @override
  Widget build(BuildContext buildContext) {
    Icon icon;
    if (isSelected) {
      icon = Icon(
        FontAwesomeIcons.solidStar,
        color: Colors.blueGrey,
        size: starIconSize,
      );
    } else {
      icon = Icon(
        FontAwesomeIcons.star,
        color: Colors.blueGrey,
        size: starIconSize,
      );
    }

    return GestureDetector(
      child: Container(
        child: icon,
        margin: EdgeInsets.symmetric(horizontal: 1),
      ),
      onTap: () {
        starSelectionInterface.onStarSelected(this);
      },
    );
  }
}

class StarSelectionInterface {
  void onStarSelected(RatingStarWidget starWidget) {}
}
