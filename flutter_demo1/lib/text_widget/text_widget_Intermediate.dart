import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: TextWidgetIntermediate()));
}

class TextWidgetIntermediate extends StatelessWidget {
  const TextWidgetIntermediate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TextWidgetIntermediate")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFFde7607),
                letterSpacing: 1.2,
                height: 1.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Text(
              textAlign: TextAlign.start,
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFFde7607),
                letterSpacing: 1.2,
                height: 1.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Text(
              textAlign: TextAlign.end,
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFFde7607),
                letterSpacing: 1.2,
                height: 1.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            Text(
              textAlign: TextAlign.justify,
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFFde7607),
                letterSpacing: 1.2,
                height: 1.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
