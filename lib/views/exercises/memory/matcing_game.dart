import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/database/getData.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';
import 'package:rehabis/models/memory_tile.dart';

import '../../../services/exercise_api.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key}) : super(key: key);

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<MemoryTile> gridViewTiles = [];
  List<MemoryTile> questionPairs = [];
  final confettiController = ConfettiController();

  Duration duration = const Duration();
  Timer? timer;
  bool isRunning = false;

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    confettiController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    confettiController.addListener(() {
      setState(() {
        isRunning
            ? ConfettiControllerState.playing
            : ConfettiControllerState.stopped;
        // points == 800 ? stopTimer(0, width) : () {};
      });

      points == 800 ? stopTimer(0, 1200) : () {};
    });
    reStart();
    points = 0;
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

        uploadExercise(
            'None', points, '$minutes : $seconds', 'Memory Game', "Memory", 1);

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
                        child: ConfettiWidget(
                            confettiController: confettiController))
                  ]),
                ),
              );
            });

        duration = Duration();
      });
    }
  }

  void reStart() {
    myPairs = getPairs();
    myPairs.shuffle();

    startTimer();

    gridViewTiles = myPairs;
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        print("2 seconds done");
        questionPairs = getQuestionPairs();
        gridViewTiles = questionPairs;
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: exerciseAppbar("Matching Game", context, 'None', points,
          '$minutes : $seconds', 'Memory', 3),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textHeader(width * 0.65,
                      "By finding the matching card witihin the least number of interactions, user can test ones memory abilities"),
                  points != 800
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "$points/800",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter'),
                            ),
                            Text(
                              "Points",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Inter'),
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  points = 0;
                                  reStart();
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 200,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Text(
                                  "Replay",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              // SizedBox(child: GridView.count(crossAxisCount: 4)),

              Container(
                height: height * 0.8,
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? width * 0.95
                        : width * 0.34,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    points != 800
                        ? GridView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisSpacing: 0.0,
                                    maxCrossAxisExtent: 100.0),
                            children:
                                List.generate(gridViewTiles.length, (index) {
                              return Tile(
                                imagePathUrl:
                                    gridViewTiles[index].getImageAssetPath(),
                                tileIndex: index,
                                parent: this,
                              );
                            }),
                          )
                        : Container()
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

class Tile extends StatefulWidget {
  String? imagePathUrl;
  int? tileIndex;
  _MatchingGameState? parent;

  Tile({Key? key, this.imagePathUrl, this.tileIndex, this.parent})
      : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          setState(() {
            myPairs[widget.tileIndex!].setIsSelected(true);
          });
          if (selectedTile != "") {
            /// testing if the selected tiles are same
            if (selectedTile ==
                myPairs[widget.tileIndex!].getImageAssetPath()) {
              print("add point");
              points = points + 100;
              print(selectedTile + " thishis" + widget.imagePathUrl!);

              MemoryTile tileModel = MemoryTile();
              print(widget.tileIndex);
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                tileModel.setImageAssetPath("");
                myPairs[widget.tileIndex!] = tileModel;
                print(selectedIndex);
                myPairs[selectedIndex] = tileModel;
                widget.parent!.setState(() {});
                setState(() {
                  selected = false;
                });
                selectedTile = "";
              });
            } else {
              print(selectedTile +
                  " thishis " +
                  myPairs[widget.tileIndex!].getImageAssetPath());
              print("wrong choice");
              print(widget.tileIndex);
              print(selectedIndex);
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                widget.parent!.setState(() {
                  myPairs[widget.tileIndex!].setIsSelected(false);
                  myPairs[selectedIndex].setIsSelected(false);
                });
                setState(() {
                  selected = false;
                });
              });

              selectedTile = "";
            }
          } else {
            setState(() {
              selectedTile = myPairs[widget.tileIndex!].getImageAssetPath();
              selectedIndex = widget.tileIndex!;
            });

            print(selectedTile);
            print(selectedIndex);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: myPairs[widget.tileIndex!].getImageAssetPath() != ""
            ? Image.asset(myPairs[widget.tileIndex!].getIsSelected()
                ? myPairs[widget.tileIndex!].getImageAssetPath()
                : widget.imagePathUrl!)
            : Container(
                color: Colors.white,
                child: Image.asset("assets/correct.png"),
              ),
      ),
    );
  }
}

