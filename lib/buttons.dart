import 'package:flutter/material.dart';

Widget iconButton(IconData icon, Color bgColor, Color txtColor, void Function()? onPressed)
{
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

Widget button(String text, Color bgColor, Color txtColor, void Function()? onPressed)
{
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


