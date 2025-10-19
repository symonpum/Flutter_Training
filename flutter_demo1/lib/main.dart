import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Demo'),
          titleTextStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.blue,
        body: Container(
          child: Center(
            child: Text(
              'Hello Flutter',
              style: TextStyle(
                fontSize: 36.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
