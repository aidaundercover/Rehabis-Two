import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/exercise_api.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class LadyBag extends StatefulWidget {
  const LadyBag({Key? key}) : super(key: key);

  @override
  State<LadyBag> createState() => _LadyBagState();
}

List isSelected = [
  false,
  false,
  false,
];

List images = [
  "assets/r.png",
  "assets/r_t.png",
  "assets/c_r_t.png",
];

class _LadyBagState extends State<LadyBag> {
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
    isSelected = [false, false, false];

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

        uploadExercise('None', points, '$minutes : $seconds', 'Find a Ladybag',
            "Problem Solving", 1);

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
        isSelected = [false, false, false];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textHeader(width,
                    'The exercise helps with an attention and a logic, in order to execue an exercise one should be able to identify the exceeding element of a group'),
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
      backgroundColor: Colors.white,
      appBar: exerciseAppbar('Find a Ladybag', context, 'None', points,
          '$minutes : $seconds', "Attention", 1),
      // persistentFooterButtons: [
      //   Center(
      //     child: TextButton(
      //       onPressed: () {

      //       },
      //       child: const Text(
      //         "STOP",
      //         style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      //       ),
      //     ),
      //   )
      // ],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              appBar(),
              Text(
                "Where is the ladybag?",
                style: TextStyle(fontFamily: "Inter", fontSize: 23),
              ),
              Image.asset(
                "assets/find_ladybag.png",
                width: isPortrait ? width * 0.8 : width * 0.23,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    isSelected.length,
                    (index) => GestureDetector(
                          onTap: () {
                            for (int indexBtn = 0;
                                indexBtn < isSelected.length;
                                indexBtn++) {
                              if (indexBtn == index) {
                                isSelected[indexBtn] = !isSelected[indexBtn];
                                if (isSelected[indexBtn]) {
                                  if (indexBtn == 1) {
                                    stopTimer(0, width);

                                    if (isRunning) {
                                      controller.play();
                                      stopTimer(0, width);
                                    } else {
                                      controller.stop();
                                    }
                                  }
                                }
                              } else {
                                isSelected[indexBtn] = false;
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.01),
                                      spreadRadius: 7,
                                      blurRadius: 13,
                                      offset: Offset(2, 3)),
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      spreadRadius: 7,
                                      blurRadius: 13,
                                      offset: Offset(-2, -3)),
                                ],
                                color: isSelected[index]
                                    ? secondPrimaryColor
                                    : Color.fromARGB(255, 249, 249, 249)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 3),
                            child: Image.asset(
                              images[index],
                              height: 49,
                            ),
                          ),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
