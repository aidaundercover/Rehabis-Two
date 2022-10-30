import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/services/speech_api.dart';
import 'package:rehabis/utils/utils.dart';
import 'package:rehabis/widgets/slider_fv.dart';
import 'package:rehabis/widgets/substring_highlight.dart';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:audio_session/audio_session.dart';

import '../../globalVars.dart';

class Voice extends StatefulWidget {
  const Voice({Key? key}) : super(key: key);

  @override
  State<Voice> createState() => _Voice();
}

class _Voice extends State<Voice> with WidgetsBindingObserver {
  String text = "Hello!";
  bool isListening = false;

  late AudioPlayer player;

  @override
  void initState() {

    player = AudioPlayer();
    isListening = false;

    // relatives = {};
    //ambiguate(WidgetsBinding.instance)!.addObserver(this);

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
                      child: Lottie.asset('assets/lottie/voice.json',
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
