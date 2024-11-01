// presentation/blocs/calculator_state.dart

abstract class CalculatorState {}

class CalculatorInitial extends CalculatorState {}

class CalculatorDisplayState extends CalculatorState {
  final String display;
  final String expression;
  CalculatorDisplayState(this.display, this.expression);
}
