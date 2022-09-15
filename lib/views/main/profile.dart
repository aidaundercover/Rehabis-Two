import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/main.dart';
import 'package:rehabis/views/auth/sign_in.dart';
import 'package:rehabis/views/first_view/fisrt_view.dart';
import 'package:rehabis/views/profile/about.dart';
import 'package:rehabis/views/profile/goals.dart';
import 'package:rehabis/views/profile/settings.dart';
import 'package:rehabis/views/profile/support.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    TextStyle medData = TextStyle(fontFamily: "Inter", fontSize: 14);
    TextStyle titleStyle = TextStyle(
        fontFamily: "Inter", fontSize: 14, color: Colors.grey.shade500);

    List profileCards = [
      {"title": "Goals", "page": Goals()},
      {"title": "Settings", "page": Settings()},
      {"title": "About Rehabis", "page": AboutRehabis()},
      {"title": "Support", "page": Support()},
    ];

    final ref = FirebaseDatabase.instance.ref();

    List<String> titles = ["Gender", "Born", "Height", "Weight", "Diagnosis"];

    Widget appBar() {
      return Container(
        width: width * 0.84,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            MediaQuery.of(context).orientation == Orientation.portrait
                ? SizedBox(
                    height: height * 0.18,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          width: width * 0.82,
                          height: height * 0.13,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height * 0.07),
                          child: Container(
                            width: width * 0.82,
                            height: height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  secondPrimaryColor,
                                  Color.fromARGB(255, 201, 100, 255),
                                  secondPrimaryColor,
                                ])),
                          ),
                        ),
                        Positioned(
                          top: height * 0.04,
                          left: width * 0.32,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: width * 0.1,
                            child: Image.asset(
                              "assets/robot_neutral.png",
                              height: width * 0.18,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(
                    height: height * 0.23,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          width: width * 0.82,
                          height: height * 0.13,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height * 0.05),
                          child: Container(
                            width: width * 0.82,
                            height: height * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  secondPrimaryColor,
                                  Color.fromARGB(255, 201, 100, 255),
                                  secondPrimaryColor,
                                ])),
                          ),
                        ),
                        Positioned(
                          top: height * 0.04,
                          left: width * 0.32,
                          child: avatarPath.isEmpty ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: width * 0.1,
                            child: Image.asset(
                                    "assets/robot_neutral.png",
                                    height: width * 0.18,
                                  )
                          ) : CircleAvatar(
                            backgroundColor: Colors.white,
                                  radius: width * 0.1,
                            backgroundImage: FileImage(
                                    File(avatarPath)
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Text("$nameGlobal",
                style: TextStyle(fontFamily: "Inter", fontSize: 18)),
            SizedBox(
              height: 20,
            ),
            Container(
              width: width * 0.82,
              height: height * 0.23,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        offset: const Offset(0, 3),
                        blurRadius: 5)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Medical Card",
                    style: TextStyle(fontSize: 16, fontFamily: "Inter"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text("Gender", style: titleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text("Born", style: titleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text("Weight", style: titleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text("Hight", style: titleStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text("Diagnosis", style: titleStyle),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              genderGlobal == 'F' ? 'Female' : 'Male',
                              style: medData,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              bornDateGlobal,
                              style: medData,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "$heightGlobal",
                              style: medData,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "$weightGlobal",
                              style: medData,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              strokeTypeGlobal,
                              style: medData,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 235, 255, 1.0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBar(),
            SizedBox(
              width: width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: profileCards.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => profileCards[i]["page"]));
                        },
                        child: Container(
                          width: width * 0.89,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.01),
                                    offset: Offset(3, 3),
                                    blurRadius: 5),
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.01),
                                    offset: Offset(-1, -1),
                                    blurRadius: 5)
                              ]),
                          alignment: Alignment.center,
                          child: Text(
                            profileCards[i]["title"],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 17),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                nameGlobal = "";
                iinGlobal = "";
                genderGlobal = '';
                bornDateGlobal = '';
                strokeTypeGlobal = '';
                weightGlobal = 0;
                heightGlobal = 0;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        FirstView()));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
