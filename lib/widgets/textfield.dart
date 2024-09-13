import 'package:flutter/material.dart';

class CalcTextField extends StatelessWidget {
  const CalcTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextField(
        maxLines: 2,
        controller: controller,
        cursorColor: const Color(0xff77f383),
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          fillColor: Colors.transparent,
            border: InputBorder.none,
            filled: true,
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
        ),
        readOnly: true,
        keyboardType:TextInputType.none,
        showCursor: true,
      ),
    );
  }
}