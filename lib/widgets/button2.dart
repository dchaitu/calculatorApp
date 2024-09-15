import 'package:flutter/material.dart';

class Button2 extends StatelessWidget {
  const Button2({super.key, required this.text, required this.bgColor, required this.txtColor, this.onPressed, this.size=80});
  final Color bgColor, txtColor;
  final void Function()? onPressed;
  final String text;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:size,
      width: size,
      child: Container(
        padding:const EdgeInsets.all(8),
        decoration:BoxDecoration(
            color:bgColor,
            borderRadius:BorderRadius.circular(100)
        ),
        child: TextButton(onPressed: onPressed,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(text,
                style: TextStyle(color: txtColor, fontSize: 35),
              ),
            )
        ),
      ),
    );
  }
}


