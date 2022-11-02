import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/video_call/call.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);

    return date;
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);

    return time;
  }

  static String _getTextAfterCommand(
      {required String text, required String command}) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return "";
    } else {
      return text.substring(indexAfter).trim();
    }
  }

  static Future<void> scanText(
      String rawText, AudioPlayer player, BuildContext context) async {
    final text = rawText.toLowerCase();

    if (text.contains("hello")) {
      await player.setAsset("assets/sound/hello.mp3");

      player.play();
    }
    if (text.contains("call")) {
      for (int i = 0; i < relatives.length; i++) {
        if (text.contains("call ${relatives.elementAt(i).relation}")) {
          String number = relatives.elementAt(i).number; //set the number here
          await FlutterPhoneDirectCaller.callNumber(number);
        }
      }
      // player.pause();
      // String number = '+77079610043';
      // await FlutterPhoneDirectCaller.callNumber(number);
    } else if (text.contains("write email")) {
      final body = _getTextAfterCommand(text: text, command: "write email");

      openEmail(body: body);
    } else if (text.contains("weather")) {
      await player.setAsset("assets/sound/good_weather.mp3");
      await player.play();
    } else if (text.contains("video")) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => VideoCallPageOficial()));
    } else if (text.contains("i feel bad")) {
      await player.setAsset("assets/sound/ggive_up.mp3");

      await player.play();
    } else if (text.contains("medication")) {
      try {
        DatabaseReference ref = FirebaseDatabase.instance.ref("LR");

        await ref.set(5);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error occured');
      }
    } else if (text.contains("open")) {
      final url = _getTextAfterCommand(text: text, command: "open");

      openLink(url: url);
    } else if (text.contains("go to")) {
      final url = _getTextAfterCommand(text: text, command: "go to");

      openLink(url: url);
    } else if (text.contains("what is app")) {
      await player.setAsset("assets/sound/about.mp3");

      await player.play();
    }
    // else if (text.contains(Command.call)) {}
  }

  static Future openLink({
    required String url,
  }) async {
    if (url.trim().isEmpty) {
      await _launchUrl('https://google.com');
    } else {
      await _launchUrl('https://$url');
    }
  }

  static Future openEmail({
    required String body,
  }) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

printIfDebug(data) {
  if (kDebugMode) {
    print(data);

    //    for (int i = 0; i < relatives.lenght; i++) {}

  }
}
