import 'package:flutter/material.dart';

class Button2 extends StatelessWidget {
  const Button2({super.key, required this.text, required this.bgColor, required this.txtColor, this.onPressed});
  final Color bgColor, txtColor;
  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:80,
      width: 80,
      child: Container(
        padding:const EdgeInsets.all(8),
        decoration:BoxDecoration(
            color:bgColor,
            borderRadius:BorderRadius.circular(100)
        ),
        child: TextButton(onPressed: onPressed,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(text.toString(),
                style: TextStyle(color: txtColor, fontSize: 35),
              ),
            )
        ),
      ),
    );
  }
}


