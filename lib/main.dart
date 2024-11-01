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


// main.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'presentation/screens/calculator_screen.dart';
// import 'presentation/blocs/calculator_bloc.dart';
// import 'domain/usecases/operations.dart';
//
// void main() {
//   runApp(const FractionCalculatorApp());
// }
//
// class FractionCalculatorApp extends StatelessWidget {
//   const FractionCalculatorApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Beautiful Fraction Calculator',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primarySwatch: Colors.blueGrey,
//         fontFamily: 'Roboto',
//       ),
//       home: BlocProvider(
//         create: (context) => CalculatorBloc(FractionOperations()),
//         child: CalculatorScreen(),
//       ),
//     );
//   }
// }
