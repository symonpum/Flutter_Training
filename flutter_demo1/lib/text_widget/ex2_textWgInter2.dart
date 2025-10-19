
import 'package:flutter/material.dart';

void main() => runApp(const MyTextHomeWork2_());

class MyTextHomeWork2_ extends StatelessWidget {
  const MyTextHomeWork2_({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PSM Homework#2.1'),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                'Text Red with Underline solid.\n',
                textAlign: TextAlign.justify,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  letterSpacing: 1.1,
                  height: 1.4,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.red,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              Text(
                'Text Green with Overline-Dashed\n',
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  height: 1.6,
                  letterSpacing: 1.0,
                  decoration: TextDecoration.overline,
                  decorationColor: Colors.yellow,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              ),
              Text(
                'Text Blue with Line Throug RED\n',
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  height: 1.6,
                  letterSpacing: 1.0,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.red,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 4,
                ),
              ),
              Text(
                '\nSpecial Discount \$99.99',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.red,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
