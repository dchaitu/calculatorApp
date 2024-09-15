import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';

class CalculatorProvider extends ChangeNotifier {
  final calcController = TextEditingController();
  String resultText = '';
  String roundingValue = '';
  int openParenthesesCount = 0;
  bool showResult = false;
  List<Map<String, String>> history = [];


  setValue(String value) {
    String controllerText = calcController.text;
    int textLength = controllerText.length;
    switch (value) {
      case "C":
        calcController.clear();
        resultText = "";
        roundingValue = '';
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
        print("**************************Pressed =**********************");
        calculate();
        print("**************************Calculated**********************");
        if(resultText.isNotEmpty) {
          history
              .add({'expression': calcController.text, 'result': resultText});
          print("'expression': ${calcController.text}, 'result': $resultText");
          calcController.text = resultText.replaceAll(',', '');
        }
        else{
          print("Error: resultText is null or empty");
          calcController.text = '';
        }
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

        // if(double.tryParse(value) != null || value ==")") {
          calculate();
        // }

        calcController.selection = TextSelection.fromPosition(
            TextPosition(offset: calcController.text.length));
        notifyListeners();
    }


  }


  roundedValue(String value)
  {
    String stringValue = '';
    if (value.isEmpty) {
      return;
    }
    String cleanedValue = value.replaceAll(',', '');
    double roundValue = double.parse(cleanedValue);
    print("roundValue:- $roundValue");

    double thousands = 1000;
    double millions = 1000000;
    double billions = 1000000000;

    if(roundValue>=billions)
    {
      roundValue = roundValue/billions;
      stringValue = "${roundValue.toStringAsFixed(2)}B+";
      print(stringValue);

    }
    else if(roundValue>=millions)
    {
      roundValue = roundValue/millions;
      stringValue = "${roundValue.toStringAsFixed(2)}M+";
      print(stringValue);

    }
    else if (roundValue>=thousands)
    {
      roundValue = roundValue/thousands;
      stringValue = "${roundValue.toStringAsFixed(2)}K+";
      print(stringValue);

    }
    else{
      stringValue = roundValue.toString();
    }
    roundingValue = stringValue;
    print("roundingValue: $roundingValue");
    notifyListeners();

    return roundingValue;
  }

  addButtonValue(double addValue) {
    String controllerText = calcController.text;
    int textLength = controllerText.length;
    double oneLakh = addValue;
    if(controllerText.isEmpty)
      {
        controllerText+= oneLakh.toString();
        calcController.text = controllerText;

      }
    else {
      // last is operator
      if (RegExp(r'[+\-*/x÷]').hasMatch(controllerText[textLength - 1])) {
        controllerText += oneLakh.toString();
      }// last is digit
      else if(RegExp(r'[0-9]').hasMatch(controllerText[textLength - 1]))
      {
        print("Last Digit");
        print((controllerText.substring(textLength - 1)));
        controllerText = '${controllerText.substring(0, textLength)}x$oneLakh';

      }
      calcController.text = controllerText;

    }
    calculate();
    notifyListeners();

  }

  String convertPowerOfTen(double number) {
    int exponent = 0;
    if (number==0)
      return '';
    while (number < 1) {
      number *= 10;
      exponent--;
    }

    while (number >= 10) {
      number /= 10;
      exponent++;
    }

    String coefficient = (number * 10).toStringAsFixed(0);
    return "(${coefficient}*10^(${exponent - 1}))";
  }


  convertDecimalToPower(String text)
  {
    List<String> numbers = text.split(RegExp(r'(?<=[+\-*/x÷()])|(?=[+\-*/x÷()])'));
    print(numbers);
    for(int i=0; i< numbers.length;i++)
      {
        if(numbers[i].contains('.'))
          {
            numbers[i] = convertPowerOfTen(double.tryParse(numbers[i])!);
          }
      }
    print("After changing $numbers");
    String updatedText = numbers.join('');
    print("After changing: $updatedText");
    return updatedText;
  }


  calculate() {
    // try {
    String text = calcController.text.replaceAll("x", "*").replaceAll("%", "/100").replaceAll('÷', "/");
    String updatedText =  text.contains('.')? convertDecimalToPower(text): text;
    if (updatedText == null) {
      throw Exception("Error: convertDecimalToPower returned null");
    }

    print("text: $text");
    num result = updatedText.interpret();
    print("result interpreted: $result");
    String resultString = result.toString();
    String resultStr = resultString;

    if(resultStr.endsWith('.0'))
    {
      resultStr = resultStr.substring(0,resultStr.length-2);

    }
    else if (resultString.endsWith('.00'))
    {
      resultStr = resultStr.substring(0,resultStr.length-3);
    }
    NumberFormat formatter = NumberFormat("#,##,##0.0###", "en_US");
    if (resultStr.isEmpty || resultStr == null) {
      throw Exception("resultStr is null or empty");
    }
    double number = double.parse(resultStr);
    resultStr = formatter.format(number).toString();
    print("result after format $resultStr");

    resultText =resultStr;
    print("resultText: $resultText");
    roundingValue = roundedValue(resultText);
    // }
    // catch (e) {
    //   print("Error in calculate: $e");
    //   resultText = ""; // Set a fallback value
    // }
    print("Calculation done");
    notifyListeners();
  }

  dot()
  {
    String text = calcController.text;
    int textLength = text.length;
    int lastOperatorIndex = text.lastIndexOf(RegExp(r'[+\-*/x÷]'));
    String lastNumber = text.substring(lastOperatorIndex + 1);


    if (lastNumber.isNotEmpty &&lastNumber.contains(".")) {
      return;
    }
    else if (calcController.text.isEmpty) {
      calcController.text += "0.";
    }else if(text[textLength-1].contains(RegExp(r'[+\-*/x÷]')))
    {
      calcController.text += "0.";
    }

    else {
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