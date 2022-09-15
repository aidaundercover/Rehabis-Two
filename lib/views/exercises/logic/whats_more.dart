import 'dart:async';

import 'package:confetti/confetti.dart';
import "package:flutter/material.dart";
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/exercise_api.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class WhatsMore extends StatefulWidget {
  const WhatsMore({Key? key}) : super(key: key);

  @override
  State<WhatsMore> createState() => _WhatsMoreState();
}

List<List<bool>> isSelected = [];

List q1 = ["assets/orange.png", "assets/melon.png", "assets/watermelon.png"];

List q2 = [
  "assets/purple_box.png",
  "assets/red_box.png",
  "assets/green_box.png"
];

class _WhatsMoreState extends State<WhatsMore> {
  late int points;
  late int pressed;
  final controller = ConfettiController();

  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;

  void getPoint() {
    setState(() {
      if (points == 2) {
      } else {
        points++;
      }
    });
  }

  void getError() {
    setState(() {
      if (points == 2) {
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
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer(int errors, double width) {
    setState(() {
      timer?.cancel();
      isRunning = false;

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      uploadExercise('None', points, '$minutes : $seconds', "What's more",
          "Problem Solving", 1);

      showDialog(
          context: (context),
          builder: (_) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 300,
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? width * 0.8
                        : width * 0.5,
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
                                children: [
                                  Text("Restart",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white)),
                                  Icon(Icons.replay, color: Colors.white)
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              startTimer();
                            },
                          ),
                          const SizedBox(width: 7),
                          TextButton(
                            child: Container(
                              width: 100,
                              height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Exit",
                                      style: TextStyle(color: Colors.white)),
                                  Icon(Icons.exit_to_app, color: Colors.white)
                                ],
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.purple.shade200),
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
                  Center(child: ConfettiWidget(confettiController: controller))
                ]),
              ),
            );
          });
      duration = Duration();
      points = 0;
      pressed = 0;
      isSelected = [
        [false, false, false],
        [false, false, false],
      ];
    });
  }

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
      [false, false, false],
      [false, false, false]
    ];
    points = 0;
    pressed = 0;

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget buildCard(
        String title, String img, List list, int index, int right) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
            width: MediaQuery.of(context).orientation == Orientation.portrait
                ? width * 0.94
                : width * 0.6,
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? height * 0.6
                : height * 0.8,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.005),
                      offset: Offset(3, 3),
                      spreadRadius: 10,
                      blurRadius: 5),
                  BoxShadow(
                      color: Colors.black.withOpacity(0.001),
                      offset: Offset(-3, -3),
                      spreadRadius: 10,
                      blurRadius: 5)
                ]),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                Image.asset(img, width: width * 0.9),
                SizedBox(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            list.length,
                            (i) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      for (int indexBtn = 0;
                                          indexBtn < isSelected[0].length;
                                          indexBtn++) {
                                        if (indexBtn == i) {
                                          isSelected[index][indexBtn] =
                                              !isSelected[index][indexBtn];
                                          if (isSelected[index][indexBtn]) {
                                            if (indexBtn == right) {
                                              getPoint();
                                            }
                                          } else {
                                            if (indexBtn == right) {
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
                                        borderRadius: BorderRadius.circular(10),
                                        color: isSelected[index][i]
                                            ? secondPrimaryColor
                                            : Colors.white,
                                        border: Border.all(
                                            width: 1.5,
                                            color: secondPrimaryColor)),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Image.asset(
                                      list[i],
                                      height: 70,
                                    ),
                                  ),
                                ))))
              ],
            )),
      );
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: exerciseAppbar("What's more ..?", context, "None", points,
            '$minutes : $seconds', "Problem Solving", 1),
        persistentFooterButtons: [
          Center(
            child: TextButton(
              onPressed: () {
                if (isRunning) {
                  controller.play();
                  stopTimer(2 - points, width);
                } else {
                  controller.stop();
                }
              },
              child: const Text(
                "STOP",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              headerExercise(
                width,
                "'What's more' stretches user's ability to make calculataion within limited amount of time.",
                points,
              ),
              SizedBox(
                height: 25,
              ),
              buildCard("What's more expensive?", "assets/what_expensive.png",
                  q1, 0, 1),
              buildCard(
                  "What's more heavy?", "assets/what_heavy.png", q2, 1, 2),
              SizedBox(
                height: 0,
              ),
            ],
          ),
        ));
  }
}
