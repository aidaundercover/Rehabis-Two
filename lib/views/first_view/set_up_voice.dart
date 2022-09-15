import 'dart:async';

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

class SetVoiceAssistant extends StatefulWidget {
  const SetVoiceAssistant({Key? key}) : super(key: key);

  @override
  State<SetVoiceAssistant> createState() => _SetVoiceAssistantState();
}

class _SetVoiceAssistantState extends State<SetVoiceAssistant> {
  String text = "Press mic and say hi";
  bool isListening = false;

  bool isPressed = false;

  late AudioPlayer player;

  @override
  void initState() {
    // TODO: implement initState
    player = AudioPlayer();
    welcome();

    isLoggedIn = true;

    super.initState();
  }

  void welcome() async {
    await player.setAsset("assets/welcome.mp3");
    setState(() {
      isListening = true;
      isPressed = true;
    });
    player.play();

    Timer(Duration(seconds: 4), () {
      setState(() {
        isListening = false;
        isPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: SizedBox(
        width: width * 0.5 + 30,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AvatarGlow(
              animate: isPressed,
              glowColor: secondPrimaryColor,
              endRadius: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: secondPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                    color: Colors.white,
                    splashRadius: 30,
                    onPressed: () {
                      toggleRecording();
                      setState(() {
                        isPressed != isPressed;
                      });
                    },
                    icon: isPressed ? Icon(Icons.mic) :
                  Icon(Icons.mic_none)),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Main())),
              child: Container(
                width: width * 0.31,
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: [
              slider(3, width),
              Container(
                width: width * 0.8,
                alignment:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Alignment.centerLeft
                        : Alignment.center,
                child: Text(
                  "Use in-build voice assistant.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: "Ruberoid",
                      color: Color.fromARGB(255, 50, 50, 50)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? SizedBox(
                      width: width * 0.42,
                      child: Lottie.asset('assets/voice.json',
                          animate: isListening))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          SizedBox(
                              width: width * 0.3,
                              child: Lottie.asset('assets/voice.json',
                                  animate: isListening)),
                          SizedBox(
                            width: width * 0.4,
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
      onResult: (t) => setState(() => text = t),
      onListening: (isListening) {
        setState(() => isListening = isListening);

        if (!isListening) {
          Future.delayed(Duration(milliseconds: 500), () {
            Utils.scanText(text, player);
          });
        }
      });
}
