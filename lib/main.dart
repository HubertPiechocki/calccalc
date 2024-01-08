import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  String currentInput = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        clearCalculator();
      } else if (isOperator(buttonText)) {
        handleOperator(buttonText);
      } else if (buttonText == "=") {
        performCalculation();
      } else {
        handleDigitOrDecimal(buttonText);
      }
    });
  }

  void handleOperator(String operator) {
    if (_output != "0") {
      num1 = double.parse(_output);
      operand = operator;
      if (num1 % 1 == 0) {
        currentInput = "${num1.toInt()} $operand";
      } else {
        currentInput = "$num1 $operand";
      }
      _output = "0";
    }
  }

  void handleDigitOrDecimal(String input) {
    if (_output == "0") {
      _output = input;
      currentInput = input;
    } else {
      _output += input;
      currentInput += input;
    }
  }

  bool isOperator(String buttonText) {
    return buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/";
  }

  void performCalculation() {
    if (operand.isNotEmpty && _output != "Error: Cannot divide by zero") {
      num2 = double.parse(_output);
      switch (operand) {
        case "+":
          _output = (num1 + num2).toString();
          break;
        case "-":
          _output = (num1 - num2).toString();
          break;
        case "x":
          _output = (num1 * num2).toString();
          break;
        case "/":
          if (num2 != 0) {
            _output = (num1 / num2).toStringAsFixed(3);
          } else {
            _output = "Error: Cannot divide by zero";
          }
          break;
      }

      Future.delayed(Duration.zero, () {
        setState(() {
          if (_output != "Error: Cannot divide by zero") {
            if (num1 % 1 == 0) {
              currentInput = "${num1.toInt()} $operand $num2 =";
            } else {
              currentInput = "$num1 $operand $num2 =";
            }
          } else {
            currentInput = "Error: Cannot divide by zero";
          }
          operand = "";
          num1 = double.parse(_output);
          num2 = 0;
        });
      });
    }
  }

  void clearCalculator() {
    _output = "0";
    num1 = 0;
    num2 = 0;
    operand = "";
    currentInput = "";
  }

  Widget buildButton(String buttonText, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            padding: EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Huberta"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              currentInput,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              _output,
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("/", color: Colors.orange),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("x", color: Colors.orange),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-", color: Colors.orange),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton("0"),
                  buildButton("AC", color: Colors.red),
                  buildButton("=", color: Colors.orange),
                  buildButton("+", color: Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
