// FILE: lib/bmi_calc/screens/results_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_demo1/bmi_calc/constants.dart';
import 'package:flutter_demo1/bmi_calc/components/reusable_card.dart';
import 'package:flutter_demo1/bmi_calc/components/bottom_button.dart';

class ResultsPage extends StatelessWidget {
  final String bmiResult;
  final String resultText;
  final String interpretation;

  const ResultsPage(
      {required this.bmiResult,
      required this.resultText,
      required this.interpretation,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              child: const Text('លទ្ធផល​របស់​អ្នក', style: kTitleTextStyle),
            ),
          ),
          Expanded(
            flex: 5,
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(resultText.toUpperCase(), style: kResultTextStyle),
                  Text(bmiResult, style: kBMITextStyle),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(interpretation,
                        textAlign: TextAlign.center, style: kBodyTextStyle),
                  ),
                ],
              ),
            ),
          ),
          BottomButton(
            buttonTitle: 'គណនា​ម្តង​ទៀត',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
