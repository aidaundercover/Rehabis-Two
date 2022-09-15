import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rehabis/globalVars.dart';

class TestForPrediction extends StatefulWidget {
  const TestForPrediction({Key? key}) : super(key: key);

  @override
  State<TestForPrediction> createState() => _TestForPredictionState();
}

TextEditingController bp = TextEditingController(text: "");
String isSmoker = 'unknown';
TextEditingController cholesterol = TextEditingController(text: "");
bool isDiabetes = false;
TextEditingController bmi = TextEditingController(
    text: heightGlobal == 0
        ? "${weightGlobal / heightGlobal / heightGlobal}"
        : "");

late FixedExtentScrollController controller;
int selectedAge = bornDateGlobal.isEmpty
    ? 50
    : DateTime.now().year -
        int.parse(bornDateGlobal[0]+bornDateGlobal[1])>25 ? int.parse("19" +bornDateGlobal[0]+bornDateGlobal[1]) : int.parse("20" +bornDateGlobal[0]+bornDateGlobal[1]);

//buttons//
bool isMPressed = false;
bool isFPressed = false;
bool isSYPressed = false;
bool isSNPressed = false;
bool isSFPressed = false;
bool isSmokerPressed = false;
bool diabetesHas = false;
bool diabetesHasNot = false;

//prediction vars//
String bloodPressure = "";
String fat = "";
String smokingStatus = "";
String cholesterolStatus = "";

List<bool> diabetesList = [false, false];
List<int> ageList = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
  32,
  33,
  34,
  35,
  36,
  37,
  38,
  39,
  40,
  41,
  42,
  43,
  44,
  45,
  46,
  47,
  48,
  49,
  50,
  51,
  52,
  53,
  54,
  55,
  56,
  57,
  58,
  59,
  60,
  61,
  62,
  63,
  64,
  65,
  66,
  67,
  68,
  69,
  70,
  71,
  72,
  73,
  74,
  75,
  76,
  77,
  78,
  79,
  80,
  81,
  82,
  83,
  84,
  85,
  86,
  87,
  88,
  89,
  90,
  91,
  92,
  93,
  94,
  95,
  96,
  97,
  98,
  99,
  100
];

