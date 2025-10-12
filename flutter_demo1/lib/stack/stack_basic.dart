import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: StackWidget()));
}

class StackWidget extends StatelessWidget {
  final bool showBlueChip;
  final String title;

  const StackWidget({
    super.key,
    this.showBlueChip = false,
    this.title = "title",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stack Data"), backgroundColor: Colors.teal),
      body: Column(children: [_buildStack()]),
    );
  }

  Widget _buildStack() {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xff1488cc), Color(0xff2b32b2)],
                  stops: [0, 1],
                  center: Alignment.center,
                ),
              ),
            ),
          ),
          Positioned(
            right: -18,
            top: -12,
            child: Container(
              alignment: Alignment.center,
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Color(0xFFFF7043),
                shape: BoxShape.circle,
              ),
              child: Text("★", style: TextStyle(color: Colors.white)),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30, // ✅ fixed typo here
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x66ffffff),
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "Label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
