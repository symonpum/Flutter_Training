import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const My_XylophoneApp());
}

class My_XylophoneApp extends StatelessWidget {
  const My_XylophoneApp({super.key});
//Create Function to Play Sound
  void playSound(int soundFile) async {
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/note$soundFile.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Xylophone App'),
          backgroundColor: Colors.teal,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //sound #1
              buildKey(
                color: Colors.red, 
                soundFile: 1, 
                text: 'សំឡេងទី ១'),
              buildKey(
                color: Colors.orange, 
                soundFile: 2, 
                text: 'សំឡេងទី ២'),
              buildKey(
                color: Colors.yellow, 
                soundFile: 3, 
                text: 'សំឡេងទី ៣'),
              buildKey(
                color: Colors.green, 
                soundFile: 4, 
                text: 'សំឡេងទី ៤'),
              buildKey(
                color: Colors.teal, 
                soundFile: 5, 
                text: 'សំឡេងទី ៥'),
              buildKey(
                color: Colors.blue, 
                soundFile: 6, 
                text: 'សំឡេងទី ៦'),
              buildKey(
                color: Colors.purple, 
                soundFile: 7, 
                text: 'សំឡេងទី ៧'),
            ],
          ),
        ),
      ),
    );
  }

//Create Funtions to call for each Button
  Widget buildKey({
    required Color color,
    required int soundFile,
    required String text,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          playSound(soundFile);
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          color: color,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'KhmerOSMuolPali', 
            ),
          ),
        ),
      ),
    );
  }
}
