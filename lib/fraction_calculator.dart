import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class FractionCalculatorScreen extends StatefulWidget {
  @override
  _FractionCalculatorScreenState createState() => _FractionCalculatorScreenState();
}

class _FractionCalculatorScreenState extends State<FractionCalculatorScreen> {
  String displayText = '0'; // Current input display
  String expression = ''; // Full expression display
  String inchResult = ''; // Result in inches
  String feetInchResult = ''; // Result in feet and inches
  String _operator = ''; // Current operator
  Fraction? _result;
  Fraction _currentInput = Fraction(0);

  // Colors for different types of buttons
  final Color operandColor = Colors.orange;
  final Color operandTextColor = Colors.white;
  final Color fractionColor = Colors.teal;
  final Color fractionTextColor = Colors.black;
  final Color defaultColor = Colors.grey[800]!;
  final Color defaultTextColor = Colors.white;

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // Clear all data
        displayText = '0';
        expression = '';
        inchResult = '';
        feetInchResult = '';
        _result = null;
        _currentInput = Fraction(0);
        _operator = '';
      } else if (buttonText == "±") {
        // Negate the current input
        _currentInput = _currentInput * Fraction(-1);
        displayText = formatFractionAsMixed(_currentInput);
      } else if (buttonText == "÷" || buttonText == "×" || buttonText == "-" || buttonText == "+") {
        // Process the previous operator and store the current operator
        if (_result == null) {
          _result = _currentInput;
        } else if (_operator.isNotEmpty) {
          _result = calculateResult(_result!, _currentInput, _operator);
        }
        _operator = buttonText;

        // Update the expression to show current operation so far, only once
        expression = "${formatFractionAsMixed(_result!)} $buttonText";
        _currentInput = Fraction(0); // Reset for next input
        displayText = '0';
      } else if (buttonText == "=") {
        // Final calculation with the current operator and input
        if (_result != null && _operator.isNotEmpty) {
          _result = calculateResult(_result!, _currentInput, _operator);
          displayText = formatFractionAsMixed(_result!);
          inchResult = "${formatFractionAsMixed(_result!)} inches";
          feetInchResult = convertToFeetAndInches(_result!);

          // Show the complete operation in expression, once
          expression = "$expression ${formatFractionAsMixed(_currentInput)} = ${formatFractionAsMixed(_result!)}";
        }
        _operator = ''; // Reset operator after calculation
      } else if (buttonText.contains("/")) {
        // Handle fraction inputs (e.g., "1/16", "1/8")
        _currentInput = parseFraction(buttonText);
        displayText = buttonText;

        // Only set expression if starting a new calculation or if operator is present
        if (_operator.isEmpty && expression.isEmpty) {
          expression = buttonText;
        }
      } else {
        // Handle integer or decimal inputs
        displayText = displayText == '0' ? buttonText : displayText + buttonText;
        _currentInput = parseFraction(displayText);

        // Only set expression initially or after an operator
        if (_operator.isEmpty && expression.isEmpty) {
          expression = buttonText;
        }
      }
    });
  }





  Fraction parseFraction(String input) {
    try {
      if (input.contains("/")) {
        // Parse as fraction (e.g., "1/16")
        return Fraction.fromString(input);
      } else {
        // Parse as integer or decimal and convert to Fraction
        return Fraction.fromDouble(double.parse(input));
      }
    } catch (e) {
      return Fraction(0); // Return 0 if parsing fails
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

  // Convert inches to feet and inches
  String convertToFeetAndInches(Fraction inches) {
    int totalInches = inches.toDouble().truncate();
    int feet = totalInches ~/ 12;
    Fraction remainingInches = inches - Fraction(feet * 12, 1);
    return "$feet ft ${formatFractionAsMixed(remainingInches)} in";
  }

  String formatFractionAsMixed(Fraction fraction) {
    fraction = fraction.reduce(); // Simplify the fraction
    int integerPart = fraction.toDouble().truncate(); // Integer part
    Fraction fractionalPart = fraction - Fraction(integerPart, 1); // Fractional part

    // Display only integer if no fractional part
    if (fractionalPart.numerator == 0) {
      return "$integerPart";
    }

    // Display as "integerPart fractionalPart" (e.g., "1 3/8")
    return integerPart == 0
        ? fraction.toString() // Only fraction if no integer part
        : "$integerPart ${fractionalPart.toString()}";
  }

  // Updated button builder with text color customization
  Widget buildButton(String text, {Color color = Colors.grey, Color textColor = Colors.white, double textSize = 24, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Add padding around each button
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget buildFractionRow(List<String> fractions) {
    return Row(
      children: fractions
          .map((fraction) => buildButton(fraction, color: fractionColor, textColor: fractionTextColor, textSize: 18))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fraction Calculator'),
      ),
      body: Column(
        children: [
          // Expression display area
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              expression,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[400]),
            ),
          ),
          // Display current input or result
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              displayText,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          // Row to display inch and feet-inch results
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  inchResult,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                Text(
                  feetInchResult,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                ),
              ],
            ),
          ),
          Expanded(
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
                    buildButton("1/2", color: fractionColor, textColor: fractionTextColor, textSize: 24, flex: 2),
                  ],
                ),
                // Fraction buttons with fractionColor and fractionTextColor
                buildFractionRow(["1/8", "3/8", "5/8", "7/8"]),
                buildFractionRow(["1/16", "3/16", "5/16", "7/16"]),
                buildFractionRow(["9/16", "11/16", "13/16", "15/16"]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}