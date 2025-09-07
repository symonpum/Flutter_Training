import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: CardIntermediate()));
}

class CardIntermediate extends StatelessWidget {
  const CardIntermediate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card Basic")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.amber,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(child: Text("data")),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
