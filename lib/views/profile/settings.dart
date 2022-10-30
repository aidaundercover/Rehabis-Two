import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/views/profile/settings/reminder.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:rehabis/services/speech_api.dart';
import 'package:rehabis/utils/utils.dart';
import 'package:rehabis/widgets/slider_fv.dart';
import 'package:rehabis/widgets/substring_highlight.dart';

import 'settings/picking_closed_ones.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List tiles = [
    {
      'icon': Icons.edit,
      'title': "My Profile",
      'page': Reminder(),
    },
    {'icon': Icons.notification_add, 'title': "Reminder", 'page': Reminder()},
    {'icon': Icons.speaker, 'title': "Sound Options", 'page': Voice()},
    {
      'icon': Icons.emergency,
      'title': "Emergency Contacts",
      'page': PickingClosedOnes()
    },
  ];

  Widget createTile(String title, IconData icon, Widget page) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontFamily: "Inter"),
        ),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page)),
      ),
    );
  }


  

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                    title: Text(
                      "Settings",
                      style:
                          TextStyle(fontFamily: "Inter", color: Colors.black54),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ))
              ],
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: width * 0.8,
                child: Column(children: [
                  Column(
                    children: [
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Back Up & Restore",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 20),
                                    ),
                                    Image.asset(
                                      'assets/google.png',
                                      height: 50,
                                    )
                                  ],
                                ),
                                Text(
                                  "Sign In and sycnhronize your data",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14),
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.sync,
                                  color: primaryColor,
                                  size: 26,
                                ))
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.6,
                    child: ListView.builder(
                      itemCount: tiles.length,
                      itemBuilder: (context, i) => createTile(tiles[i]["title"],
                          tiles[i]["icon"], tiles[i]["page"]),
                    ),
                  ),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                        color: primaryColor, fontFamily: 'Inter', fontSize: 14),
                  )
                ]),
              ),
            ),
          )),
    );
  }
}




class Voice extends StatefulWidget {
  const Voice({Key? key}) : super(key: key);

  @override
  State<Voice> createState() => _Voice();
}

class _Voice extends State<Voice> {
  String text = "Hello!";
  bool isListening = false;

  late AudioPlayer player;

  @override
  void initState() {
    player = AudioPlayer();

    // relatives = {};

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: secondPrimaryColor,
        endRadius: 50,
        child: Container(
          decoration: BoxDecoration(
            color: secondPrimaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              color: Colors.white,
              splashRadius: 30,
              onPressed: toggleRecording,
              icon: isListening ? Icon(Icons.mic) : Icon(Icons.mic_none)),
        ),
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Text("Rehabis Helper",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 24,
                  color: secondPrimaryColor.withOpacity(0.6),
                  fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.question_mark_rounded, color: Colors.grey),
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          child: Column(children: []),
                        ),
                      );
                    });
              })
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: [
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? SizedBox(
                      width: width * 0.42,
                      child: Lottie.asset('assets/voice.json',
                          animate: isListening))
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                          width: width * 0.4,
                          child: Lottie.asset('assets/voice.json',
                              animate: isListening)),
                      SizedBox(width: width * 0.05),
                      SizedBox(
                        width: width * 0.3,
                        child: SubstringHighlight(
                          text: text,
                          terms: all,
                          textStyle: TextStyle(
                              fontSize: 27.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter"),
                          textStyleHighlight: TextStyle(
                              fontSize: 27.0,
                              color: secondPrimaryColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter"),
                        ),
                      )
                    ]),
              SizedBox(
                height: 15,
              ),
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Container(
                      width: width * 0.8,
                      alignment: Alignment.center,
                      child: SubstringHighlight(
                        text: text,
                        terms: all,
                        textStyle: TextStyle(
                            fontSize: 27.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                        textStyleHighlight: TextStyle(
                            fontSize: 27.0,
                            color: secondPrimaryColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(Duration(milliseconds: 500), () {
              Utils.scanText(text, player);
            });
          }
        },
      );
}
