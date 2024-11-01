import 'package:decimal_calculator/fraction_calculator.dart';
import 'package:flutter/material.dart';

import 'calculator_home_page.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FractionCalculatorScreen(),
    );
  }
}
