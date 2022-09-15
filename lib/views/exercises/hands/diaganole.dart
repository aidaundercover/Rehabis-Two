import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/exercise_api.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class DiagonaleHands extends StatefulWidget {
  const DiagonaleHands({Key? key}) : super(key: key);

  @override
  State<DiagonaleHands> createState() => _DiagonaleHandsState();
}

class _DiagonaleHandsState extends State<DiagonaleHands> {
  int handPosition = 1;
  bool isPressed = false;
  int points = 0;
  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;

  final controller = ConfettiController();

  void updateStarCount(Object? data) {
    setState(() {
      handPosition = int.parse(data.toString());

      if (handPosition % 2 == 1) {
        isPressed = true;
      }

      if (handPosition % 2 == 0) {
        isPressed = false;
      }

      points++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    points = 0;

    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('LR/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      updateStarCount(data);
    });

    controller.addListener(() {
      isRunning ? controller.play() : controller.stop();
    });

    super.initState();
    startTimer();
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

        uploadExercise('Cube', points, '$minutes : $seconds',
            'Flexing Elbow', "Arm Mobility", 1);

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
                  child: Column(
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
                              isRunning = true;

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
                                children: [
                                  Text("Exit",
                                      style: TextStyle(color: Colors.white)),
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
                ),
              );
            });

        duration = Duration();
        points = 0;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
        ? true
        : false;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
        appBar: exerciseAppbar("Flexing elbow", context, "Cube", points,
            '$minutes : $seconds', "Arm mobility", 1),
        backgroundColor: Color.fromRGBO(248, 248, 248, 1),
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
          child: Center(
              child: SizedBox(
                  width: width * 0.96,
                  child: Column(children: [
                    textHeader(width,
                        "Using 'Cubes' equipment user supposed to train the wrist and low-palm area"),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Slide cube on diagonale",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Inter", fontSize: 27),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Stack(children: [
                      Container(
                        width: isPortrait ? width * 0.9 : width * 0.5,
                        height: isPortrait ? width * 0.9 : width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 3, color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top : 30.0, left: 30),
                                  child: SizedBox(
                                    width:
                                        isPortrait ? width * 0.35 : width * 0.15,
                                    child: Text(
                                      "Press RIGHT cube",
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 15,
                                          fontFamily: "Inter"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: isPortrait
                                          ? width * 0.35
                                          : width * 0.15,
                                      child: Text(
                                        "Press LEFT cube",
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 15,
                                            fontFamily: "Inter"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: isPortrait ? width * 0.9 : width * 0.5,
                        height: isPortrait ? width * 0.9 : width * 0.5,
                        child: AnimatedAlign(
                          curve: Curves.easeInCubic,
                          alignment: isPressed
                              ? Alignment.bottomLeft
                              : Alignment.topRight,
                          duration: const Duration(milliseconds: 750),
                          // right: isPressed ? width * 0.45 : 0,
                          // top: isPressed ? 0 : width * 0.45,
                          child: Container(
                            width: width * 0.25,
                            height: width * 0.25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(244, 173, 255, 1.0),
                                  Color.fromRGBO(200, 186, 255, 1.0)
                                ])),
                          ),
                        ),
                      )
                    ])
                  ]))),
        ));
  }
}
