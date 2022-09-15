import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/exercise_api.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class Breathing extends StatefulWidget {
  const Breathing({Key? key}) : super(key: key);

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing> {
  bool isInhale = true;
  late int times;
  final controller = ConfettiController();

  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;
  late AudioPlayer player;
  int points = 0;

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

      uploadExercise('None', times, '$minutes : $seconds', 'Breathing Exercise',
          "Attention", 3);

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
      times = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    player = AudioPlayer();

    isRunning ? startVoiceOver() : () {};

    super.initState();
  }

  void addTimes() {
    setState(() {
      Timer.periodic(const Duration(milliseconds: 7500), (timer) {
        times++;
      });
    });
  }

  void startVoiceOver() async {
    await player.setAsset('assets/inhale.mp3');

    player.play();

    Timer.periodic(const Duration(milliseconds: 7500), (timer) {
      setState(() async {
        isInhale = !isInhale;

        if (isInhale) {
          await player.setAsset('assets/inhale.mp3');
          player.play();
        } else {
          await player.setAsset('assets/exhale.mp3');
          player.play();
        }

        times++;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isInhale = true;
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: exerciseAppbar("Breathing exercise", context, 'None', points,
          '$minutes : $seconds', 'Speech', 1),
      body: Column(
        children: [
          textHeader(width,
              'Breathing exercises can help you control and coordinate your breathing while talking. Ideally, a stroke patient can practice breathing exercises at least twice a day.'),
          SizedBox(height: 50),
          Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset("assets/breathe.json", animate: isRunning),
              Text(
                isInhale ? "Inhale" : "Exhale",
                style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          !isRunning
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      isRunning = true;
                      // startVoiceOver();
                    });
                  },
                  child: Container(
                    width: width * 0.4,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: secondPrimaryColor.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(4, 4),
                              color: secondPrimaryColor.withOpacity(0.01)),
                          BoxShadow(
                              offset: Offset(-4, -4),
                              color: secondPrimaryColor.withOpacity(0.01))
                        ]),
                    alignment: Alignment.center,
                    child: Text(
                      "Start",
                      style: TextStyle(
                          color: secondPrimaryColor.withOpacity(0.8),
                          fontFamily: 'Inter',
                          fontSize: 16),
                    ),
                  ))
              : Container(
                  width: width * 0.88,
                  height: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: secondPrimaryColor.withOpacity(0.14),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(4, 4),
                            color: secondPrimaryColor.withOpacity(0.01)),
                        BoxShadow(
                            offset: Offset(-4, -4),
                            color: secondPrimaryColor.withOpacity(0.01))
                      ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.tips_and_updates,
                            color: secondPrimaryColor.withOpacity(0.4),
                            size: width * 0.1),
                        SizedBox(
                            width: width * 0.75,
                            child: Text(
                                "Practice this exercise at least 10 -times in the morning and evening. Breathing exercises will strengthen your diaphragm.",
                                style: TextStyle(color: Colors.black38)))
                      ]),
                )
        ],
      ),
    );
  }
}
