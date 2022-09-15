import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/exercise_api.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class ExerciseThree extends StatefulWidget {
  const ExerciseThree({Key? key}) : super(key: key);

  @override
  State<ExerciseThree> createState() => _ExerciseThreeState();
}

class _ExerciseThreeState extends State<ExerciseThree> {
  late int points;
  late int pressed;
  final controller = ConfettiController();

  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;

  List<List<bool>> isSelected = [];

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

        uploadExercise('None', points, '$minutes : $seconds',
            'Find a third wheel', "Attention", 1);

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

  final List _questionsData = [
    {
      "images": [
        "assets/hedgehog.png",
        "assets/matryoshka.png",
        "assets/cow.png",
        "assets/wolf.png"
      ],
      "right": 1
    },
    {
      "images": [
        "assets/baby.png",
        "assets/icecream.png",
        "assets/ladybag.png",
        "assets/hedgehog.png"
      ],
      "right": 0
    },
    {
      "images": [
        "assets/cube.png",
        "assets/window.png",
        "assets/ball.png",
        "assets/gift.png"
      ],
      "right": 0
    },
    {
      "images": [
        "assets/bear.png",
        "assets/fox.png",
        "assets/feather.png",
        "assets/pillow.png"
      ],
      "right": 3
    },
  ];

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
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textHeader(width ,
                    'The exercise helps with an attention and a logic, in order to execue an exercise one should be able to identify the exceeding element of a group'),
                // TextButton(
                //     onPressed: () {
                //       startTimer();
                //     },
                //     child: Container(
                //       width: width * 0.25,
                //       height: 40,
                //       decoration: BoxDecoration(
                //         color: isRunning ? deepPurple : primaryColor,
                //         borderRadius: BorderRadius.circular(5),
                //       ),
                //       alignment: Alignment.center,
                //       child: Text(isRunning ? "GO!" : "Start!",
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontFamily: "Ruberoid",
                //               fontSize: 19,
                //               shadows: [
                //                 isRunning
                //                     ? Shadow(
                //                         offset: const Offset(3, 3),
                //                         color: Colors.white.withOpacity(0.3),
                //                         blurRadius: 5)
                //                     : const Shadow(
                //                         offset: Offset(3, 3),
                //                         color: Colors.transparent,
                //                         blurRadius: 5)
                //               ])),
                //     ))
              ],
            ),
          ],
        ),
      );
    }

    Widget main() {
      return SizedBox(
          width: MediaQuery.of(context).orientation == Orientation.landscape
              ? width * 0.5
              : width * 0.5,
          height: MediaQuery.of(context).orientation == Orientation.landscape
              ? height * 0.75
              : height * 0.5,
          child: CarouselSlider(
            options: CarouselOptions(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? height * 0.45
                        : height * 0.75,
                clipBehavior: Clip.antiAlias,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: false),
            items: List.generate(
                _questionsData.length,
                (index) => Container(
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 248, 248, 248),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(3, 4),
                              color: Colors.black.withOpacity(0.17),
                              blurRadius: 5),
                        ]),
                    child: SizedBox(
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemCount: 4,
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  mounted
                                      ? setState(() {
                                          pressed++;
                                          if (isRunning) {
                                            for (int indexBtn = 0;
                                                indexBtn < isSelected.length;
                                                indexBtn++) {
                                              if (indexBtn == i) {
                                                isSelected[index][indexBtn] =
                                                    !isSelected[index]
                                                        [indexBtn];
                                                if (isSelected[index]
                                                    [indexBtn]) {
                                                  if (indexBtn ==
                                                      _questionsData[index]
                                                          ["right"]) {
                                                    getPoint();
                                                  } else
                                                    getError();
                                                }
                                              } else {
                                                isSelected[index][indexBtn] =
                                                    false;
                                              }
                                            }
                                          }
                                        })
                                      : () {};
                                },
                                child: Container(
                                  // width: width * 0.3,
                                  decoration: BoxDecoration(
                                      color: isSelected[index][i]
                                          ? primaryColor.withOpacity(0.6)
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1,
                                          color: isSelected[index][i]
                                              ? Colors.white
                                              : Colors.grey.shade600),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: Image.asset(
                                          "${_questionsData[index]["images"][i]}")),
                                ),
                              ),
                            );
                          }),
                    ))),
          ));
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: exerciseAppbar('Find a Third Wheel', context, 'None', points,
          '$minutes : $seconds', "Attention", 1),
      persistentFooterButtons: [
        Center(
          child: TextButton(
            onPressed: () {
              if (isRunning) {
                controller.play();
                stopTimer(4 - points, width);
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
            const SizedBox(
              height: 18,
            ),
            const SizedBox(
              height: 20,
            ),
            main(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
