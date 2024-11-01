// domain/usecases/operations.dart

import 'package:fraction/fraction.dart';

class FractionOperations {
  Fraction add(Fraction a, Fraction b) => a + b;
  Fraction subtract(Fraction a, Fraction b) => a - b;
  Fraction multiply(Fraction a, Fraction b) => a * b;
  Fraction divide(Fraction a, Fraction b) => a / b;

  String formatAsMixedFraction(Fraction fraction) {
    fraction = fraction.reduce();
    int integerPart = fraction.toDouble().truncate();
    Fraction fractionalPart = fraction - Fraction(integerPart, 1);
    return integerPart == 0
        ? fraction.toString()
        : "$integerPart ${fractionalPart.toString()}";
  }

  String convertToFeetAndInches(Fraction inches) {
    int totalInches = inches.toDouble().truncate();
    int feet = totalInches ~/ 12;
    Fraction remainingInches = inches - Fraction(feet * 12, 1);
    return "$feet ft ${formatAsMixedFraction(remainingInches)} in";
  }
}
