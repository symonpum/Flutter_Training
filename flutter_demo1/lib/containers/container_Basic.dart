import 'package:flutter/material.dart';

void main() {
  runApp(MyContainerApp());
}

class MyContainerApp extends StatelessWidget {
  const MyContainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Title: Container Basic"),
        ),
        backgroundColor: Colors.amber,
        body: SafeArea(
          child: Container(
            width: 100.0,
            height: 100.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Text('Hello Container'),
          ),
        ),
      ),
    );
  }
}
