// data/models/fraction.dart

import 'package:fraction/fraction.dart';

class FractionModel {
  final Fraction fraction;

  FractionModel(this.fraction);

  @override
  String toString() => fraction.toString();
}
