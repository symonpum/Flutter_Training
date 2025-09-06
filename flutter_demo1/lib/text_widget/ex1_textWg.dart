import 'package:flutter/material.dart';

void main() => runApp(const MyTextHomeWork1());

class MyTextHomeWork1 extends StatelessWidget {
  const MyTextHomeWork1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PSM Homework#1'),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Hello, Symon PUM',
          ),
        ),
      ),
    );
  }
}