import 'dart:ui';

import "package:flutter/material.dart";
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/exercises_chart.dart';

class ProgressMain extends StatefulWidget {
  const ProgressMain({Key? key}) : super(key: key);

  @override
  State<ProgressMain> createState() => _ProgressMainState();
}

class _ProgressMainState extends State<ProgressMain> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    Widget buildSkill(
      String title,
      double value,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter'),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: width * 0.3,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              child: LinearProgressIndicator(
                backgroundColor: secondPrimaryColor.withOpacity(0.5),
                color: secondPrimaryColor,
                value: value,
                minHeight: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      );
    }

    Widget progressGraph() {
      return Container(
        width: width * 0.86,
        height: height * 0.3,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: Offset(2, 2),
                  blurRadius: 7),
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: Offset(-2, -2),
                  blurRadius: 7)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularPercentIndicator(
                radius: 75,
                lineWidth: 16,
                percent: 0.01,
                progressColor: secondPrimaryColor,
                backgroundColor: secondPrimaryColor.withOpacity(0.5),
                circularStrokeCap: CircularStrokeCap.round,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("1%",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            fontSize: 30)),
                    Text("done",
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontFamily: 'Inter',
                            fontSize: 20)),
                  ],
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSkill("Speech", 0.1),
                buildSkill("Cognitive", 0.1),
                buildSkill("Flexibility", 0.1),
                // buildSkill(
                //   "Motorics",
                //   0.1,
                // ),
              ],
            ),
          ],
        ),
      );
    }

    Widget dayDisplay(int days, String title, Color textColor) {
      return Column(
        children: [
          Text(
            "$days days",
            style: TextStyle(
                fontSize: 40, color: textColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            title,
            style:
                TextStyle(fontSize: 12.5, color: Colors.black.withOpacity(0.8)),
          )
        ],
      );
    }

    Widget daysActive() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          dayDisplay(1, "of activity this week", secondPrimaryColor),
          dayDisplay(
              6, "of activity lat week", secondPrimaryColor.withOpacity(0.5)),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: const Text("Progress",
            style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color.fromRGBO(17, 9, 22, 1.0))),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey.shade800,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondPrimaryColor,
        onPressed: () {},
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: secondPrimaryColor,
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          child: Icon(
            Icons.replay,
            size: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            progressGraph(),
            SizedBox(
              height: 30,
            ),
            daysActive(),
            SizedBox(
              height: 30,
            ),
            ExercisesChart(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
