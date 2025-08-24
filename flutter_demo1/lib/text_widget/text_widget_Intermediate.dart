import 'package:flutter/material.dart';

void main(List<String> args){
  runApp(
    MaterialApp(
      home: TextWidgetIntermediate(),
    )
  );
}
class TextWidgetIntermediate extends StatelessWidget{
  const TextWidgetIntermediate({super: key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text(
            "Intermediate WG",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    height: 1.5,
                  ),
                ),
                Text(
                  "aaaaaaaa",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(0, 0, 128),
                    letterSpacing: 1.2,
                    height: 1.5,
                  ),
                ),
                Text(
                  "BB",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(#800000),
                    letterSpacing: 1.2,
                    height: 1.5,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  "AA",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(#008000),
                    letterSpacing: 1.2,
                    height: 1.5,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                )
              ],
          ),
        ),
    );
  }
}