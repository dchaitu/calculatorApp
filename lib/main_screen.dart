import 'package:calculator/provider/calculator_provider.dart';
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
                              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              child: const Numpad(),
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