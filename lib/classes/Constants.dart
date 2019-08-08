import 'package:flutter/material.dart';

class Constants {
  static const orderStatusPlacedCode = 0;
  static const orderStatusAcceptedCode = 1;
  static const orderStatusInProgressCode = 2;
  static const orderStatusReadyCode = 3;
  static const orderStatusCompleteCode = 4;

  static const OrderStatusStrings = [
    "Placed",
    "Accepted",
    "In Progress",
    "Ready!",
    "Completed",
  ];

  static const OrderStatusColors = [
    Colors.grey,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
  ];
}
