import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class CalculatorProvider extends ChangeNotifier {
  final calcController = TextEditingController();
  String resultText = '';
  int openParenthesesCount = 0;


  setValue(String value) {
    switch (value) {
      case "C":
        calcController.clear();
        resultText = '';
        break;

      case "x":
        calcController.text += "x";
        break;
      case "=":
        calculate();
        break;

      case "+/-":
          positiveToNegative();
        break;
      case ".":
        dot();
        break;

      case"()":
        parenthesisOperation();
        calculate();
        break;


      default:
        calcController.text += value;
        resultText+=value;
        calculate();


    }

    calcController.selection = TextSelection.fromPosition(
        TextPosition(offset: calcController.text.length));
    notifyListeners();
  }

  calculate() {
    String text = calcController.text.replaceAll("x", "*").replaceAll("%", "/100");
    num result = text.interpret();
    String resultString = result.toStringAsFixed(2).toString();
    String resultStr = resultString;
    if(resultString.endsWith('.0'))
    {
      resultStr = resultString.substring(0,resultString.length-2);

    }
    else if (resultString.endsWith('.00'))
    {
      resultStr = resultString.substring(0,resultString.length-3);
    }

    resultText =resultStr;
    notifyListeners();
  }

  dot()
  {
    String text = calcController.text;
    int lastOperatorIndex = text.lastIndexOf(RegExp(r'[+\-*/x÷]'));
    String lastNumber = text.substring(lastOperatorIndex + 1);


    if (lastNumber.isNotEmpty &&lastNumber.contains(".")) {
      return;
    }
    else if (calcController.text.isEmpty) {
      calcController.text += "0.";
    } else {
      calcController.text += ".";
    }
  }

  void delete() {
    if(calcController.text.isEmpty) {
      resultText='';
      notifyListeners();
    }
    String text = calcController.text;
    text = text.substring(0, text.length-1);
    calcController.text = text;
    notifyListeners();
    calculate();
  }

  positiveToNegative()
  {
    String text = calcController.text;
    int lastOperatorIndex = text.lastIndexOf(RegExp(r'[+\-*/x÷(]'));
    String lastNumber = text.substring(lastOperatorIndex + 1);
    if (text.isEmpty) return;
    if (lastNumber.isEmpty || lastNumber == '-') return;

    if(lastNumber.startsWith('-')) {
      lastNumber = lastNumber.substring(1);
    } else {
      lastNumber = '-$lastNumber';

    }
    text = text.substring(0, lastOperatorIndex + 1) + lastNumber;
    calcController.text = text;
    calcController.selection = TextSelection.fromPosition(
        TextPosition(offset: calcController.text.length));
    notifyListeners();

  }

  parenthesisOperation()
  {
    String text = calcController.text;

    // Count the number of opening and closing parentheses
    int openCount = '('.allMatches(text).length;
    int closeCount = ')'.allMatches(text).length;

    // If the last character is a number or closing parenthesis, and we have open parentheses that haven't been closed
    if (openCount > closeCount && (text.isNotEmpty && RegExp(r'[0-9)]$').hasMatch(text))) {
      calcController.text += ')';
    }
    // If the last character is an operator, open a new parenthesis
    else if (text.isEmpty || RegExp(r'[+\-*/x÷(]$').hasMatch(text)) {
      calcController.text += '(';
    }
    // For any other case, open a new parenthesis
    else {
      calcController.text += 'x(';
    }

    calcController.selection = TextSelection.fromPosition(
        TextPosition(offset: calcController.text.length));
    notifyListeners();
  }



  @override
  void dispose() {
    super.dispose();
    calcController.dispose();
  }
}