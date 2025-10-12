import 'package:flutter/material.dart';
import 'package:flutter_demo1/bmi_calc/screens/input_page.dart';
import 'package:flutter_demo1/bmi_calc/constants.dart';

void main() => runApp(const BMICalculator());

class BMICalculator extends StatelessWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Colors.white,
          inactiveTrackColor: Color(0xFF8D8E98),
          thumbColor: Color(0xFFEB1555),
          overlayColor: Color(0x29EB1555),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
        ),
      ),
      home: const InputPage(),
    );
  }
}
