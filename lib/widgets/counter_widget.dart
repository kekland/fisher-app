import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int amount;
  final String description;
  final Color accentColor;
  final Color primaryColor;

  CounterWidget({this.amount, this.description, this.accentColor, this.primaryColor});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          amount.toString(),
          style: TextStyle(
            color: accentColor,
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: primaryColor,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
