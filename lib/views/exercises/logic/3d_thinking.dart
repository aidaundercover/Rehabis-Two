import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/exercise_api.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class SpaceThinking extends StatefulWidget {
  const SpaceThinking({Key? key}) : super(key: key);

  @override
  State<SpaceThinking> createState() => _SpaceThinkingState();
}

List<List<bool>> isSelected = [];

List _questions = [
  {
    "title": "Lay one picture over the other.",
    "img": "assets/spacethink-1.png",
    "options": [
      "assets/st-1-1.png",
      "assets/st-1-2.png",
      "assets/st-1-3.png",
      "assets/st-1-3.png"
    ],
    "right": 1,
    "right-img": "assets/sp-1-exp.png"
  },
  {
    "title": "How many triangles there in the picture?",
    "img": "assets/spacethink-2.png",
    "options": ["6", "5", "4", "7"],
    "right": 0,
    "right-img": "assets/sp-2-exp.png"
  },
  {
    "title": "Select the view of the figure from the given side",
    "img": "assets/spacethink-3.png",
    "options": [
      "assets/st-3-1.png",
      "assets/st-3-2.png",
      "assets/st-3-3.png",
      "assets/st-3-4.png",
    ],
    "right": 0,
    "right-img": ""
  },
  {
    "title": "Select the view of the figure from the given side",
    "img": "assets/spacethink-4.png",
    "options": [
      "assets/st-4-1.png",
      "assets/st-4-2.png",
      "assets/st-4-3.png",
      "assets/st-4-4.png",
    ],
    "right": 0,
    "right-img": ""
  }
];

class _SpaceThinkingState extends State<SpaceThinking> {
  late int points;
  late int pressed;
  final controller = ConfettiController();

  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {
        isRunning = controller.state == ConfettiControllerState.playing;
      });
    });
    isSelected = [
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false]
    ];

    points = 0;
    pressed = 0;
    startTimer();
  }

  void getPoint() {
    setState(() {
      if (points == 4) {
      } else {
        points++;
      }
    });
  }

  void getError() {
    setState(() {
      if (points == 4) {
      } else {}
    });
  }

  void addTime() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    mounted
        ? setState(() {
            isRunning = true;
          })
        : () {};
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer(int errors, double width) {
    if (mounted) {
      setState(() async {
        timer?.cancel();
        isRunning = false;

        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final minutes = twoDigits(duration.inMinutes.remainder(60));
        final seconds = twoDigits(duration.inSeconds.remainder(60));

        uploadExercise('None', points, '$minutes : $seconds', '3D Thinking',
            "Problem Solving", 2);

        showDialog(
            context: (context),
            builder: (_) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  height: 210,
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? width * 0.8
                          : width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 4, color: Colors.purple)),
                  child: Stack(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text("Well done!",
                                style: TextStyle(
                                    color: deepPurple,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Inter"))),
                        Padding(
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Row(
                            children: [
                              Text("Execution time:",
                                  style: TextStyle(
                                    color: deepPurple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("$minutes: $seconds",
                                  style: TextStyle(
                                    color: deepPurple,
                                    fontSize: 15,
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Row(
                            children: [
                              Text("Number of errors:",
                                  style: TextStyle(
                                    color: deepPurple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("$errors",
                                  style: TextStyle(
                                    color: deepPurple,
                                    fontSize: 15,
                                  ))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Container(
                                width: 100,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.purple.shade200),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Restart",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)),
                                    Icon(Icons.replay, color: Colors.white)
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                // isRunning = true;

                                startTimer();
                              },
                            ),
                            const SizedBox(width: 7),
                            TextButton(
                              child: Container(
                                width: 100,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.purple.shade200),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Exit",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Icon(Icons.exit_to_app, color: Colors.white)
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    Center(
                        child: ConfettiWidget(confettiController: controller))
                  ]),
                ),
              );
            });

        duration = Duration();
        points = 0;
        pressed = 0;
        isSelected = [
          [false, false, false, false],
          [false, false, false, false],
          [false, false, false, false],
          [false, false, false, false]
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget appBar() {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                textHeader(width*0.6,
                    'The exercise helps with an attention and a logic, in order to execue an exercise one should be able to identify the exceeding element of a group'),
                TextButton(onPressed: () {
                        if (isRunning) {
                          controller.play();
                          stopTimer(4, width);
                        } else {
                          controller.stop();
                        }
                      }, child: Container(
                  width: width*0.14,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: primaryColor,
                    
                  ),                      child: const Text(
                        "STOP",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                ))
              ],
            ),
          ],
        ),
      );
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        appBar: exerciseAppbar('3D Thinking', context, 'None', points,
            '$minutes : $seconds', "Attention", 2),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            appBar(),
            // SizedBox(
            //   height: 10,
            // ),
            Center(
              child: SizedBox(
                  height:  isPortrait ? height * 0.5 : height ,
                  width: width * 0.8,
                  child: ListWheelScrollView.useDelegate(
                      perspective: 0.003,
                      diameterRatio: 1.9,
                      physics: const FixedExtentScrollPhysics(),
                      itemExtent: isPortrait ? height * 0.4 : height*0.5,
                      squeeze: 1.1,
                      childDelegate: ListWheelChildLoopingListDelegate(
                          children: List.generate(
                              _questions.length,
                              (i) => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.02),
                                              offset: Offset(3, 3),
                                              blurRadius: 20,
                                              spreadRadius: 10)
                                        ]),
                                    width: isPortrait ?  width * 0.9 : width*0.4,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: width * 0.8,
                                            child: Text(
                                              _questions[i]["title"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: 21),
                                            ),
                                          ),
                                          Image.asset(
                                            _questions[i]["img"],
                                            width: width * 0.75,
                                          ),
                                        ]),
                                  ))))),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: isSelected.length,
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: SizedBox(
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              _questions.length,
                              (i) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    print('$index');
                                    for (int indexBtn = 0;
                                        indexBtn < isSelected.length;
                                        indexBtn++) {
                                      if (indexBtn == i) {
                                        isSelected[index][indexBtn] =
                                            !isSelected[index][indexBtn];
                                        if (isSelected[index][indexBtn]) {
                                          if (indexBtn ==
                                              _questions[index]["right"]) {
                                            getPoint();
                                          }
                                        } else {
                                          if (indexBtn ==
                                              _questions[index]["right"]) {
                                            getError();
                                          }
                                        }
                                      } else {
                                        isSelected[index][indexBtn] = false;
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected[index][i]
                                          ? secondPrimaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: secondPrimaryColor),
                                    ),
                                    width: _questions[i]["options"].length == 3
                                        ? width * 0.27
                                        : width * 0.2,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    alignment: Alignment.center,
                                    child: _questions[index]["options"][0]
                                                .length ==
                                            1
                                        ? Text(
                                            _questions[index]["options"][i],
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontFamily: "Inter"),
                                          )
                                        : Image.asset(
                                            _questions[index]["options"][i])),
                              ),
                            ),
                          ),
                        ),
                      )),
                )),
          SizedBox(height: 100,)
          ]),
        ));
  }
}
