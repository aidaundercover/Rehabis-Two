import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/exercise_collections/collections_main.dart';
import 'package:rehabis/views/exercises/exerciseWidgets.dart';

class ExerciseMain extends StatefulWidget {
  const ExerciseMain({Key? key}) : super(key: key);

  @override
  State<ExerciseMain> createState() => _ExerciseMainState();
}

List tagsList = [
  {
    "title": "Memory",
    "selected": false,
    "one": oneMemory,
    "two": twoMemory,
    "three": threeMemory
  },
  {
    "title": "Speaking",
    "selected": false,
    "one": oneSpeaking,
    "two": twoSpeaking,
    "three": threeSpeaking
  },
  {
    "title": "Arm mobility",
    "selected": false,
    "one": oneArm,
    "two": twoArm,
    "three": threeArm
  },
  {
    "title": "Problem Solving",
    "selected": false,
    "one": oneProblem,
    "two": twoProblem,
    "three": threeProblem
  },
  {
    "title": "Leg Mobility",
    "selected": false,
    "one": oneLeg,
    "two": twoLeg,
    "three": threeLeg
  },
  {
    "title": "Core",
    "selected": false,
    "one": oneCore,
    "two": twoCore,
    "three": threeCore
  },
  {
    "title": "Attention",
    "selected": false,
    "one": oneAttention,
    "two": twoAttention,
    "three": threeAttention
  },
];

List one = [];
List two = [];
List three = [];

class _ExerciseMainState extends State<ExerciseMain> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List tagTitles = [];

    selectedWeakneases.isNotEmpty ? setState(() {
      for (int i = 0; i < selectedWeakneases.length; i++) {
        tagTitles.add(selectedWeakneases[i]);
      }

      for (int i = 0; i < tagTitles.length; i++) {
        if (tagTitles[i] == tagsList[i]["title"]) {
        } else {
          String tempTitle = tagTitles[i];

          var tempElementOne;

          for (int j = 0; j < tagsList.length; j++) {
            if (tagTitles[i] == tagsList[j]["title"]) {
              tempElementOne = tagsList[j];
            }
          }

          tagsList = tagsList
              .where((element) => element["title"] != tempTitle)
              .toList();

          var tempElementTwo = tagsList[i];
          tagsList[i] = tempElementOne;

          tagsList.add(tempElementTwo);
        }
      }

      // for (int r = 0; r < tagTitles.length; r++) {
      //   tagsList[r]["selected"] = true;

      //   one += tagsList[r]["one"];
      //   two += tagsList[r]["two"];
      //   three += tagsList[r]["three"];
      // }
    }) : () {};

    for (int i = 0; i < tagsList.length; i++) {
      tagsList[i]["selected"] = false;
    }
    one = [];
    two = [];
    three = [];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: "Inter",
        fontSize: 19,
        color: Colors.grey.shade500);
    const TextStyle styleSmall = const TextStyle(fontSize: 14, color: Colors.white);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    Widget workouts(List exercises, int level) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 23.0),
            child: Text(
              "Level $level",
              style: titleStyle,
            ),
          ),
          SizedBox(
            height: 14,
          ),
          SizedBox(
            height: 80,
            //might implenet GridView
            child: ListView(
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              children: List.generate(exercises.length, (i) {
                return exerciseWidget(
                    exercises[i]["title"],
                    exercises[i]["skill"],
                    exercises[i]["minutes"],
                    exercises[i]["page"],
                    "",
                    "",
                    isPortrait ? width : width*0.7,
                    isPortrait ? height : height*1.2,
                    context);
              }),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      );
    }

    Widget tags() {
      return Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: 35,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0),
                itemCount: tagsList.length,
                itemBuilder: (BuildContext context, x) => GestureDetector(
                      onTap: () {
                        setState(() {
                          tagsList[x]["selected"] = !tagsList[x]["selected"];

                          if (tagsList[x]["selected"]) {
                            one += tagsList[x]["one"];
                            two += tagsList[x]["two"];
                            three += tagsList[x]["three"];
                          } 

                          if (!tagsList[x]["selected"]) {
                            for (int i = 0;
                                i < tagsList[x]["one"].length;
                                i++) {
                              one.remove(tagsList[x]["one"][i]);
                            }

                            for (int i = 0;
                                i < tagsList[x]["two"].length;
                                i++) {
                              two.remove(tagsList[x]["two"][i]);
                            }

                            for (int i = 0;
                                i < tagsList[x]["three"].length;
                                i++) {
                              three.remove(tagsList[x]["three"][i]);
                            }
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: tagsList[x]["selected"]
                                  ? secondPrimaryColor.withOpacity(0.3)
                                  : backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: tagsList[x]["selected"]
                                  ? Border.all(
                                      width: 2, color: secondPrimaryColor)
                                  : Border.all(
                                      width: 1, color: secondPrimaryColor),
                              boxShadow: [
                                tagsList[x]["selected"]
                                    ? BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        offset: Offset(3, 3),
                                        spreadRadius: 10,
                                        blurRadius: 5)
                                    : BoxShadow(
                                        color: Colors.transparent,
                                        offset: Offset(0, 0),
                                        spreadRadius: 0,
                                        blurRadius: 0)
                              ]),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                tagsList[x]["selected"]
                                    ? Icon(
                                        Icons.check,
                                        color: secondPrimaryColor,
                                        size: 20,
                                      )
                                    : SizedBox(),
                                Text(
                                  tagsList[x]["title"],
                                  style: TextStyle(
                                      color: secondPrimaryColor,
                                      fontWeight: tagsList[x]["selected"]
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
          ),
          SizedBox(height: 30),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        title: Text("All exercises",
            style: TextStyle(
                fontFamily: "Inter", color: Colors.grey, fontSize: 22)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              size: 25,
              color: Colors.grey.shade400,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 25, color: Colors.grey.shade600),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tags(),
            workouts(one, 1),
            workouts(two, 2),
            workouts(three, 3),
            CollectionsMain()
          ],
        ),
      ),
    );
  }
}
