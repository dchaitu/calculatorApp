import 'package:calculator/provider/calculator_provider.dart';
import 'package:calculator/widgets/history_screen.dart';
import 'package:calculator/widgets/numpad.dart';
import 'package:calculator/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final TextEditingController textController = TextEditingController();
  bool showNumPad = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(builder: (context, provider, _)
        {
          return Scaffold(
            backgroundColor:const Color(0xff010101),
            body: SafeArea(
                child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          // mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                             Positioned(
                               bottom: 0,
                               left: 0,
                               child: Container(
                                 alignment: Alignment.topLeft,
                                 child: IconButton(
                                    icon: const Icon(Icons.history),
                                    onPressed: () {
                                      showNumPad=!showNumPad;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HistoryScreen()),
                                    );
                                  },
                                                             ),
                               ),
                             ),
                            CalcTextField(
                              controller:provider.calcController,
                            ),

                            Positioned(
                              bottom: 38,
                              right: 8,
                              child: Text(
                                provider.resultText, // This will store the result
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                provider.roundingValue, // This will store the result
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      getButtonValue(context, 100000, "1Lac"),
                                      getButtonValue(context, 10000000, "1Cr"),
                                      getButtonValue(context, 1000000, "1M"),
                                      getButtonValue(context, 1000000000, "1B"),
                                    ],
                                  ),
                                ),

                                Container(
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.only(right: 16),
                                  child: IconButton(onPressed: ()=>Provider.of<CalculatorProvider>(context,listen: false).delete(),
                                    icon: const Icon(Icons.backspace_outlined),
                                    color: const Color(0xff77f383),
                                  ),
                                ),
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(thickness:2, color: Color(0xff191919)),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  // color: Colors.black54,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                              child: showNumPad? const Numpad():const HistoryScreen(),
                            ),
                          ],
                        ),
                      ),
                    ]
                )
            ),
          );
        });
  }
}

Widget getButtonValue(BuildContext context, double value, String textVal)
{
  return Container(
    alignment: Alignment.topLeft,
    // margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration:BoxDecoration(
        color:const Color(0xff2D2D2F),
        borderRadius:BorderRadius.circular(100)
    ),
    child: TextButton(onPressed: ()=>Provider.of<CalculatorProvider>(context,listen: false).addButtonValue(value),
      child: Text(textVal,
          style: const TextStyle(color: Colors.white)
      ),
    ),
  );

}