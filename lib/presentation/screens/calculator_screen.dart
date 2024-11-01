// presentation/screens/calculator_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../fraction_display.dart';
import '../blocs/calculator_bloc.dart';
import '../blocs/calculator_event.dart';
import '../blocs/calculator_state.dart';

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beautiful Calculator')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Display for the calculation result and expression
            BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (context, state) {
                String display = '0';
                String expression = '';
                String integerPart = '';
                String fractionPart = '';

                if (state is CalculatorDisplayState) {
                  display = state.display;
                  expression = state.expression;

                  // Separate integer and fraction parts for the FractionDisplay
                  if (display.contains(" ")) {
                    var parts = display.split(" ");
                    integerPart = parts[0];
                    fractionPart = parts[1];
                  } else {
                    integerPart = display;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        expression,
                        style: TextStyle(fontSize: 22, color: Colors.white60),
                      ),
                      SizedBox(height: 10),
                      FractionDisplay(
                        integerPart: integerPart,
                        fractionPart: fractionPart,
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(color: Colors.white30),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(context, 'C', isOperator: true),
                      buildButton(context, '±', isOperator: true),
                      buildButton(context, '÷', isOperator: true),
                      buildButton(context, '=', isOperator: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(context, '7'),
                      buildButton(context, '8'),
                      buildButton(context, '9'),
                      buildButton(context, '×', isOperator: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(context, '4'),
                      buildButton(context, '5'),
                      buildButton(context, '6'),
                      buildButton(context, '-', isOperator: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(context, '1'),
                      buildButton(context, '2'),
                      buildButton(context, '3'),
                      buildButton(context, '+', isOperator: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(context, '0'),
                      buildButton(context, '.'),
                      buildButton(context, '1/2', isFraction: true),
                      buildButton(context, '1/4', isFraction: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(context, '1/8', isFraction: true),
                      buildButton(context, '3/8', isFraction: true),
                      buildButton(context, '5/8', isFraction: true),
                      buildButton(context, '7/8', isFraction: true),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton(context, '1/16', isFraction: true),
                      buildButton(context, '3/16', isFraction: true),
                      buildButton(context, '5/16', isFraction: true),
                      buildButton(context, '7/16', isFraction: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, {bool isOperator = false, bool isFraction = false}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          if (text == "C") {
            BlocProvider.of<CalculatorBloc>(context).add(ClearPressed());
          } else if (text == "=") {
            BlocProvider.of<CalculatorBloc>(context).add(CalculateResult());
          } else if (text == "±") {
            // Event to switch the sign
            BlocProvider.of<CalculatorBloc>(context).add(NumberPressed("±"));
          } else if (isOperator) {
            BlocProvider.of<CalculatorBloc>(context).add(OperatorPressed(text));
          } else if (isFraction) {
            BlocProvider.of<CalculatorBloc>(context).add(NumberPressed(text));
          } else {
            BlocProvider.of<CalculatorBloc>(context).add(NumberPressed(text));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isOperator ? Colors.orangeAccent : isFraction ? Colors.tealAccent : Colors.blueGrey.shade800,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
