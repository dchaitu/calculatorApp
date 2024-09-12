import 'package:calculator/provider/calculator_provider.dart';
import 'package:calculator/widgets/button2.dart';
import 'package:calculator/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/buttons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final TextEditingController textController = TextEditingController();



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








  List<Widget> allButtons()
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
              txtColor:txtColor,onPressed: ()=>Provider.of<CalculatorProvider>(context, listen: false).setValue(nums[i].toString()));
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(builder: (context, provider, _)
        {
          return Scaffold(
            body: SafeArea(
                child: Container(
                  // padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xff010101),

                  ),
                  child: Column(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                Container(
                                    alignment: Alignment.bottomRight,
                                    padding: const EdgeInsets.all(16),
                                    child: CalcTextField(
                                      controller:provider.calcController,
                                    )
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    provider.resultText, // This will store the result
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: IconButton(onPressed: ()=>Provider.of<CalculatorProvider>(context,listen: false).delete(),
                                  icon: const Icon(Icons.backspace_outlined),
                                  color: const Color(0xff77f383),
                                ),
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(thickness:2, color: Color(0xff191919)),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    // color: Colors.black54,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                child: calculatorButtons(),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                )
            ),
          );
        });
  }
}