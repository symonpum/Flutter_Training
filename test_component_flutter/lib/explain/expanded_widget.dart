import 'package:flutter/material.dart';

class ExpandedWidget extends StatelessWidget {
  const ExpandedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3, // 3/4
          child: Container(
            color: Colors.amber,
            height: 150,
            child: Row(
              children: [
                Container(
                  color: Colors.green,
                  width: 50,
                  height: 120,
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    width: 50,
                    height: 120,
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.red,
            height: 0,
          ),
        ),
      ],
    );
  }
}
