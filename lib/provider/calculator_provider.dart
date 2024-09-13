import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class CalculatorProvider extends ChangeNotifier {
  final calcController = TextEditingController();
  String resultText = '';
  int openParenthesesCount = 0;
  bool showResult = false;


  setValue(String value) {
    String controllerText = calcController.text;
    int textLength = controllerText.length;
    switch (value) {
      case "C":
        calcController.clear();
        resultText = "";
        notifyListeners();
        break;

      case "x":

        if (RegExp(r'[+\-*/x÷]').hasMatch(controllerText[textLength - 1]) &&
            RegExp(r'[+\-*/x÷]').hasMatch(value)) {
          controllerText = controllerText.substring(0, textLength - 1) + value;
          calcController.text = controllerText;
        }
        else {
          calcController.text += "x";
        }
        break;
      case "=":
        calculate();
        calcController.text = resultText;
        resultText="";
        notifyListeners();
        break;

      case "+/-":
          positiveToNegative();
          calculate();
        break;
      case ".":
        dot();
        break;

      case"()":
        parenthesisOperation();
        calculate();
        break;


      default:
        if(textLength>0) {

          if (controllerText[textLength-1] == ")" && double.tryParse(value) != null) {
            calcController.text += 'x$value';
          }
          else if (RegExp(r'[+\-*/x÷]').hasMatch(controllerText[textLength - 1]) &&
              RegExp(r'[+\-*/x÷]').hasMatch(value)) {
            controllerText = controllerText.substring(0, textLength - 1) + value;
            calcController.text = controllerText;
          }
          else{
            calcController.text += value;
          }
        }
        else {
          calcController.text += value;
        }

        resultText+=value;

        if(double.tryParse(value) != null || value ==")") {
          calculate();
        }

        calcController.selection = TextSelection.fromPosition(
            TextPosition(offset: calcController.text.length));
        notifyListeners();
    }


  }

  calculate() {
    String text = calcController.text.replaceAll("x", "*").replaceAll("%", "/100").replaceAll('÷', "/");
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
    int lastOperatorIndex = text.lastIndexOf(RegExp(r'[+\*/x÷(]'));
    String lastNumber = text.substring(lastOperatorIndex + 1);
    if (text.isEmpty) return;
    if (lastNumber.isEmpty || lastNumber.isEmpty || lastNumber == '-') return;

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