// class MatchingGame extends StatefulWidget {
//   const MatchingGame({Key? key}) : super(key: key);

//   @override
//   State<MatchingGame> createState() => _MatchingGameState();
// }


// Duration duration = Duration();
// Timer? timer;
// var confettiController = ConfettiController();

// class _MatchingGameState extends State<MatchingGame> {
//   String title = "Matching Game";
//   List<MemoryTile> gridViewTiles = [];
//   List<MemoryTile> questionPairs = [];

  

//   void addTime() {
//     const addSeconds = 1;

//     setState(() {
//       final seconds = duration.inSeconds + addSeconds;

//       duration = Duration(seconds: seconds);
//     });
//   }

//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
//   }

//   void reStart() {
//     myPairs = getPairs();
//     myPairs.shuffle();

//     startTimer();

//     gridViewTiles = myPairs;
//     Future.delayed(const Duration(seconds: 5), () {
//       setState(() {
//         questionPairs = getQuestionPairs();
//         gridViewTiles = questionPairs;
//         selected = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar:
//           exerciseAppbar(title, context, 'None', points, "time", 'Memory', 3),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   textHeader(width * 0.65,
//                       "By finding the matching card witihin the least number of interactions, user can test ones memory abilities"),
//                   points != 800
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               "$points/800",
//                               style: const TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: 'Inter'),
//                             ),
//                             const Text(
//                               "Points",
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w300,
//                                   fontFamily: 'Inter'),
//                             ),
//                           ],
//                         )
//                       : Container(),
//                 ],
//               ),
//               // SizedBox(child: GridView.count(crossAxisCount: 4)),

//               //     !isStarted
//               // ? TextButton(
//               //     onPressed: () {
//               //       reStart();
//               //     },
//               //     child: Container(
//               //         width: width * 0.33,
//               //         height: 70,
//               //         alignment: Alignment.center,
//               //         decoration: BoxDecoration(
//               //             color: primaryColor,
//               //             borderRadius: BorderRadius.circular(23),
//               //             boxShadow: [const BoxShadow()]),
//               //         child: const Text('Start!',
//               //             style: TextStyle(
//               //                 color: Colors.white,
//               //                 fontFamily: "Inter",
//               //                 fontSize: 24)))) :
//               Container(
//                 height: height * 0.8,
//                 width: width * 0.95,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//                 child: Column(
//                   children: <Widget>[
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     points != 800
//                         ? SizedBox(
//                             width: MediaQuery.of(context).orientation ==
//                                     Orientation.portrait
//                                 ? width * 0.9
//                                 : width * 0.3,
//                             child: GridView(
//                               shrinkWrap: true,
//                               //physics: ClampingScrollPhysics(),
//                               scrollDirection: Axis.vertical,
//                               gridDelegate:
//                                   const SliverGridDelegateWithMaxCrossAxisExtent(
//                                       mainAxisSpacing: 0.0,
//                                       maxCrossAxisExtent: 100),
//                               children:
//                                   List.generate(gridViewTiles.length, (index) {
//                                 return Tile(
//                                   imagePathUrl:
//                                       gridViewTiles[index].getImageAssetPath(),
//                                   tileIndex: index,
//                                   parent: this,
//                                   restart: () => reStart(),
//                                 );
//                               }),
//                             ),
//                           )
//                         : Container()
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Tile extends StatefulWidget {
//   String? imagePathUrl;
//   int? tileIndex;
//   void Function() restart;
//   _MatchingGameState? parent;

//   Tile(
//       {Key? key,
//       this.imagePathUrl,
//       this.tileIndex,
//       this.parent,
//       required this.restart})
//       : super(key: key);

//   @override
//   _TileState createState() => _TileState();
// }

// class _TileState extends State<Tile> {
//   void stopTimer(double width) {
//     setState(() async {
//       timer?.cancel();

//       String twoDigits(int n) => n.toString().padLeft(2, '0');
//       minutes = twoDigits(duration.inMinutes.remainder(60));
//       seconds = twoDigits(duration.inSeconds.remainder(60));

//       showDialog(
//           context: (context),
//           builder: (_) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               child: Container(
//                 width: width * 0.7,
//                 height: 200,
//                 padding: EdgeInsets.all(30),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(width: 4, color: Colors.purple)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ConfettiWidget(confettiController: confettiController),
//                     Center(
//                         child: Text("Well done!",
//                             style: TextStyle(
//                                 color: deepPurple,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Intel"))),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 13.0),
//                       child: Row(
//                         children: [
//                           Text("Execution time:",
//                               style: TextStyle(
//                                 color: deepPurple,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               )),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Text("$minutes: $seconds",
//                               style: TextStyle(
//                                 color: deepPurple,
//                                 fontSize: 15,
//                               ))
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           child: Container(
//                             width: 100,
//                             height: 35,
//                             child: Text("Restart",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: Colors.white)),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(7),
//                                 color: Colors.purple.shade200),
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             // isStarted = true;
//                             widget.restart;
//                           },
//                         ),
//                         const SizedBox(width: 7),
//                         TextButton(
//                           child: Container(
//                             width: 100,
//                             height: 35,
//                             child: const Text("Exit",
//                                 style: TextStyle(color: Colors.white)),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(7),
//                                 color: Colors.purple.shade200),
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             Navigator.of(context).pop();
//                           },
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           });
//       duration = Duration();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () {
//         if (!selected) {
//           setState(() {
//             myPairs[widget.tileIndex!].setIsSelected(true);
//           });
//           if (selectedTile != "") {
//             /// testing if the selected tiles are same
//             if (selectedTile ==
//                 myPairs[widget.tileIndex!].getImageAssetPath()) {
//               print("add point");
//               points = points + 100;
//               if (points == 900) {
//                 // setState(() {
//                 //   isStarted = false;
//                 // });
//                 stopTimer(width);

