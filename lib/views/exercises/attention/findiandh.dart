import 'dart:async';
import 'dart:core';
import 'package:confetti/confetti.dart';
import "package:flutter/material.dart";
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';
import 'package:rehabis/views/exercises/exercises_main.dart';

import '../../../services/exercise_api.dart';

class ExercizeOne extends StatefulWidget {
  const ExercizeOne({Key? key}) : super(key: key);

  @override
  State<ExercizeOne> createState() => _ExercizeOneState();
}

class _ExercizeOneState extends State<ExercizeOne> {
  int points = 0;
  int pressed = 0;

  List<int> selectedItems = [];
  final controller = ConfettiController();

  List<String> letters = const <String>[
    "h",
    "h",
    "i",
    "j",
    "f",
    "l",
    "f",
    "k",
    "f",
    "j",
    "i",
    "f",
    "f",
    "l",
    "l",
    "f",
    "i",
    "j",
    "k",
    "h",
    "j",
    "f",
    "i",
    "h",
    "t",
    "i",
    "l",
    "i",
    "f",
    "h",
    "k",
    "g",
    "h",
    "l",
    "i",
    "h",
    "l",
    "h",
    "k",
    "j",
    "i",
    "h",
    "i",
    "i",
    "h",
    "g",
    "r",
    "i",
    "g",
    "h",
    "g",
    "r",
    "i",
    "g",
    "h",
    "i",
  ];

  /// TIMER IMPLEMENTING ///
  Duration duration = Duration();
  Timer? timer;
  bool isRunning = false;

  
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();

    super.dispose();
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

      uploadExercise('None', points, '$minutes : $seconds', 'Where are they?', "Attention", 2);

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
      selectedItems = [];
    });
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
    selectedItems = [];

    points = 0;
    pressed = 0;

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    Widget appBar() {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 7,
            ),
            textHeader(width,
                'The exercise helps with an attention and a logic, in order to execue an exercise one should be able to identify the exceeding element of a group'),
          ],
        ),
      );
    }

    Widget mainWidget() {
      return SingleChildScrollView(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 14, mainAxisSpacing: 4),
            itemCount: letters.length,
            itemBuilder: (BuildContext context, int index) {
              bool isPressed = false;
              return Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      isPressed = true;
                      setState(() {
                        // pressed++;
      
                        if (isRunning) {
                          if (selectedItems.contains(index)) {
                          } else {
                            selectedItems.add(index);
                          }
                          if (letters[index] == "i" || letters[index] == "h") {
                            points++;
                          } else
                            pressed++;
      
                          if (points == 21) {
                            stopTimer(0, width);
                          }
                        }
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: selectedItems.contains(index)
                            ? MaterialStateProperty.all(primaryColor)
                            : MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: primaryColor))),
                        shadowColor: MaterialStateProperty.all(
                            Colors.black.withOpacity(0.15))),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letters[index],
                        style: selectedItems.contains(index)
                            ? TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)
                            : TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    }

    Widget timerWidget() {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      return SizedBox(
        width: width * 0.94,
        child: Row(
          children: [
            SizedBox(
              width: width * 0.55,
              child: Text(
                "Выделите все символы i и h как можно быстрее",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Color.fromARGB(255, 82, 82, 82), fontSize: 17),
              ),
            ),
            Row(
              children: [
                buildTimeCard(minutes.toString(), "Минуты"),
                const SizedBox(
                  width: 7,
                ),
                buildTimeCard(seconds.toString(), "Секунды")
              ],
            ),
          ],
        ),
      );
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: exerciseAppbar('Where are they?', context, 'None', points,
          '$minutes : $seconds', "Attention", 2),
      persistentFooterButtons: [
        Center(
          child: TextButton(
            onPressed: () {
              if (isRunning) {
                controller.play();
                stopTimer(56 - points, width);
              } else {
                controller.stop();
              }
            },
            child: const Text(
              "STOP",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBar(),
            SizedBox(
              height: 20,
            ),
            // timerWidget(),
            SizedBox(
              height: 10,
            ),
            mainWidget()
          ],
        ),
      ),
    );
  }
}
