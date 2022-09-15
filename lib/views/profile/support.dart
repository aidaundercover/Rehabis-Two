import 'package:flutter/material.dart';
import 'package:rehabis/models/supportQuestion.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<SupportQuestion> _questionsList = [
      SupportQuestion(
        question: "Why ",
        answer: "",
      ),
      SupportQuestion(question: "Why ", answer: ""),
      SupportQuestion(question: "Why ", answer: ""),
      SupportQuestion(question: "Why ", answer: ""),
      SupportQuestion(question: "Why ", answer: ""),
      SupportQuestion(question: "Why ", answer: ""),
    ];

    return Scaffold(
      appBar: AppBar(),
        body: Center(
          child: SizedBox(
            width: width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Tell us how we can help👋",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.85),
                        fontFamily: "Inter",
                        fontSize: 25),
                  ),
                  Text(
                    "Our crew of superheroes are standing by for service and support!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Inter",
                      fontSize: 16,
                    ),
                  ),
                  ExpansionPanelList(
                      expansionCallback: (index, isExpanded) {
                        setState(() {
                          _questionsList[index].isExpanded =
                              !_questionsList[index].isExpanded;
                        });
                      },
                      children: _questionsList
                          .map((index) => ExpansionPanel(
                              isExpanded: index.isExpanded,
                              canTapOnHeader: true,
                              headerBuilder: (context, b) => Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Text(index.question),
                                  ),
                              body: Container(
                                child: Text(index.answer),
                              )))
                          .toList())
                ],
              ),
            ),
          ),
        ),
      
    );
  }
}
