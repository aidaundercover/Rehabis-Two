import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/models/Training.dart';
import 'package:rehabis/views/exercises/hands/hands.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';
import 'package:rehabis/views/main/progress.dart';
import 'package:rehabis/widgets/audio_player.dart';
import 'package:rehabis/views/exercises/exercises_main.dart';
import 'package:rehabis/views/exercises/attention/find_third_whhel.dart';
import 'package:rehabis/views/exercises/attention/similiar_words.dart';
import 'package:rehabis/views/exercises/attention/findiandh.dart';
import 'package:rehabis/views/prediction/test_for_prediction.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Training> lastExercises = [
    Training(
        instruction:
            "Нажмите на каждый символ в порядке слева направо, сверху вниз",
        level: 1,
        img: 'assets/arrow_sky.png',
        skill: "Motorics",
        title: "Same symbols",
        minutes: 3,
        page: ExercizeOne()),
    Training(
        instruction:
            "Прослушайте текст и выберете изображение которое отобржает сказанное",
        level: 2,
        img: "assets/sound.png",
        skill: "Speech",
        title: "Similiar sounds",
        minutes: 1,
        page: ExerciseTwo()),
    Training(
        instruction: "Найдите лишнее среди 4-х изображений",
        level: 3,
        img: "assets/redundant.png",
        skill: "Problem Solving",
        title: "What's execess",
        minutes: 2,
        page: ExerciseThree()),
  ];

  List listRecomends = [
    {
      "title": "Follow the progress",
      "desc": "Follow the progress of the recovery and stay motivated",
      "img": "assets/rec_progress.png",
      "page": ProgressMain()
    },
    {
      "title": "Start your recovery with us",
      "desc": "We have developed exercises for self-recovery",
      "img": "assets/rec_exercise.png",
      "page": ExerciseMain()
    },
    {
      "title": "Cardiavascular disease risk test",
      "desc": "Find out the probability of occurance of cardiovascular disease",
      "img": "assets/rec_test.png",
      "page": TestForPrediction()
    }
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    double percentage = value * 100;

    Widget appBar() {
      return Column(
        children: [
          AppBar(
            title: const Text("Rehabis",
                style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromRGBO(17, 9, 22, 1.0))),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          Container(
              width: width * 0.88,
              // height: height * 0.45,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          width: width * 0.7,
                          height: height > 1000 ? height * 0.24 : height * 0.35,
                          decoration: BoxDecoration(
                              color: secondPrimaryColor,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        Image.asset(
                          "assets/robot_neutral.png",
                          width: width > 850
                              ? width * 0.22
                              : width > 799
                                  ? width * 0.4
                                  : width * 0.5,
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? width * 0.7
                              : width * 0.45,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              border: Border.all(
                                  width: 1.5,
                                  color: Color.fromRGBO(245, 240, 247, 1.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    offset: Offset(4, 4),
                                    blurRadius: 10)
                              ]),
                          alignment: Alignment.center,
                          child: Text(
                            "Welcome back, $nameGlobal!",
                            style: TextStyle(
                                fontFamily: "Inter",
                                color: Color.fromRGBO(34, 34, 34, 1.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: width * 0.7,
                      height: 4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 246, 246, 246).withOpacity(0.5),
                        Color.fromARGB(255, 231, 231, 231),
                        Color.fromARGB(255, 246, 246, 246).withOpacity(0.5),
                      ])),
                    )
                  ])),
        ],
      );
    }

    Widget exercises() {
      return SizedBox(
        width: width * 0.88,
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Trainings",
            style: TextStyle(
                color: Color.fromARGB(255, 202, 189, 209),
                fontSize: 20,
                fontFamily: 'Inter'),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref('Users/$iinGlobal/Trainings/')
                  .limitToLast(3)
                  .onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    var trainings = Map<String, dynamic>.from(
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>);

                    // return SizedBox(
                    //   height: 120,
                    //   child: ListView.builder(
                    //     itemCount: lastExercises.length,
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (BuildContext context, index) {
                    //       return Padding(
                    //         padding: const EdgeInsets.only(left: 10.0),
                    //         child: exerciseWidgetMain(
                    //             trainings[index]['type'],
                    //             trainings[index]['level'],
                    //             trainings[index].skill,
                    //             trainings[index].minutes,
                    //             trainings[index].page,
                    //             trainings[index].instruction,
                    //             trainings[index].img,
                    //             width,
                    //             height,
                    //             context),
                    //       );
                    //     },
                    //   ),
                    // );

                    return SizedBox(
                      height: 120,
                      child: ListView.builder(
                        itemCount: lastExercises.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: exerciseWidgetMain(
                                lastExercises[index].title,
                                lastExercises[index].level,
                                lastExercises[index].skill,
                                lastExercises[index].minutes,
                                lastExercises[index].page,
                                lastExercises[index].instruction,
                                lastExercises[index].img,
                                width,
                                height,
                                context),
                          );
                        },
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 120,
                      child: ListView.builder(
                        itemCount: lastExercises.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: exerciseWidgetMain(
                                lastExercises[index].title,
                                lastExercises[index].level,
                                lastExercises[index].skill,
                                lastExercises[index].minutes,
                                lastExercises[index].page,
                                lastExercises[index].instruction,
                                lastExercises[index].img,
                                width,
                                height,
                                context),
                          );
                        },
                      ),
                    );
                  }
                } else
                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: lastExercises.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: exerciseWidgetMain(
                              lastExercises[index].title,
                              lastExercises[index].level,
                              lastExercises[index].skill,
                              lastExercises[index].minutes,
                              lastExercises[index].page,
                              lastExercises[index].instruction,
                              lastExercises[index].img,
                              width,
                              height,
                              context),
                        );
                      },
                    ),
                  );
              }),
        ]),
      );
    }

    Widget tile(String title, String desc, String img, Widget page) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        },
        child: Container(
          width: width * 0.84,
          height: 135,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(3, 3),
                    blurRadius: 5),
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(-3, -3),
                    blurRadius: 5)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.45,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        desc,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontFamily: "Inter",
                            fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
              Image.asset(img, height: 100)
            ],
          ),
        ),
      );
    }

    Widget recomendations() {
      return SizedBox(
          width: width * 0.84,
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Recomendations",
              style: TextStyle(
                  color: Color.fromARGB(255, 202, 189, 209),
                  fontSize: 20,
                  fontFamily: 'Inter'),
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listRecomends.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => tile(
                  listRecomends[index]["title"],
                  listRecomends[index]["desc"],
                  listRecomends[index]["img"],
                  listRecomends[index]["page"]),
            ),
            SizedBox(
              height: 60,
            )
          ]));
    }

    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref('User/$iinGlobal/Name').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: const Color.fromRGBO(248, 235, 255, 1.0),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [appBar(), exercises(), recomendations()],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator(color: primaryColor, ));
          }
        });
  }
}

// {
//   "instruction":"Нажмите на каждый символ в порядке слева направо, сверху вниз",
//     "level": 1,
//     "img": 'assets/arrow_sky.png',
//     "skill": "Motorics",
//     "title": "Same symbols",
//     "minutes": 3,
//     "page": ExercizeOne()
// },
// {
//   "instruction":
//         "Прослушайте текст и выберете изображение которое отобржает сказанное",
//     "level": 2,
//     "img": "assets/sound.png",
//     "skill": "Speech",
//     "title": "Similiar sounds",
//     "minutes": 1,
//     "page": ExerciseTwo()
// },
// {
//   "instruction": "Найдите лишнее среди 4-х изображений",
//       "level": 3,
//       "img": "assets/redundant.png",
//       "skill": "Problem Solving",
//       "title": "What's execess",
//       "minutes": 2,
//       "page": ExerciseThree()
// }
