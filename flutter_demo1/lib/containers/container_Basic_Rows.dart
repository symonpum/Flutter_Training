import 'package:flutter/material.dart';
import 'package:flutter_demo1/containers/app_container.dart';

void main() {
  runApp(MaterialApp(home: RowUsage()));
}

class RowUsage extends StatelessWidget {
  const RowUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Container Basic: Rows"),
      ),
      body: Column(
        children: [
          //what are the children of this column
          _rowJustifyContentCenter(),
          _rowJustifyContentStart(),
          _rowJustifyContentSpaceBetween(),
          _rowJustifyContentSpaceAround(),
        ],
      ),
    );
  }

  //declare Childrend to show in Body>Column>Children
  SizedBox _rowJustifyContentCenter() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star, size: 50),
          Text("Row"),
          SizedBox(width: 12),
          AppContainer(width: 30, height: 20),
        ],
      ),
    );
  }

  SizedBox _rowJustifyContentStart() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.star, size: 50),
          Text("Row"),
          SizedBox(width: 12),
          AppContainer(width: 30, height: 20),
        ],
      ),
    );
  }

  SizedBox _rowJustifyContentSpaceBetween() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.star, size: 50),
          Text("Row"),
          AppContainer(width: 30, height: 20),
        ],
      ),
    );
  }

  SizedBox _rowJustifyContentSpaceAround() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.star, size: 50),
          Text("Row"),
          AppContainer(width: 30, height: 20),
        ],
      ),
    );
  }
}
