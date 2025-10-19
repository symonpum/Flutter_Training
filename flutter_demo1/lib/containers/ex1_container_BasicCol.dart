import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: BasicContainerApp()));
}

class BasicContainerApp extends StatelessWidget {
  const BasicContainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    print(" WidthScreen = $widthScreen");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Basic Container: Column",
          style: TextStyle(fontSize: 24.00, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        width: widthScreen,
        color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.red, style: BorderStyle.solid),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                "Container Box\n150 x 150",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
