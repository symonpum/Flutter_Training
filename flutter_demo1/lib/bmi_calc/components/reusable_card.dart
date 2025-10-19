// FILE: lib/bmi_calc/components/reusable_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_demo1/bmi_calc/constants.dart';

class ReusableCard extends StatelessWidget {
  final Color colour;
  final Widget? cardChild;
  final VoidCallback? onPress;

  const ReusableCard(
      {required this.colour, this.cardChild, this.onPress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
