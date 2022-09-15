import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/first_view/set_up_voice.dart';
import 'package:rehabis/views/main/home.dart';
import 'package:rehabis/widgets/slider_fv.dart';

class AddDataView extends StatefulWidget {
  const AddDataView({Key? key}) : super(key: key);

  @override
  State<AddDataView> createState() => _AddDataViewState();
}

List<bool> isSelected = [false, false];
List<bool> isSelectedActivity = [false, false, false];

List<DropdownMenuItem<String>> items = [
  const DropdownMenuItem(
    child: Text("Ichemic stroke"),
    value: "1",
  ),
  const DropdownMenuItem(
    child: Text("Hemoragic stroke"),
    value: "2",
  ),
  const DropdownMenuItem(
    child: Text("TIA stroke"),
    value: "3",
  ),
];

List<DropdownMenuItem<String>> roles = [
  const DropdownMenuItem(
    child: Text("Patient"),
    value: "1",
  ),
  const DropdownMenuItem(
    child: Text("Doctor"),
    value: "2",
  ),
  const DropdownMenuItem(
    child: Text("Relative"),
    value: "3",
  ),
];

String _value = "1";
TextEditingController _weightController = TextEditingController(text: "");
TextEditingController _heightController = TextEditingController(text: "");
GlobalKey _key = GlobalKey<FormState>();

class _AddDataViewState extends State<AddDataView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _weightController = TextEditingController(text: "");
    _heightController = TextEditingController(text: "");
    _value = "1";
    isSelected = [false, false];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: GestureDetector(
        onTap: () async {
          DatabaseReference ref =
              FirebaseDatabase.instance.ref("Users/$iinGlobal/MedicalData");

          genderGlobal = isSelected[0] ? 'F' : 'M';

          switch (_value) {
            case '1':
              strokeTypeGlobal = 'Ichemic stroke';
              break;
            case '2':
              strokeTypeGlobal = 'Hemoragic stroke';
              break;
            case '3':
              strokeTypeGlobal = 'TIA stroke';
              break;
            default:
              strokeTypeGlobal = 'Ichemic stroke';
          }

          if (_weightController.text.isNotEmpty &&
              _heightController.text.isNotEmpty) {
            weightGlobal = int.parse(_weightController.text);
            heightGlobal = int.parse(_heightController.text);

            await ref.update({
              'Gender': genderGlobal,
              'StrokeType': strokeTypeGlobal,
              'Weight': weightGlobal,
              'Height': heightGlobal
            });

            bmiGlobal = weightGlobal / (heightGlobal * heightGlobal / 1000);
          }

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SetVoiceAssistant()));
        },
        child: Padding(
          padding: EdgeInsets.only(right: width * 0.04),
          child: Container(
            width: width * 0.31,
            height: 40,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 10)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white)
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: width * 0.88,
          child: Column(
            children: [
              slider(2, width),
              Container(
                width: width * 0.84,
                alignment:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Alignment.centerLeft
                        : Alignment.center,
                child: Text(
                  "Personalize trainings by adding data",
                  textAlign:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? TextAlign.start
                          : TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: "Ruberoid",
                      color: Color.fromARGB(255, 50, 50, 50)),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    // change the border color
                    primary: primaryColor,
                    // change the text color
                  ),
                ),
                child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4.0, left: 5.0),
                                    child: Text(
                                      "Gender",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    child: ToggleButtons(
                                      constraints: BoxConstraints(
                                          maxWidth: width * 0.12,
                                          minWidth: width * 0.12,
                                          minHeight: 60,
                                          maxHeight: 60),
                                      borderRadius: BorderRadius.circular(10),
                                      highlightColor:
                                          primaryColor.withOpacity(0.5),
                                      selectedColor:
                                          primaryColor.withOpacity(0.5),
                                      focusColor: primaryColor.withOpacity(0.5),
                                      fillColor: primaryColor.withOpacity(0.3),
                                      children: [
                                        Icon(
                                          Icons.female,
                                          color: primaryColor,
                                        ),
                                        Icon(
                                          Icons.male,
                                          color: Colors.blue,
                                        )
                                      ],
                                      isSelected: isSelected,
                                      onPressed: (int index) {
                                        setState(() {
                                          if (index == 0) {
                                            isSelected[0] = !isSelected[0];
                                            isSelected[1] = false;
                                          }

                                          if (index == 1) {
                                            isSelected[1] = !isSelected[1];
                                            isSelected[0] = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * 0.6,
                              child: DropdownButtonFormField<String>(
                                value: _value,
                                items: items,
                                borderRadius: BorderRadius.circular(25),
                                icon: const Icon(Icons.arrow_drop_down_sharp),
                                iconDisabledColor: Colors.black,
                                iconEnabledColor: primaryColor,
                                hint: const Text(
                                  "Select diagnosed stroke type",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _value = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  label: const Text(
                                    "Stroke type",
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.43,
                              height: 100,
                              child: TextFormField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Weight",
                                  hintText: "e.g. 89",
                                  suffixText: "kg",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                ),
                                onSaved: (String? value) {
                                  _weightController.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              width: width * 0.43,
                              height: 100,
                              child: TextFormField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Height",
                                  alignLabelWithHint: false,
                                  suffixText: "cm",
                                  hintText: "e.g. 165 cm",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1)),
                                ),
                                onSaved: (String? value) {
                                  _weightController.text = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: height * 0.02,
                        // ),
                        // Column(

                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(bottom:4.0, left: 3.0),
                        //       child: Text("Activity level", style: TextStyle(color: Colors.grey, fontSize: 12),),
                        //     ),
                        //     ToggleButtons(
                        //       borderRadius: BorderRadius.circular(10),
                        //       highlightColor: primaryColor.withOpacity(0.5),
                        //       selectedColor: primaryColor.withOpacity(0.5),
                        //       focusColor: primaryColor.withOpacity(0.5),
                        //       fillColor: primaryColor.withOpacity(0.3),
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(left:5.0, right:5.0),
                        //           child: Text("Low"),
                        //         ),
                        //       Padding(
                        //         padding: const EdgeInsets.only(
                        //               left: 5.0, right: 5.0),
                        //         child: Text("Medium"),
                        //       ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(
                        //               left: 5.0, right: 5.0),
                        //           child: Text("High"),
                        //         ),
                        //       ],
                        //       isSelected: isSelectedActivity,
                        //       onPressed: (int index) {
                        //         setState(() {
                        //           if (index == 0) {
                        //             isSelectedActivity[0] = !isSelectedActivity[0];
                        //             isSelectedActivity[1] = false;
                        //             isSelectedActivity[2] = false;
                        //           }

                        //           if (index == 1) {
                        //             isSelectedActivity[1] = !isSelectedActivity[1];
                        //             isSelectedActivity[0] = false;
                        //             isSelectedActivity[2] = false;
                        //           }

                        //           if (index == 2) {
                        //             isSelectedActivity[2] = !isSelectedActivity[2];
                        //             isSelectedActivity[0] = false;
                        //             isSelectedActivity[1] = false;
                        //           }
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    )),
              ),
              // GestureDetector(
              //   child: SizedBox(
              //     width: width * 0.5,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Text(
              //           "Skip for now",
              //           style: TextStyle(
              //               color: Colors.grey,
              //               fontSize: 15,
              //               decoration: TextDecoration.underline),
              //         ),
              //         SizedBox(
              //           width: width * 0.02,
              //         ),
              //         Icon(
              //           Icons.arrow_forward_ios,
              //           color: Colors.grey,
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
