
import 'package:calculator/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/calculator_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:const Color(0xff010101),
      body: Consumer<CalculatorProvider>(builder: (context, provider, _)
      {
        print("History ${provider.history}");
        return ListView.builder(
          itemCount: provider.history.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(provider.history[index]['expression']!,style: TextStyle(color: Colors.white, fontSize: 18),),
              subtitle: Text(
                '= ${provider.history[index]['result']}'!, style: TextStyle(color: greenOperatorColor, fontSize: 24),),
            );
          },
        );
      
      }),
    );
  }
}
