import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: TextWidget()));
}

class TextWidget extends StatelessWidget {
  const TextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Text"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Text(
          "សួស្តី លោកម្ចាស់!\n Test Text Widget",
        ),
      ),
    );
  }
}
