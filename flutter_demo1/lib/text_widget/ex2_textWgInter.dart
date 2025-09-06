import 'package:flutter/material.dart';

void main() => runApp(const MyTextHomeWork2());

class MyTextHomeWork2 extends StatelessWidget {
  const MyTextHomeWork2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PSM Homework#2'),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            width: 250,
            child: Text(
              'This is a longer piece of text that demonstrates styling, alignment, and overflow behavior with an ellipsis.',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.2,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
