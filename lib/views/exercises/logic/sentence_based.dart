import 'package:flutter/material.dart';

class SentencedQuiz extends StatefulWidget {
  const SentencedQuiz({Key? key}) : super(key: key);

  @override
  State<SentencedQuiz> createState() => _SentencedQuizState();
}

List _questionsAnswers = [
  {
    "quest": "",
    "answers": [
      {"1": ""},
      {"2": ""},
      {"3": ""},
      {"4": ""}
    ],
    "img": "",
    "right": ""
  },
  {
    "quest": "",
    "answers": [
      {"1": ""},
      {"2": ""},
      {"3": ""},
      {"4": ""}
    ],
    "img": "",
    "right": ""
  },
  {
    "quest": "",
    "answers": [
      {"1": ""},
      {"2": ""},
      {"3": ""},
      {"4": ""}
    ],
    "img": "",
    "right": ""
  },
];

class _SentencedQuizState extends State<SentencedQuiz> {
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: ListWheelScrollView(
          itemExtent: width,
          children: List.generate(
            _questionsAnswers.length,
            (index) => Container(
              decoration: BoxDecoration(
                
              ),
            ))));
  }
}
