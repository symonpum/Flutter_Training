import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: CardIntermediate()));
}

class CardIntermediate extends StatelessWidget {
  const CardIntermediate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Card Intermediate"),
      ),
      backgroundColor: Colors.grey,
      body: Center(
        child: Card(
          elevation: 12.0,
          shadowColor: Colors.blueAccent,
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16.0),
            side: BorderSide(
              color: Colors.blue.shade200,
              width: 1,
            ),
          ),
          hild: Container(
  width: 320,
  padding: const EdgeInsets.all(16.0),
  child: const Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Hello Card"),
      SizedBox(height: 8),
      Text("More content here"),
    ],
  ),
),

        ),
      ),,
    );
  }
}