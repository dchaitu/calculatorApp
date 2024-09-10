import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: TextFieldWidget()
    );
  }
}


class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({super.key});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  String num1 = "";
  String num2 = "";
  String operand = "";
  String history = "";


  Widget calculatorButtons()
  {
    return Container(

        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: allButtons(),
        )
    );
  }

  void Function()? buttonOnClick(String value) {
    print(value);
    if (value=="B")
      {
        delete();
        return null;
      }
    if (value=="AC")
      {
        allClear();
        return null;

      }
    if (value=="%")
      {
        percentageOfValue();
        return null;
      }
    if (value=="=")
      {
        calculate();
        return null;
      }
    appendValue(value);

    setState(() {
    });

    return null;
  }

  void calculate()
  {
    if (num1.isEmpty || num2.isEmpty || operand.isEmpty)
      {
        return null;
      }
    final parseNum1 = double.parse(num1);
    final parseNum2 = double.parse(num2);
    var result = 0.0;
    var historyString='';

    switch (operand)
        {
      case 'X':
        result = parseNum1*parseNum2;

        break;

      case '+':
        result = parseNum1+parseNum2;
        break;

      case '-':
        result = parseNum1-parseNum2;
        break;

      case '/':
        result = parseNum1/parseNum2;
        break;
      default:
        break;

    }
    historyString = '$num1$operand$num2';
    print(historyString);


    setState(() {
  num1=result.toString();
  operand='';
  num2='';
  history=historyString;
});


  }


  void percentageOfValue()
  {
    if(num1.isNotEmpty&&operand.isNotEmpty&&num2.isNotEmpty)
      {
      //   convert first then calculate percentage
        calculate();
      }
    if (operand.isNotEmpty)
      {
        return;
      }
    final number = num1;
    final num = double.parse(num1)/100;
    setState(() {
      num1=num.toString();
      operand="";
      num2="";
      history='$number%';
    });
  }

  void allClear()
  {
    num1='';
    operand='';
    num2='';
    setState(() {
      history="";
    });

  }

  void delete()
  {
    if(num2.isNotEmpty)
      {
        num2 = num2.substring(0,num2.length-1);
      }
    else if (operand.isNotEmpty)
      {
        operand = "";
      }
    else if(num1.isNotEmpty)
    {
      num1 = num1.substring(0,num1.length-1);
    }
    setState(() {

    });
  }


  void appendValue(String value)
  {
    if(value!='.' &&int.tryParse(value)==null)
    {
      if(operand.isNotEmpty&&num2.isNotEmpty)
      {
        //   Calculate equation until then
      calculate();

      }
      operand = value;
    }
    else if(num1.isEmpty || operand.isEmpty )
    {
      // assign value to num1
      //decimal value
      if(value=='.' && num1.contains('.')) return null;
      if(value=='.' && (num1.isEmpty || num1=='0')) {
        // 0.11
        value = "0.";
      }
      num1+=value;
    }
    else if(num2.isEmpty || operand.isNotEmpty)
    {
      //decimal value
      if(value=='.' && num2.contains('.')) return null;
      if(value=='.' && (num2.isEmpty || num2=='0')) {
        // 0.11
        value = "0.";
      }
      num2+=value;
    }
  }


  Widget button(String text, Color bgColor, Color txtColor, void Function()? onPressed)
  {
    return Container(
      padding:const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration:BoxDecoration(
          color:bgColor,
          borderRadius:BorderRadius.circular(100)
      ),
      child: TextButton(onPressed: onPressed,
          child: Text(text.toString(),
            style: TextStyle(color: txtColor, fontSize: 35),
          )
      ),
    );

  }

  Widget backspaceIconButton(Color bgColor, Color txtColor, void Function()? onPressed)
  {
    return Container(
        height:80,
      width: 80,
      padding:const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration:BoxDecoration(
          color:bgColor,
          borderRadius:BorderRadius.circular(100)
      ),
      child: IconButton(onPressed: onPressed,
          color:Colors.white,
        icon: const Icon(Icons.backspace),
          iconSize:32,
          )

    );

  }

  List<Widget> allButtons()
  {
    const nums = ["AC","()", "%",'/',7,8,9,'+',4,5,6,'-',1,2,3 ,'X',0,'.','B','=' ];
    List<Widget> buttons = [];
    List<Widget> numpad = [];

    for(int i=0;i<nums.length;i++) {
      {
        Color txtColor = Colors.white;
        Color bgColor = Colors.black26;

        if(nums[i]=='B')
        {
          Color bgColor = Colors.blueAccent;
          Widget newButton = backspaceIconButton(bgColor,txtColor,()=>buttonOnClick(nums[i].toString()));
          buttons.add(newButton);
        }

        else if(nums[i] is String)
        {
          Color bgColor = Colors.blueAccent;
          Widget newButton = button(nums[i].toString(),bgColor,txtColor,()=>buttonOnClick(nums[i].toString()));
          buttons.add(newButton);
        }

        else{
          Widget newButton =  button(nums[i].toString(),bgColor,txtColor,()=>buttonOnClick(nums[i].toString()));
          buttons.add(newButton);
        }

        if ((i+1)%4==0)
        {
          numpad.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons));
          buttons=[];
        }
      }

    }

    return numpad;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(

          decoration: const BoxDecoration(
            color: Colors.black54,

          ),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: [
                    Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(16),
                        child: Text(history.isEmpty?"":history,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight:FontWeight.bold,
                              color: Colors.white,
                              fontSize: 32
                          ),
                        )
                    ),
                    Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(16),
                        child: Text("$num1$operand$num2".isEmpty?"0":"$num1$operand$num2",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight:FontWeight.bold,
                              color: Colors.white,
                              fontSize: 48
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  child: calculatorButtons(),
          )
              ]
              ),
        )
      ),
    );
  }
}