class _TestForPredictionState extends State<TestForPrediction> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = FixedExtentScrollController(initialItem: selectedAge);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    var titleStyle = const TextStyle(
        fontSize: 16,
        fontFamily: "Inter",
        color: Color.fromARGB(255, 119, 119, 119));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 75,
        title: const Text("Predict propensity\nfor Cardiovascular diseases",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontFamily: "Inter", fontSize: 21)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined,
                size: 32, color: Colors.black),
            onPressed: () {
              selectedAge = 50;
              bp = TextEditingController(text: "");
              isSmoker = 'unknown';
              cholesterol = TextEditingController(text: "");
              isDiabetes = false;
              bmi = TextEditingController(
                  text: heightGlobal == 0
                      ? "${weightGlobal / heightGlobal / heightGlobal}"
                      : "");
              isMPressed = false;
              isFPressed = false;
              isSYPressed = false;
              isSNPressed = false;
              isSFPressed = false;
              isSmokerPressed = false;
              diabetesHas = false;
              diabetesHasNot = false;
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: SizedBox(
          width: width * 0.86,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Fill in as much information as possible, in order to result to be precise",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gender", style: titleStyle),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    genderGlobal = 'male';
                                    isMPressed = !isMPressed;

                                    if (isMPressed == true) {
                                      isFPressed = false;
                                    }
                                  });
                                },
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      isMPressed
                                          ? Image.asset("assets/male.png")
                                          : Image.asset("assets/male_grey.png"),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Male",
                                        style: TextStyle(
                                            fontWeight: isMPressed
                                                ? FontWeight.bold
                                                : FontWeight.w400,
                                            fontFamily: "Intel",
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    genderGlobal = 'female';
                                    isFPressed = !isFPressed;

                                    if (isFPressed == true) {
                                      isMPressed = false;
                                    }
                                  });
                                },
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      isFPressed
                                          ? Image.asset("assets/female.png")
                                          : Image.asset(
                                              "assets/female_grey.png"),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Female",
                                        style: TextStyle(
                                            fontWeight: isFPressed
                                                ? FontWeight.bold
                                                : FontWeight.w400,
                                            fontFamily: "Intel",
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                ),

                Text("Age", style: titleStyle),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  width: width * 0.84,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: ListWheelScrollView(
                        scrollBehavior: ScrollBehavior(),
                        itemExtent: 40,
                        diameterRatio: 3,
                        controller: controller,
                        perspective: 0.008,
                        squeeze: 0.95,
                        onSelectedItemChanged: (x) {
                          setState(() {
                            selectedAge = x;
                          });
                        },
                        physics: ScrollPhysics(),
                        children: List.generate(
                            ageList.length,
                            (index) => RotatedBox(
                                  quarterTurns: 1,
                                  child: Container(
                                    width: index == selectedAge ? 40 : 30,
                                    height: index == selectedAge ? 40 : 30,
                                    decoration: BoxDecoration(
                                        color: index == selectedAge
                                            ? secondPrimaryColor
                                            : Colors.transparent,
                                        shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${ageList[index]}",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize:
                                              index == selectedAge ? 22 : 20,
                                          color: index == selectedAge
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ))),
                  ),
                ),

                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   controller: age,
                //   validator: (value) {
                //     try {
                //       int.parse(age.text);
                //     } catch (e) {
                //       Fluttertoast.showToast(
                //           msg: "Age should be written in numbers");
                //       age = TextEditingController(text: "");
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     filled: true,
                //     fillColor: Color.fromARGB(255, 226, 225, 225),
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide.none,
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //     ),
                //     hintText: 'e.g. 37',
                //     hintStyle: TextStyle(
                //         fontFamily: 'Inter',
                //         fontSize: 14,
                //         color: Color.fromARGB(255, 67, 67, 67)),
                //   ),
                // ),
                const SizedBox(
                  height: 18,
                ),
                Text("Arterial pressure", style: titleStyle),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: bp,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    try {
                      double.parse(bp.text);
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "Pressure has to b written down numerically");
                      selectedAge = 50;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    hintText: 'f.e. 3.5 ммol/l',
                    hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text("Smoking status", style: titleStyle),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isSmoker = 'yes';
                            isSYPressed = !isSYPressed;

                            if (isSYPressed) {
                              isSNPressed = false;
                              isSFPressed = false;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSYPressed
                                  ? primaryColor
                                  : Color.fromARGB(255, 174, 156, 175)),
                          width: width * 0.28,
                          height: 80,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Yes",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: "Intel",
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isSmoker = 'no';
                            isSNPressed = !isSNPressed;

                            if (isSNPressed) {
                              isSYPressed = false;
                              isSFPressed = false;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSNPressed
                                  ? primaryColor
                                  : Color.fromARGB(255, 174, 156, 175)),
                          width: width * 0.28,
                          height: 80,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: "Intel",
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isSmoker = 'former';
                            isSFPressed = !isSFPressed;

                            if (isSFPressed) {
                              isSYPressed = false;
                              isSNPressed = false;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSFPressed
                                  ? primaryColor
                                  : Color.fromARGB(255, 174, 156, 175)),
                          width: width * 0.28,
                          height: 80,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Former",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: "Intel",
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Text("Cholesterol level", style: titleStyle),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: cholesterol,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    hintText: 'e.g. 120 mm h.t.',
                    hintStyle: TextStyle(fontFamily: 'Arial', fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text("Diagnosed diabetes", style: titleStyle),
                const SizedBox(
                  height: 10,
                ),
                ToggleButtons(
                    isSelected: diabetesList,
                    renderBorder: false,
                    onPressed: (i) {
                      setState(() {
                        if (i == 0) {
                          diabetesList[0] = !diabetesList[0];
                          diabetesList[1] = false;
                        }

                        if (i == 1) {
                          diabetesList[1] = !diabetesList[1];
                          diabetesList[0] = false;
                        }
                      });
                    },
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: diabetesList[0]
                                ? Border.all(
                                    width: 3, color: secondPrimaryColor)
                                : Border.all(width: 0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.002),
                                  offset: Offset(3, 3),
                                  blurRadius: 7,
                                  spreadRadius: 10),
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.002),
                                  offset: Offset(-3, -3),
                                  blurRadius: 7,
                                  spreadRadius: 10)
                            ],
                            color: backgroundColor),
                        width: width * 0.42,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Да",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Intel",
                              fontSize: 18,
                              color: diabetesList[0]
                                  ? primaryColor
                                  : primaryColor.withOpacity(0.4),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: diabetesList[1]
                                ? Border.all(
                                    width: 3, color: secondPrimaryColor)
                                : Border.all(width: 0),
                            color: backgroundColor),
                        width: width * 0.42,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Нет",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Intel",
                              fontSize: 18,
                              color: diabetesList[1]
                                  ? primaryColor
                                  : primaryColor.withOpacity(0.4),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ]),

                const SizedBox(
                  height: 18,
                ),
                heightGlobal == 0 && weightGlobal == 0
                    ? Row(
                        children: [
                          Text("BMI", style: titleStyle),
                          SizedBox(
                            width: 6,
                          ),
                          Tooltip(
                            child: Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueGrey.shade100),
                                child: Icon(Icons.question_mark,
                                    color: Colors.blueGrey.shade400, size: 17)),
                            message:
                                "Body mass index - is a measure of body fat based",
                          )
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                heightGlobal == 0 && weightGlobal == 0
                    ? TextFormField(
                        controller: bmi,
                        onSaved: (text) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                          hintText: 'For instance: 25.3',
                          hintStyle:
                              TextStyle(fontFamily: 'Arial', fontSize: 14),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("You can calculate your BMI ",
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    GestureDetector(
                      onTap: () {},
                      child: Text("here",
                          style: TextStyle(
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          predict(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 191, 43, 255),
                borderRadius: BorderRadius.circular(17)),
            width: width * 0.45,
            height: 42,
            alignment: Alignment.center,
            child: const Text(
              "PREDICT",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Inter'),
            ),
          ),
        ),
      ),
    );
  }

  Widget smokerWidget(String title, String info, double width) {
    return GestureDetector(
        onTap: () {
          setState(() {
            if (info == "no") {
              isSmoker = 'no';
              isSNPressed = !isSNPressed;

              isSmokerPressed = isSNPressed;

              if (isSmokerPressed) {
                isSYPressed = false;
                isSFPressed = false;
              }
            } else if (info == "yes") {
              isSmoker = 'yes';
              isSYPressed = !isSYPressed;

              isSmokerPressed = isSYPressed;

              if (isSYPressed) {
                isSNPressed = false;
                isSFPressed = false;
              }
            } else if (info == "former") {
              isSmoker = 'former';
              isSFPressed = !isSFPressed;

              isSmokerPressed = isSFPressed;

              if (isSFPressed) {
                isSNPressed = false;
                isSYPressed = false;
              }
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: isSmokerPressed
                  ? primaryColor
                  : Color.fromARGB(255, 186, 128, 190)),
          width: width * 0.28,
          height: 80,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: "Intel",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }

  Widget diabetesWidget(String title, bool info, double width) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isDiabetes = info;
          });
        },
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 228, 226, 97)),
          width: width * 0.42,
          height: 70,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: "Intel",
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }
}

