import 'package:flutter/material.dart';
import 'package:flutter_demo1/containers/app_container.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyContainerWidget(),
    ),
  );
}

class MyContainerWidget extends StatelessWidget {
  const MyContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    print("WidthScreen = $widthScreen");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Constainer Basic: Column"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                AppContainer(
                  color: Colors.green,
                ),
                AppContainer(
                  color: Colors.green,
                  width: 80,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            _buildContainer(),
            SizedBox(
              height: 12,
            ),
            _buildContainer(
              width: 300,
              height: 30,
              border: Border.all(
                color: Colors.black,
                width: 5,
                style: BorderStyle.solid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildContainer({
    double width = 100,
    double height = 100,
    Color color = Colors.red,
    BoxBorder? border,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: border,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      //alignment: Alignment.center,
      child: Text("Container"),
    );
  }
}