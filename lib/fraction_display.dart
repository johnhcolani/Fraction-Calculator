import 'package:flutter/material.dart';

class FractionDisplay extends StatelessWidget {
  final String integerPart;
  final String fractionPart;

  const FractionDisplay({required this.integerPart, required this.fractionPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          integerPart,
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 5), // Adds space between the integer and fraction
        Text(
          fractionPart,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