Future predict(BuildContext context) async {
  if (genderGlobal == "none") {
    Fluttertoast.showToast(msg: "Gender wasn't chosen!");
  } else if (bp.text.isEmpty) {
    Fluttertoast.showToast(msg: "Arterial BP wasn't folled in!");
  } else if (isSmoker == "unknown") {
    Fluttertoast.showToast(msg: "Smoking status wasn't filled in!");
  } else if (cholesterol.text.isEmpty) {
    Fluttertoast.showToast(msg: "Cholesterol level wasn't filled in!");
  } else if (bmi.text.isEmpty) {
    Fluttertoast.showToast(msg: "BMI was not filled in");
  } else {
    if (double.parse(bp.text) < 130 && double.parse(bp.text) > 110) {
      bloodPressure = "The level of arterial blood pressure is normal.";
    } else if (double.parse(bp.text) < 110) {
      bloodPressure =
          "The level of arterial blood pressure is low, it's the sign of the hypotension. Hypotension is accompanied by weakness, dizziness, palpitations, shortness of breath, loss of consciousness and other symptoms.";
    } else if (double.parse(bp.text) < 145 &&
        double.parse(bp.text) > 110 &&
        genderGlobal == "female" &&
        selectedAge > 50) {
      bloodPressure = "The level of arterial blood pressure is normal.";
    } else if (double.parse(bp.text) > 130) {
      bloodPressure =
          "High blood pressure is a sign of hypotension. The brain inevitably suffers from hypertension. Deterioration of memory, attention, absent-mindedness - including the consequences of neglected hypertension. The heart also suffers, its rhythm is disturbed, shortness of breath appears. But there is a risk of much more serious consequences: a stroke or a heart attack.";
    }

    if (isSmoker == "yes") {
      smokingStatus =
          "With prolonged and frequent smoking, there is a risk of heart failure. Nicotine causes an increase in blood pressure and heart rate, and carbon monoxide causes heart failure. Cardiac spasm is the most common complication of smoking. The result of such a spasm may be myocardial infarction - necrosis of a section of the heart muscle due to a violation of its nutrition.";
    } else if (isSmoker == "former") {
      smokingStatus =
          "Quitting smoking was a helpful decision. With prolonged and frequent smoking, there is a risk of heart failure";
    }

    if (double.parse(cholesterol.text) < 5.1 &&
        double.parse(cholesterol.text) > 3.2) {
      cholesterolStatus = "The cholesterol level is normal.";
    } else if (double.parse(cholesterol.text) > 5.1) {
      cholesterolStatus =
          "The cholesterol level is high. There is a risk of formation of atherosclerotic plaques on the walls of blood vessels";
    } else if (double.parse(cholesterol.text) < 3.2) {
      cholesterolStatus =
          "The cholesterol level is low. There is a risk of hypocholesterolemia";
    }

    if (genderGlobal == "male") {
    } else if (genderGlobal == "female") {}

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 450,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.black.withOpacity(0.3))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Medical conclusion:",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: primaryColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Text(
                      '$bloodPressure\n$smokingStatus\n$cholesterolStatus',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectedAge = 50;
                          bp = TextEditingController(text: "");
                          isSmoker = 'unknown';
                          cholesterol = TextEditingController(text: "");
                          isDiabetes = false;
                          bmi = TextEditingController(
                              text: heightGlobal == 0
                                  ? "${weightGlobal / heightGlobal / heightGlobal}"
                                  : "");
                          isMPressed = false;
                          isFPressed = false;
                          isSYPressed = false;
                          isSNPressed = false;
                          isSFPressed = false;
                          isSmokerPressed = false;
                          diabetesHas = false;
                          diabetesHasNot = false;
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.2)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text('OK,thanks',
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
