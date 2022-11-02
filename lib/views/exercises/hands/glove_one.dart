import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/exercise_api.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class GloveOne extends StatefulWidget {
  const GloveOne({Key? key}) : super(key: key);

  @override
  State<GloveOne> createState() => _GloveOneState();
}

class _GloveOneState extends State<GloveOne> {
  int fingerPosition = 1;
  List<bool> fingers = [false, false, false, false, false];

  int points = 0;
  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;
  final controller = ConfettiController();

  void updateStarCount(Object? data) {
    setState(() {
      fingerPosition = int.parse(data.toString());

      fingers[fingerPosition - 1] = true;

      switch (fingerPosition - 1) {
        case 0:
          {
            fingers[1] = false;
            fingers[2] = false;
            fingers[3] = false;
            fingers[4] = false;
          }
          break;
        case 1:
          {
            fingers[0] = false;
            fingers[2] = false;
            fingers[3] = false;
            fingers[4] = false;
          }
          break;
        case 2:
          {
            fingers[0] = false;
            fingers[1] = false;
            fingers[3] = false;
            fingers[4] = false;
          }
          break;
        case 3:
          {
            fingers[0] = false;
            fingers[1] = false;
            fingers[2] = false;
            fingers[4] = false;
          }
          break;
        case 4:
          {
            fingers[0] = false;
            fingers[1] = false;
            fingers[3] = false;
            fingers[3] = false;
          }
      }

      points++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('coordinates/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      updateStarCount(data);

      print(data);
    });

    points = 0;

    startTimer();

    super.initState();
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
    setState(() {
      timer?.cancel();
      isRunning = false;

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      uploadExercise('Cube', points, '$minutes : $seconds', 'Fingers Exercise',
          "Arm Mobility", 3);

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
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
        ? true
        : false;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    Widget circle(Color color) {
      return Container(decoration: BoxDecoration(color: color));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: exerciseAppbar("Fingers exercise", context, "Glove", points,
            'timer', 'Arm mobility', 1),
        persistentFooterButtons: [
          Center(
            child: TextButton(
              onPressed: () {
                if (isRunning) {
                  controller.play();
                  stopTimer(0, width);
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  headerExercise(
                      width,
                      "This exercise is created to enhance finger flexibility and reduce bone tremor",
                      points),
                ],
              ),
              Stack(children: [
                SizedBox(
                    height: height * 0.86,
                    child: Image.asset("assets/glove.png")),
                isPortrait
                    ? AnimatedPositioned(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 450),
                        left: fingers[0]
                            ? width * 0.37
                            : fingers[1]
                                ? width * 0.285
                                : fingers[2]
                                    ? width * 0.43
                                    : fingers[3]
                                        ? width * 0.577
                                        : width * 0.83,
                        top: fingers[0]
                            ? 150
                            : fingers[1]
                                ? 110
                                : fingers[2]
                                    ? 95
                                    : fingers[3]
                                        ? 135
                                        : 270,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(244, 173, 255, 1.0),
                                Color.fromRGBO(200, 186, 255, 1.0)
                              ])),
                          alignment: Alignment.center,
                          child: Text("$fingerPosition"),
                        ),
                      )
                    : AnimatedPositioned(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 450),
                        left: fingers[0]
                            ? 47
                            : fingers[1]
                                ? 96
                                : fingers[2]
                                    ? 146
                                    : fingers[3]
                                        ? 200
                                        : 300,
                        top: fingers[0]
                            ? 120
                            : fingers[1]
                                ? 85
                                : fingers[2]
                                    ? 70
                                    : fingers[3]
                                        ? 93
                                        : 230,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(244, 173, 255, 1.0),
                                Color.fromRGBO(200, 186, 255, 1.0)
                              ])),
                          alignment: Alignment.center,
                          child: Text("$fingerPosition"),
                        ),
                      )
              ])
            ],
          ),
        ));
  }
}
