import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class FractionCalculatorScreen extends StatefulWidget {
  const FractionCalculatorScreen({super.key});

  @override
  _FractionCalculatorScreenState createState() => _FractionCalculatorScreenState();
}

class _FractionCalculatorScreenState extends State<FractionCalculatorScreen> {
  // Existing variables
  String displayText = '0';
  String expression = '';
  String inchResult = '';
  String feetInchResult = '';
  String _operator = '';
  Fraction? _result;
  Fraction _currentInput = Fraction(0);

  // Colors for different types of buttons
  final Color operandColor = Colors.orangeAccent;
  final Color operandTextColor = Colors.white;
  final Color fractionColor = Colors.teal;
  final Color fractionTextColor = Colors.white;
  final Color defaultColor = Colors.grey[850]!;
  final Color defaultTextColor = Colors.white;

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        displayText = '0';
        expression = '';
        inchResult = '';
        feetInchResult = '';
        _result = null;
        _currentInput = Fraction(0);
        _operator = '';
      } else if (buttonText == "±") {
        _currentInput = _currentInput * Fraction(-1);
        displayText = formatFractionAsMixed(_currentInput);
      } else if (buttonText == "÷" || buttonText == "×" || buttonText == "-" || buttonText == "+") {
        if (_result == null) {
          _result = _currentInput;
        } else if (_operator.isNotEmpty) {
          _result = calculateResult(_result!, _currentInput, _operator);
        }
        _operator = buttonText;
        expression = "${formatFractionAsMixed(_result!)} $buttonText";
        _currentInput = Fraction(0);
        displayText = '0';
      } else if (buttonText == "=") {
        if (_result != null && _operator.isNotEmpty) {
          _result = calculateResult(_result!, _currentInput, _operator);
          displayText = formatFractionAsMixed(_result!);
          inchResult = "${formatFractionAsMixed(_result!)} inches";
          feetInchResult = convertToFeetAndInches(_result!);
          expression = "$expression ${formatFractionAsMixed(_currentInput)} = ${formatFractionAsMixed(_result!)}";
        }
        _operator = '';
      } else if (buttonText.contains("/")) {
        _currentInput = parseFraction(buttonText);
        displayText = buttonText;
        if (_operator.isEmpty && expression.isEmpty) {
          expression = buttonText;
        }
      } else {
        displayText = displayText == '0' ? buttonText : displayText + buttonText;
        _currentInput = parseFraction(displayText);
        if (_operator.isEmpty && expression.isEmpty) {
          expression = buttonText;
        }
      }
    });
  }

  Fraction parseFraction(String input) {
    try {
      if (input.contains("/")) {
        return Fraction.fromString(input);
      } else {
        return Fraction.fromDouble(double.parse(input));
      }
    } catch (e) {
      return Fraction(0);
    }
  }

  Fraction calculateResult(Fraction num1, Fraction num2, String operator) {
    switch (operator) {
      case "+":
        return num1 + num2;
      case "-":
        return num1 - num2;
      case "×":
        return num1 * num2;
      case "÷":
        return num1 / num2;
      default:
        return Fraction(0);
    }
  }

  String convertToFeetAndInches(Fraction inches) {
    int totalInches = inches.toDouble().truncate();
    int feet = totalInches ~/ 12;
    Fraction remainingInches = inches - Fraction(feet * 12, 1);
    return "$feet ft ${formatFractionAsMixed(remainingInches)} in";
  }

  String formatFractionAsMixed(Fraction fraction) {
    fraction = fraction.reduce();
    int integerPart = fraction.toDouble().truncate();
    Fraction fractionalPart = fraction - Fraction(integerPart, 1);
    if (fractionalPart.numerator == 0) {
      return "$integerPart";
    }
    return integerPart == 0 ? fraction.toString() : "$integerPart ${fractionalPart.toString()}";
  }

  Widget buildButton(String text, {Color color = Colors.grey, Color textColor = Colors.white, double textSize = 24, int flex = 1, bool isOval = false}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isOval ? 32 : 24), // Make oval button if specified
          ),
          child: ElevatedButton(
            onPressed: () => onButtonPressed(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: isOval ? EdgeInsets.symmetric(horizontal: 40, vertical: 16) : EdgeInsets.all(20), // Larger horizontal padding for oval
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isOval ? 32 : 24),
              ),
              elevation: 2,
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFractionRow(List<String> fractions) {
    return Row(
      children: fractions
          .map((fraction) => buildButton(
        fraction,
        color: fractionColor,
        textColor: fractionTextColor,
        textSize: 16, // Smaller font for fraction buttons
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Fraction Calculator', style: TextStyle(color: Colors.grey)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                  decoration: BoxDecoration(
                  color: Colors.black, // Background color of the container
                    border: Border.all(color: Colors.grey, width: 2), // White border with thickness of 2
                    borderRadius: BorderRadius.circular(12), ),// Optional: rounded corners for a softer look
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      expression,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      displayText,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
         // Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black, // Background color of the container
                      border: Border.all(color: Colors.grey, width: 2), // White border with thickness of 2
                      borderRadius: BorderRadius.circular(12), // Optional: rounded corners for a softer look
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('in',style: TextStyle(color: Colors.white),),
                          Text(
                            inchResult,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black, // Background color of the container
                      border: Border.all(color: Colors.grey, width: 2), // White border with thickness of 2
                      borderRadius: BorderRadius.circular(12), // Optional: rounded corners for a softer look
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ft',style: TextStyle(color: Colors.white),),
                          Text(
                            feetInchResult,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      buildButton("C", color: Colors.redAccent),
                      buildButton("±"),
                      buildButton("÷", color: operandColor, textColor: operandTextColor),
                      buildButton("=", color: operandColor, textColor: operandTextColor),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("7"),
                      buildButton("8"),
                      buildButton("9"),
                      buildButton("×", color: operandColor, textColor: operandTextColor),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("4"),
                      buildButton("5"),
                      buildButton("6"),
                      buildButton("-", color: operandColor, textColor: operandTextColor),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("1"),
                      buildButton("2"),
                      buildButton("3"),
                      buildButton("+", color: operandColor, textColor: operandTextColor),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("0"),
                      buildButton(".", textSize: 24),
                      buildButton("1/2", color: fractionColor, textColor: fractionTextColor, textSize: 20, flex: 2, isOval: true),
                    ],
                  ),
                  buildFractionRow(["1/8", "3/8", "5/8", "7/8"]),
                  buildFractionRow(["1/16", "3/16", "5/16", "7/16"]),
                  buildFractionRow(["9/16", "11/16", "13/16", "15/16"]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
