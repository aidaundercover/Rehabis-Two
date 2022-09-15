import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/models/Relative.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class PickingClosedOnes extends StatefulWidget {
  const PickingClosedOnes({Key? key}) : super(key: key);

  @override
  State<PickingClosedOnes> createState() => _PickingClosedOnesState();
}

// TextEditingController relation = TextEditingController(text: "");
String tempPhoneNumber = '';

class _PickingClosedOnesState extends State<PickingClosedOnes> {
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

  Widget contactCard(
    double width,
    double height,
    int n,
    String number,
    String person,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Center(
        child: Container(
          width: width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(3, 3),
                  color: Colors.black.withOpacity(0.02),
                  spreadRadius: 15,
                  blurRadius: 15,
                ),
                BoxShadow(
                    offset: const Offset(-3, -3),
                    color: Colors.black.withOpacity(0.02),
                    spreadRadius: 7,
                    blurRadius: 15,
                    blurStyle: BlurStyle.outer)
              ]),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Person $n",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                            child: Text(
                          '${person.toUpperCase()}',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: primaryColor),
                        ))),
                    IconButton(
                        onPressed: () {
                          showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                  width * 0.7, height * 0.5, 0, 0),
                              items: [
                                PopupMenuItem<String>(
                                  value: _value,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        relatives.remove(Relative(
                                            number: number, relation: person));

                                        ref.child('Relatives/$_value').remove();
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // PopupMenuItem<int>(
                                //   value: 1,
                                //   child: Text('Working a lot less'),
                                // ),
                                // PopupMenuItem<int>(
                                //   value: 1,
                                //   child: Text('Working a lot smarter'),
                                // ),
                              ]);
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        )),
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Adding Emergency number',
            style: TextStyle(color: primaryColor, fontFamily: 'Inter'),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              setState(() {
                showDialog(
                    context: context,
                    builder: (context) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Dialog(
                            child: Container(
                              width: width * 0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 330,
                              child: Form(
                                  child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Add a Person",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.grey,
                                          fontSize: 24),
                                    ),
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Phone number",
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    fontSize: 19),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (conext) =>
                                                                ContactsList(
                                                                    contacts:
                                                                        contacts!)));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: primaryColor
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      child: Text(
                                                        tempPhoneNumber.isEmpty
                                                            ? "Pick a numebr"
                                                            : tempPhoneNumber,
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontFamily: 'Inter',
                                                        ),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Relation",
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    fontSize: 19),
                                              ),
                                              SizedBox(
                                                width: width * 0.35,
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value: _value,
                                                  items: items,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down_sharp),
                                                  iconDisabledColor:
                                                      Colors.black,
                                                  iconEnabledColor:
                                                      primaryColor,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _value = value!;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryColor,
                                                                width: 2)),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            borderSide: BorderSide(
                                                                color:
                                                                    primaryColor,
                                                                width: 2)),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1)),
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
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor
                                                            .withOpacity(0.3)),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: primaryColor),
                                                    ),
                                                  )),
                                              SizedBox(width: 20),
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() async {
                                                      String relation = '';
                                                      switch (_value) {
                                                        case '1':
                                                          relation = 'mom';
                                                          break;
                                                        case '2':
                                                          relation = 'dad';
                                                          break;
                                                        case '3':
                                                          relation = 'son';
                                                          break;
                                                        case '4':
                                                          relation = 'daughter';
                                                      }

                                                      if (tempPhoneNumber
                                                              .isNotEmpty &&
                                                          relation.isNotEmpty) {
                                                        relatives.add(Relative(
                                                            number:
                                                                tempPhoneNumber,
                                                            relation:
                                                                relation));

                                                        await ref
                                                            .child(
                                                                'Relatives/$_value')
                                                            .set({
                                                          'number':
                                                              tempPhoneNumber,
                                                          'relation': relation
                                                        });

                                                        tempPhoneNumber = '';
                                                        relation = '';
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: primaryColor
                                                            .withOpacity(0.8)),
                                                    child: Text(
                                                      "Save",
                                                      style: TextStyle(
                                                          color: Colors.white),
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
                          ),
                        ));
              });
            },
            child: Icon(Icons.add)),
        body: SingleChildScrollView(
            child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData) {
                    final user = Map<String, dynamic>.from(
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
                    if (user.containsKey('Relatives')) {
                      return StreamBuilder(
                          stream: ref.child('Relatives').onValue,
                          builder:
                              (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData) {
                              final myRealatives = Map<String, dynamic>.from(
                                  snapshot.data!.snapshot.value
                                      as Map<dynamic, dynamic>);

                              myRealatives.forEach((key, value) {
                                final nextRel = Map<String, dynamic>.from(value);
                                final rel = Relative(
                                    number: nextRel['number'],
                                    relation: nextRel['relation']);
                                relatives.add(rel);
                              });

                              // for (int i = 0; i < myRealatives.length; i++) {
                               
                              // }

                              return Column(
                                  children: List.generate(
                                      relatives.length,
                                      (index) => contactCard(
                                          width,
                                          height,
                                          index + 1,
                                          relatives.elementAt(index).number,
                                          relatives
                                              .elementAt(index)
                                              .relation)));
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text(
                                      "There is no emergency contacts so far.",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 25)));
                            } else {
                              return const Center(
                                  child: Text(
                                      "There is no emergency contacts so far.",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 25)));
                            }
                          });
                    } else {
                      return const Center(
                          child: Text("There is no emergency contacts so far.",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                  fontSize: 25)));
                    }
                  } else {
                    return CircularProgressIndicator(color: primaryColor);
                  }
                })));
    //             ));,
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
