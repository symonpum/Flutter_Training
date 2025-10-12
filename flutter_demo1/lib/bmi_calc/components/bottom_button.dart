// FILE: lib/bmi_calc/components/bottom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_demo1/bmi_calc/constants.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonTitle;

  const BottomButton({required this.onTap, required this.buttonTitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kBottomContainerColour,
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: kBottomContainerHeight,
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Center(child: Text(buttonTitle, style: kLargeButtonTextStyle)),
      ),
    );
  }
}

