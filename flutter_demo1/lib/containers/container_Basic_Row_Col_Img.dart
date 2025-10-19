import 'package:flutter/material.dart';
import 'package:flutter_demo1/containers/app_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Row, Column & Image Example"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, //Row takes minimun horizontal space
              children: [
                //1. Image
                Image.network(
                  //image link
                  'https://img.freepik.com/free-photo/closeup-scarlet-macaw-from-side-view-scarlet-macaw-closeup-head_488145-3540.jpg?semt=ais_hybrid&w=740&q=80',
                  width: 80,
                  height: 80,
                ),
                AppContainer(width: 12),
                const SizedBox(
                  width: 16, //space between image and Text
                ),
                //2. The Column for Text
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, //Align text tothe left
                  mainAxisSize:
                      MainAxisSize.min, //Column take minimum vertical space
                  children: [
                    Text(
                      'Flutter DEV',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5, //Space Between title and subtitle
                    ),
                    Text(
                      'UI Framework',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
