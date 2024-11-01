// presentation/blocs/calculator_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fraction/fraction.dart';
import '../../domain/usecases/operations.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final FractionOperations operations;
  Fraction? _currentInput;
  Fraction? _result;
  String _operator = '';

  CalculatorBloc(this.operations) : super(CalculatorInitial()) {
    on<NumberPressed>((event, emit) {
      _currentInput = Fraction.fromString(event.number);
      emit(CalculatorDisplayState(_currentInput.toString(), _operator));
    });

    on<OperatorPressed>((event, emit) {
      _operator = event.operator;
      _result = _currentInput;
      _currentInput = null;
      emit(CalculatorDisplayState(_result.toString(), _operator));
    });

    on<CalculateResult>((event, emit) {
      if (_result != null && _currentInput != null) {
        switch (_operator) {
          case '+':
            _result = operations.add(_result!, _currentInput!);
            break;
          case '-':
            _result = operations.subtract(_result!, _currentInput!);
            break;
          case '×':
            _result = operations.multiply(_result!, _currentInput!);
            break;
          case '÷':
            _result = operations.divide(_result!, _currentInput!);
            break;
        }
        emit(CalculatorDisplayState(
            operations.formatAsMixedFraction(_result!), ''));
      }
    });

    on<ClearPressed>((event, emit) {
      _currentInput = null;
      _result = null;
      _operator = '';
      emit(CalculatorDisplayState('0', ''));
    });
  }
}
