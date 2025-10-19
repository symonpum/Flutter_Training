import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Decoration Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Text Decoration Examples')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Underline',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                SizedBox(height: 8),
                Text(
                  'Overline',
                  style: TextStyle(decoration: TextDecoration.overline),
                ),
                SizedBox(height: 8),
                Text(
                  'Line Through',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                SizedBox(height: 8),
                Text(
                  'Combined: Overline + Underline',
                  style: TextStyle(
                    decoration: TextDecoration.combine([
                      TextDecoration.overline,
                      TextDecoration.underline,
                    ]),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Dashed Red Underline',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                    decorationStyle: TextDecorationStyle.dashed,
                    decorationThickness: 2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Wavy Blue Strike',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.blue,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$99.99',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        decorationThickness: 2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '\$49.99',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}