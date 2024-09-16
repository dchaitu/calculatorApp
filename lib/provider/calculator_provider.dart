import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';

class CalculatorProvider extends ChangeNotifier {
  final calcController = TextEditingController();
  String resultText = '';
  String roundingValue = '';
  int openParenthesesCount = 0;
  bool showHistory = false;
  List<Map<String, String>> history = [];


  setShowHistory()
  {
    showHistory = !showHistory;
    print("showHistory:- $showHistory");
    notifyListeners();

  }

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
        calculate();
        print("**************************Calculated**********************");
        if(resultText.isNotEmpty) {
          history
              .add({'expression': calcController.text, 'result': resultText});
          print("'expression': ${calcController.text}, 'result': $resultText");
          calcController.text = resultText.replaceAll(',', '');
        }
        else{
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
        calculate();

        calcController.selection = TextSelection.fromPosition(
            TextPosition(offset: calcController.text.length));
        notifyListeners();
    }


  }


  roundedResultToKMB(String value)
  {
    String stringValue = '';
    if (value.isEmpty) {
      return;
    }
    String cleanedValue = value.replaceAll(',', '');
    print("cleanedValue $cleanedValue");
    double roundValue = double.parse(cleanedValue);
    print("roundValue:- $roundValue");

    double thousands = 1000;
    double millions = 1000000;
    double billions = 1000000000;

    if(roundValue>=billions)
    {
      double actualRoundedValue = roundValue;
      roundValue = roundValue/billions;
      stringValue = actualRoundedValue==billions?"${roundValue.toStringAsFixed(2)}B":"${roundValue.toStringAsFixed(2)}B+";
      print(stringValue);

    }
    else if(roundValue>=millions)
    {
      double actualRoundedValue = roundValue;
      roundValue = roundValue/millions;

      stringValue = actualRoundedValue==millions?"${roundValue.toStringAsFixed(2)}M":"${roundValue.toStringAsFixed(2)}M+";
      print(stringValue);

    }
    else if (roundValue>=thousands)
    {
      double actualRoundedValue = roundValue;
      roundValue = roundValue/thousands;
      stringValue = actualRoundedValue==millions?"${roundValue.toStringAsFixed(2)}K":"${roundValue.toStringAsFixed(2)}K+";

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
    if (number==0) {
      return '';
    }
    while (number < 1) {
      number *= 10;
      exponent--;
    }

    while (number >= 10) {
      number /= 10;
      exponent++;
    }

    String coefficient = (number * 10).toString();
    return "($coefficient*10^(${exponent - 1}))";
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
    String text = calcController.text.replaceAll("x", "*").replaceAll("%", "/100").replaceAll('÷', "/");
    String updatedText =  text.contains('.')? convertDecimalToPower(text): text;

    print("text: $text");
    num result = updatedText.interpret();
    print("result interpreted: $result");
    String resultString = result.toString();
    String resultStr = resultString;
    NumberFormat formatter = NumberFormat("#,##,##0.#########", "en_US");
    double number = double.parse(resultStr);
    resultStr = formatter.format(number).toString();

    if(resultStr.endsWith('.0'))
    {
      resultStr = resultStr.substring(0,resultStr.length-2);

    }
    else if (resultString.endsWith('.00'))
    {
      resultStr = resultStr.substring(0,resultStr.length-3);
    }
    resultText =resultStr;
    print("resultText: $resultText");
    roundingValue = roundedResultToKMB(resultText);
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

  clearHistory()
  {
    history.clear();
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
    calcController.dispose();
  }
}