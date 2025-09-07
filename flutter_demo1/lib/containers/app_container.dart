import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const AppContainer({
    super.key,
    this.width = 100,
    this.height = 100,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.red,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Text("Container"),
    );
  }
}
