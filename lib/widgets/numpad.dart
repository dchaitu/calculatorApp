import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/calculator_provider.dart';
import 'button2.dart';
import 'buttons.dart';

class Numpad extends StatelessWidget {
  const Numpad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: allButtons(context),
        )
    );
  }
}


List<Widget> allButtons(BuildContext context)
{
  const nums = ["C","()", "%","÷",7,8,9,"x",4,5,6,"-",1,2,3,'+',"+/-",0,".","="];
  List<Widget> buttons = [];
  List<Widget> numpad = [];
  for(int i=0;i<nums.length;i++) {
    {
      Color txtColor = Colors.white;
      Color bgColor = const Color(0xff171719);
      // #DE6461
      if(nums[i]=="C")
      {
        Color bgColor = const Color(0xff2D2D2F);
        Color txtColor = const Color(0xffDE6461);
        Widget newButton = Button2(text:nums[i].toString(), bgColor:bgColor,
          txtColor:txtColor,
          onPressed: ()=>Provider.of<CalculatorProvider>(context, listen: false).setValue(nums[i].toString()),
        );
        buttons.add(newButton);
      }
      else if(nums[i]=='x')
      {
        Color bgColor = const Color(0xff2D2D2F);
        Color txtColor = const Color(0xff77f383);
        Widget newButton = IconButton1(icon:Icons.close ,bgColor:bgColor,
            txtColor:txtColor,
            onPressed: ()=>Provider.of<CalculatorProvider>(context, listen: false).setValue(nums[i].toString()));
        buttons.add(newButton);
      }
      else if(nums[i]=="+/-"|| nums[i]==".")
      {
        Widget newButton =  Button2(text:nums[i].toString(), bgColor:bgColor,
          txtColor:txtColor,
          onPressed: ()=>Provider.of<CalculatorProvider>(context, listen: false).setValue(nums[i].toString()),
        );
        buttons.add(newButton);
      }
      else if(nums[i]=="=")
      {
        Color bgColor = const Color(0xff318608);
        Color txtColor = Colors.white;
        Widget newButton =  Button2(text:nums[i].toString(), bgColor:bgColor,
          txtColor:txtColor,
          onPressed: ()=>Provider.of<CalculatorProvider>(context, listen: false).setValue(nums[i].toString()),
        );
        buttons.add(newButton);
      }
      else if(nums[i] is String)
      {
        Color bgColor = const Color(0xff2D2D2F);
        Color txtColor = const Color(0xff77f383);
        Widget newButton = Button2(text:nums[i].toString(), bgColor:bgColor,
          txtColor:txtColor,
          onPressed: ()=>Provider.of<CalculatorProvider>(context, listen: false).setValue(nums[i].toString()),
        );
        buttons.add(newButton);
      }
      else if(nums[i] is int){
        Widget newButton =  Button2(text:nums[i].toString(), bgColor:bgColor,
          txtColor:txtColor,
          onPressed: ()=>Provider.of<CalculatorProvider>(context, listen: false).setValue(nums[i].toString()),
        );
        buttons.add(newButton);
      }

      if ((i+1)%4==0)
      {
        numpad.add(
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons.map((button) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: button)).toList()
            )
        );
        buttons=[];
      }
    }
  }

  return numpad;
}