import 'package:flutter/material.dart';

void main() {
  runApp(const MyImageHomeWork4());
}

class MyImageHomeWork4 extends StatelessWidget {
  const MyImageHomeWork4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      home: const ImagesWidget(),
    );
  }
}

class ImagesWidget extends StatelessWidget {
  const ImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PSM Homework#4'
          )
        ),
      body: Center(
        child: Image.asset('assets/images/clinic_logo.png',
        ),
      ),
    );
  }
}