//                 // ExerciseApi.uploadExercise(
//                 //     'None', points, "$minutes : $seconds", 'Matching game', 'Memory', 3);
//               }

//               print(selectedTile + " thishis" + widget.imagePathUrl!);

//               MemoryTile tileModel = MemoryTile();
//               print(widget.tileIndex);
//               selected = true;
//               Future.delayed(const Duration(seconds: 1), () {
//                 tileModel.setImageAssetPath("");
//                 myPairs[widget.tileIndex!] = tileModel;
//                 print(selectedIndex);
//                 myPairs[selectedIndex] = tileModel;
//                 widget.parent!.setState(() {});
//                 setState(() {
//                   selected = false;
//                 });
//                 selectedTile = "";
//               });
//             } else {
//               print(selectedTile +
//                   " thishis " +
//                   myPairs[widget.tileIndex!].getImageAssetPath());
//               print("wrong choice");
//               print(widget.tileIndex);
//               print(selectedIndex);
//               selected = true;
//               Future.delayed(const Duration(seconds: 2), () {
//                 widget.parent!.setState(() {
//                   myPairs[widget.tileIndex!].setIsSelected(false);
//                   myPairs[selectedIndex].setIsSelected(false);
//                 });
//                 setState(() {
//                   selected = false;
//                 });
//               });

//               selectedTile = "";
//             }
//           } else {
//             setState(() {
//               selectedTile = myPairs[widget.tileIndex!].getImageAssetPath();
//               selectedIndex = widget.tileIndex!;
//             });

//             print(selectedTile);
//             print(selectedIndex);
//           }
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.all(5),
//         child: myPairs[widget.tileIndex!].getImageAssetPath() != ""
//             ? Image.asset(myPairs[widget.tileIndex!].getIsSelected()
//                 ? myPairs[widget.tileIndex!].getImageAssetPath()
//                 : widget.imagePathUrl!)
//             : Container(
//                 color: Colors.white,
//                 child: Image.asset("assets/correct.png"),
//               ),
//       ),
//     );
//   }
// }
