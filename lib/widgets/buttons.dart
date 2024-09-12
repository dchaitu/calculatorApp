import 'package:flutter/material.dart';

class IconButton1 extends StatelessWidget {
  const IconButton1({super.key, required this.icon, required this.bgColor, required this.txtColor, this.onPressed});

  final IconData icon;
  final Color bgColor, txtColor;
  final void Function()? onPressed;


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
          child: IconButton(onPressed: onPressed,
            color:txtColor,
            icon: Icon(icon),
            iconSize:30,
          )

      ),
    );

  }
  }






