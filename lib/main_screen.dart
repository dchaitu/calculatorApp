import 'package:calculator/provider/calculator_provider.dart';
import 'package:calculator/widgets/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: const Color(0xff010101),
        body: SafeArea(
            child: Column(children: [
          Expanded(
            flex: 1,
            child: Stack(
              // mainAxisAlignment:MainAxisAlignment.start,
              children: [
                CalcTextField(
                  controller: provider.calcController,
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
                    provider.roundingValue,
                    // This will store the result
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getHistoryButton(context),
                        getButtonValue(context, 100000, "Lac"),
                        getButtonValue(context, 10000000, "Cr"),
                        getButtonValue(context, 1000000, "M"),
                        getButtonValue(context, 1000000000, "B"),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        onPressed: () => Provider.of<CalculatorProvider>(
                                context,
                                listen: false)
                            .delete(),
                        icon: const Icon(Icons.backspace_outlined),
                        color: const Color(0xff77f383),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(thickness: 2, color: Color(0xff191919)),
                ),
                Container(
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: Stack(
                      children: [
                        const Numpad(),
                        showHistoryScreen(context),
                      ],
                    )),
              ],
            ),
          ),
        ])),
      );
    });
  }
}

Widget getHistoryButton(BuildContext context)
{
  return Container(
    alignment: Alignment.topLeft,
    child: IconButton(
        icon: Icon(Icons.watch_later_outlined,
            color: watchColor),
        onPressed: () =>
            Provider.of<CalculatorProvider>(context,
                listen: false)
                .setShowHistory()),
  );
}



Widget getButtonValue(BuildContext context, double value, String textVal) {
  return Container(
    alignment: Alignment.topLeft,
    decoration: BoxDecoration(
        color: const Color(0xff2D2D2F),
        borderRadius: BorderRadius.circular(100)),
    child: TextButton(
      onPressed: () => Provider.of<CalculatorProvider>(context, listen: false)
          .addButtonValue(value),
      child: Text(textVal, style: const TextStyle(color: Colors.white)),
    ),
  );
}

Widget showHistoryScreen(BuildContext context) {
  bool showResult =
      Provider.of<CalculatorProvider>(context, listen: false).showHistory;

  return showResult
      ? const Column(
          children: [
            Row(
              children: [
                HistoryScreen(),
              ],
            ),
          ],
        )
      : const SizedBox();
}