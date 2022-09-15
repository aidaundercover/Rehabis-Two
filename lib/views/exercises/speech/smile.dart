import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';
import 'package:rehabis/widgets/timer_for_exercise.dart';

import '../../../services/exercise_api.dart';

class Smiley extends StatefulWidget {
  const Smiley({Key? key}) : super(key: key);

  @override
  State<Smiley> createState() => _SmileyState();
}

class _SmileyState extends State<Smiley> {
  bool isStarted = false;
  String time = '';
  late int points;
  final controller = ConfettiController();

  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    points = 0;
    
    controller.addListener(() {
      setState(() {
        isRunning = controller.state == ConfettiControllerState.playing;

      });
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
    
      Timer.periodic(Duration(seconds: 6), (timer) {
        points++;
      });
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer(int errors, double width) {
    if (mounted) {
      setState(() async {
        isStarted = false;
        timer?.cancel();
        isRunning = false;

        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final minutes = twoDigits(duration.inMinutes.remainder(60));
        final seconds = twoDigits(duration.inSeconds.remainder(60));

        uploadExercise(
            'None', points, '$minutes : $seconds', 'Smiley', "Speech", 1);

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
      });
    }
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
    int score = 0;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TextButton(
        onPressed: () {
          setState(() {
            isStarted = !isStarted;

            if (!isStarted) {
              stopTimer(0, width);
            } else
              startTimer();
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: Container(
              width: width * 0.27,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: isStarted
                    ? secondPrimaryColor.withOpacity(0.7)
                    : secondPrimaryColor,
              ),
              alignment: Alignment.center,
              child: Text(isStarted ? "Stop" : "Start",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Colors.white,
                    fontSize: 17,
                  ))),
        ),
      ),
      appBar: exerciseAppbar('Exercise "Smiley"', context, 'None', points,
          '$minutes : $seconds', 'Speech', 1),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              textHeader(
                width,
                "It's better to use a mirror or selfie camera for this exercise. It is a simple speech therapy exercise that helps improve oral motor skills.",
              ),
              isStarted
                  ? LottieBuilder.asset(
                      'assets/smiley.json',
                      animate: isStarted,
                    )
                  : SizedBox(
                      width: width * 0.88,
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Text(
                            "How to practice smiling:",
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: secondPrimaryColor),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "1.Stand in front of the mirror or camera and smile.\n2.Stretch the corners of your mouth as much as possible.\n3.Hold for 2 seconds.\n4.Then, relax.",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Inter',
                                fontSize: 17),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          !isStarted
                              ? Container(
                                  width: width * 0.88,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.05),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.01),
                                            offset: Offset(3, 3),
                                            spreadRadius: 10,
                                            blurRadius: 5)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.tips_and_updates,
                                          color: Colors.yellow.withOpacity(0.6),
                                          size: 40),
                                      SizedBox(
                                          // width: 30,
                                          child: Text(
                                              "Keep doing this for as long as you can. The mirror provides feedback that is important for tracking progress.",
                                              style: TextStyle(
                                                  color: Colors.grey))),
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
