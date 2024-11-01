import 'package:flutter/material.dart';

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {

  String output = "0";
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";

  buttonPressed(String buttonText){
    if(buttonText == "CLEAR"){
      _output = "0";
      num1 = 0.0;
      num2 = 0.0;
      operand ="";
    }else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "\u00f7"){
      num1 = double.parse(output);
      operand = buttonText;
      _output = "0";
    }else if (buttonText == "."){
      if(!_output.contains(".")){
        _output = _output +buttonText;
      }
    }else if (buttonText == "="){
      num2 =double.parse(output);
      if (operand == "+"){
        _output = (num1 - num2).toString();
      }else if (operand == "-"){
        _output = (num1 - num2).toString();
      }else if (operand =="x"){
        _output = (num1 * num2).toString();
      }else if (operand =="\u00f7"){
        _output = (num1 / num2).toString();
      }
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    }else {
      _output = _output + buttonText;
    }
    setState(() {
      output = double.parse(_output).toStringAsFixed(2);
    });
  }
Widget buildButton(String buttonText){
    return Expanded(child: ElevatedButton(
        onPressed: ()=> buttonPressed(buttonText),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(24.0),
        ),
        child: Text(buttonText, style: TextStyle(fontSize: 20.0),)));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 12.0
      ),
        child: Text(output,style: const TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold
        ),
      ),
          ),
          const Expanded(child: Divider()),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("\u00f7"),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("x"),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-"),
                ],
              ),
              Row(
                children: [
                  buildButton("."),
                  buildButton("0"),
                  buildButton("00"),
                  buildButton("+"),
                ],
              ),
              Row(
                children: [
                  buildButton("CLEAR"),
                  buildButton("="),
                 
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
