
import 'package:calculator/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/calculator_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>
      (builder: (context, provider, _)
    {
      return Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 500,
                width: 300,
                child: Scaffold(
                    backgroundColor: appBgColor,
                    body: Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: Provider
                              .of<CalculatorProvider>(context, listen: false)
                              .history
                              .length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(Provider
                                  .of<CalculatorProvider>(context, listen: false)
                                  .history[index]['expression']!,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(color: Colors.white,
                                      fontSize: 18)),
                              subtitle: Text(
                                '= ${Provider
                                    .of<CalculatorProvider>(
                                    context, listen: false)
                                    .history[index]['result']}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: greenOperatorColor, fontSize: 24),),
                            );
                          },
                        ),
                      ),
                    )

                ),
              ),
            ),
            const SizedBox(height: 100),
            Positioned(
                bottom: 10,
                left: 100,
                child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                      // padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                                operatorButtonBgColor),
                          ),
                          onPressed: () =>
                              Provider.of<CalculatorProvider>(
                                  context, listen: false).clearHistory(),
                          child: const Text(
                            'Clear history',
                            style: TextStyle(
                                color: Colors.white),
                          )),
                    )
                )
            ),
            const Positioned(
              right: 0,
              child: SizedBox(
                height: 400, // Adjust this to match the height of your Stack
                child: VerticalDivider(
                  thickness: 2,
                  color: Color(0xff191919),
                ),
              ),
            )


          ]
      );
    }
    );
  }
}
