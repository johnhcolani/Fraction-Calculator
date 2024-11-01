// presentation/blocs/calculator_event.dart

abstract class CalculatorEvent {}

class NumberPressed extends CalculatorEvent {
  final String number;
  NumberPressed(this.number);
}

class OperatorPressed extends CalculatorEvent {
  final String operator;
  OperatorPressed(this.operator);
}

class CalculateResult extends CalculatorEvent {}
class ClearPressed extends CalculatorEvent {}
