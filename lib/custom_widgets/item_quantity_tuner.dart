import 'package:flutter/material.dart';

class ItemQuantityTuner extends StatelessWidget {
  //Properties
  final int count;
  final Function onIncremented;
  final Function onDecremented;

  //Constructors
  ItemQuantityTuner({
    this.count = 0,
    this.onIncremented,
    this.onDecremented,
  });

  @override
  Widget build(context) {
    return Row(
      children: <Widget>[
        //Decrement Button
        InkResponse(
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.remove,
              size: 16,
              color: Colors.red,
            ),
          ),
          radius: 25,
          onTap: onDecremented,
        ),

        //Quantity Text
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "$count",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        //Increment Button
        InkResponse(
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.add,
              size: 16,
              color: Colors.red,
            ),
          ),
          radius: 25,
          onTap: onIncremented,
        ),
      ],
    );
  }

  //Methods
  // @override
  // _ItemQuantityTunerState createState() {
  //   return _ItemQuantityTunerState(
  //     count: count,
  //     onIncremented: onIncremented,
  //     onDecremented: onDecremented,
  //   );
  // }
}

// class _ItemQuantityTunerState extends State<ItemQuantityTuner> {
//   //Properties
//   int count;
//   Function onIncremented;
//   Function onDecremented;

//   //Constructors
//   _ItemQuantityTunerState({
//     this.count,
//     this.onIncremented,
//     this.onDecremented,
//   });

//   //Methods
//   @override
//   Widget build(context) {
//     return Row(
//       children: <Widget>[
//         //Decrement Button
//         InkResponse(
//           child: Ink(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.red,
//                 width: 1.5,
//               ),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Icon(
//               Icons.remove,
//               size: 16,
//               color: Colors.red,
//             ),
//           ),
//           radius: 25,
//           onTap: onDecremented,
//         ),

//         //Quantity Text
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 8),
//           child: Text(
//             "$count",
//             style: TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),

//         //Increment Button
//         InkResponse(
//           child: Ink(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.red,
//                 width: 1.5,
//               ),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Icon(
//               Icons.add,
//               size: 16,
//               color: Colors.red,
//             ),
//           ),
//           radius: 25,
//           onTap: onIncremented,
//         ),
//       ],
//     );
//   }

//   //methods to increment and decrement quantity
//   void _incrementQuantity() async {
//     //set local count
//     if (mounted) {
//       setState(() {
//         count++;
//       });
//     }

//     //invoke callback and wait for result
//     var success = await onIncremented();

//     //if update not successful, revert count
//     if (!success) {
//       count--;
//     }
//   }

//   void _decrementQuantity() async {
//     //set local count
//     if (mounted) {
//       setState(() {
//         count--;
//       });
//     }

//     //invoke callback, await result
//     var success = await onDecremented();

//     //if update not successful, revert count
//     if (!success) {
//       count++;
//     }
//   }
// }
