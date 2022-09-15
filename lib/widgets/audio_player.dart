import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';

class AudioPlay extends StatefulWidget {
  final String audioAsset;
  AudioPlay({Key? key, required this.audioAsset}) : super(key: key);

  @override
  State<AudioPlay> createState() => _AudioPlayState();
}

class _AudioPlayState extends State<AudioPlay> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration postion = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration as Duration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPostion) {
      setState(() {
        postion = newPostion;
      });
    });
  }

  Future setAudio() async {
    final player = AudioCache(prefix: "assets/");
    final url = await player.load(widget.audioAsset);

    audioPlayer.setSourceUrl(url.path);

    // audioPlayer.setSourceAsset(url.path);
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: primaryColor,
            child: IconButton(
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
                  await audioPlayer.resume();
                }
              },
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white,),
              iconSize: 30,
            ),
          ),
          SizedBox(
            width: width*0.7,
            child: Slider(
              activeColor: primaryColor,
              inactiveColor: deepPurple.withOpacity(0.6),
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: postion.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();
                }),
          )
        ],
      ),
    );
  }
}
