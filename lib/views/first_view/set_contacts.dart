import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rehabis/widgets/contact_card_first_view.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/main.dart';
import 'package:rehabis/services/speech_api.dart';
import 'package:rehabis/utils/utils.dart';
import 'package:rehabis/widgets/slider_fv.dart';
import 'package:rehabis/widgets/substring_highlight.dart';
import 'package:rehabis/models/Relative.dart';

class SetNotificationsView extends StatefulWidget {
  const SetNotificationsView({Key? key}) : super(key: key);

  @override
  State<SetNotificationsView> createState() => _SetNotificationsViewState();
}

String tempPhoneNumber = '';

class _SetNotificationsViewState extends State<SetNotificationsView> {
  List<Contact>? contacts;
  DatabaseReference ref = FirebaseDatabase.instance.ref('Users/$iinGlobal/');

  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      value: "1",
      child: Text("Mom"),
    ),
    const DropdownMenuItem(
      value: "2",
      child: Text("Dad"),
    ),
    const DropdownMenuItem(
      value: "3",
      child: Text("Son"),
    ),
    const DropdownMenuItem(
      value: "4",
      child: Text("Daughter"),
    ),
    const DropdownMenuItem(
      value: "5",
      child: Text("Friend"),
    ),
  ];

  String _value = "1";

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    TextEditingController _role = TextEditingController(text: '');

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Main())),
          child: Container(
            width: width * 0.25,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 2, color: secondPrimaryColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Complete",
                  style: TextStyle(color: secondPrimaryColor, fontSize: 15),
                ),
                Icon(
                  Icons.done_rounded,
                  color: secondPrimaryColor,
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: width * 0.86,
              child: Column(
                children: [
                  slider(3, width),
                  SizedBox(
                    child: Lottie.asset(
                      'assets/lottie/family.json',
                      animate: true,
                      width: width * 0.5,
                    ),
                  ),
                  relatives.isNotEmpty
                      ? StatefulBuilder(
                        builder: (context, setState) =>
                        SizedBox(
                            height: relatives.length*76,
                            child: ListView.builder(
                                itemCount: relatives.length,
                                itemBuilder: (context, i) {
                                
                                  return contactCard(
                                      width,
                                      i + 1,
                                      relatives.elementAt(i).number,
                                      relatives.elementAt(i).relation);
                                }),
                          )
                      )
                      : Container(
                          width: width * 0.7,
                          child: Text(
                            'Adding emergency contacts will give you the ability to contact them via phone/video call, anytime just by voice command',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 23,
                                fontFamily: 'Inter'),
                          ),
                        ),
                  SizedBox(
                    height: 24,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          showDialog(
                              context: context,
                              builder:
                                  (context) => StatefulBuilder(
                                          builder: (context, setState) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                            width: width * 0.7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            height: 330,
                                            child: Form(
                                                child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Add a Person",
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontSize: 24),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.6,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Phone number",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8),
                                                                  fontSize: 19),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (conext) =>
                                                                              ContactsList(contacts: contacts!)));
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: primaryColor
                                                                          .withOpacity(
                                                                              0.3),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            15),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          tempPhoneNumber.isEmpty
                                                                              ? "Pick a number"
                                                                              : tempPhoneNumber,
                                                                          style: TextStyle(
                                                                              color: primaryColor,
                                                                              fontFamily: 'Inter',
                                                                              fontSize: 17),
                                                                        ),
                                                                        tempPhoneNumber.isEmpty
                                                                            ? Icon(
                                                                                Icons.person_add,
                                                                                color: primaryColor,
                                                                              )
                                                                            : SizedBox()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Relation",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8),
                                                                  fontSize: 19),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.25,
                                                              child:
                                                                  DropdownButtonFormField<
                                                                      String>(
                                                                value: _value,
                                                                items: items,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .arrow_drop_down_sharp),
                                                                iconDisabledColor:
                                                                    Colors
                                                                        .black,
                                                                iconEnabledColor:
                                                                    primaryColor,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _value =
                                                                        value!;
                                                                  });
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      borderSide: BorderSide(
                                                                          color:
                                                                              primaryColor,
                                                                          width:
                                                                              2)),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      borderSide: BorderSide(
                                                                          color:
                                                                              primaryColor,
                                                                          width:
                                                                              2)),
                                                                  disabledBorder: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              1)),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 35,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: primaryColor
                                                                          .withOpacity(
                                                                              0.3)),
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color:
                                                                            primaryColor),
                                                                  ),
                                                                )),
                                                            SizedBox(width: 20),
                                                            TextButton(
                                                                onPressed: () {
                                                                  setState(
                                                                      () async {
                                                                    String
                                                                        relation =
                                                                        '';
                                                                    switch (
                                                                        _value) {
                                                                      case '1':
                                                                        relation =
                                                                            'mom';
                                                                        break;
                                                                      case '2':
                                                                        relation =
                                                                            'dad';
                                                                        break;
                                                                      case '3':
                                                                        relation =
                                                                            'son';
                                                                        break;
                                                                      case '4':
                                                                        relation =
                                                                            'daughter';
                                                                    }

                                                                    if (tempPhoneNumber
                                                                            .isNotEmpty &&
                                                                        relation
                                                                            .isNotEmpty) {
                                                                      relatives.add(Relative(
                                                                          number:
                                                                              tempPhoneNumber,
                                                                          relation:
                                                                              relation));

                                                                      await ref
                                                                          .child(
                                                                              'Relatives/$relation')
                                                                          .set({
                                                                        "number":
                                                                            tempPhoneNumber
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      tempPhoneNumber =
                                                                          '';
                                                                      relation =
                                                                          '';
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 35,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: primaryColor
                                                                          .withOpacity(
                                                                              0.8)),
                                                                  child: Text(
                                                                    "Save",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          ),
                                        );
                                      }));
                        });
                      },
                      child: Container(
                        width: width * 0.3,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.grey.shade700,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: width * 0.05),
                              child: Text(
                                "Add Contact",
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 19),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}

class ContactsList extends StatefulWidget {
  ContactsList({Key? key, required this.contacts}) : super(key: key);

  List<Contact> contacts;

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.contacts.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ))
            : ListView.builder(
                itemCount: widget.contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (widget.contacts[index].phones.isNotEmpty)
                      ? (widget.contacts[index].phones.first.number)
                      : "--";
                  return ListTile(
                      leading: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: primaryColor),
                          child: Text(
                            widget.contacts[index].name.first[0],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          )),
                      title: Text(
                          "${widget.contacts[index].name.first} ${widget.contacts[index].name.last}"),
                      subtitle: Text(num),
                      onTap: () {
                        setState(() {
                          tempPhoneNumber = num;
                        });
                        Navigator.of(context).pop();
                      });
                },
              ));
  }
}
