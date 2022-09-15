import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class TimerForExercise extends StatefulWidget {
  TimerForExercise(
      {Key? key, required this.onListening, required this.onChanged})
      : super(key: key);
  bool onListening;
  final ValueChanged<String> onChanged;

  @override
  State<TimerForExercise> createState() => _TimerForExerciseState();
}

class _TimerForExerciseState extends State<TimerForExercise> {
  Duration duration = Duration();
  Timer? timer;
  bool isStarted = false;

  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    setState(() {
      widget.onListening = true;
      // widget.onListening(isStarted);
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer(int errors) {
    setState(() async {
      timer?.cancel();
      widget.onListening = false;
      // widget.onListening(isStarted);

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));

      widget.onChanged("$minutes : $seconds");

      // uploadExercise()

      showDialog(
          context: (context),
          builder: (_) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 210,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 4, color: Colors.purple)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text("Well Done!",
                            style: TextStyle(
                                color: deepPurple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter"))),
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Row(
                        children: [
                          Text("Execution Time:",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Container(
                            width: 100,
                            height: 35,
                            child: Text("Restart",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.purple.shade200),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            isStarted = true;
                            startTimer();
                          },
                        ),
                        const SizedBox(width: 7),
                        TextButton(
                          child: Container(
                            width: 100,
                            height: 35,
                            child: const Text("Finish",
                                style: TextStyle(color: Colors.white)),
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
              ),
            );
          });
      duration = Duration();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.onListening) {
      startTimer();
    }
    else {}
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    var width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.3,
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          buildTimeCard(minutes.toString(), "Mintutes"),
          const SizedBox(
            width: 7,
          ),
          buildTimeCard(seconds.toString(), "Seconds")
        ],
      ),
    );
  }
}
