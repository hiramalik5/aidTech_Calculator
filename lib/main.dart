import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _output = '';

  void _appendToInput(String value) {
    setState(() {
      _input += value;
    });
  }

  void _clearInput() {
    setState(() {
      _input = '';
      _output = '';
    });
  }

  void _calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_input);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _output = result.toString();
      });
    } catch (e) {
      setState(() {
        _output = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                '$_input\n$_output',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          buildButtonRow(['7', '8', '9', '/'], Colors.blueGrey),
          buildButtonRow(['4', '5', '6', '*'], Colors.blueGrey),
          buildButtonRow(['1', '2', '3', '-'], Colors.blueGrey),
          buildButtonRow(['0', '.', '=', '+'], Colors.blueGrey),
          ElevatedButton(
            onPressed: () {
              _clearInput();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              padding: EdgeInsets.all(20.0),
            ),
            child: Text('Clear', style: TextStyle(fontSize: 25.0)),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        if (label == '=') {
          _calculate();
        } else {
          _appendToInput(label);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: label == '/' || label == '*' || label == '-' || label == '+'
            ? Colors.orange
            : color,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        padding: EdgeInsets.all(24.0),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 35.0),
      ),
    );
  }

  Widget buildButtonRow(List<String> labels, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) => buildButton(label, color)).toList(),
    );
  }
}
