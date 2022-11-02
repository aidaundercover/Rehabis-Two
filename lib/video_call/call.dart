import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/utils/videocall_settings.dart';

class VideoCallPageOficial extends StatefulWidget {
  const VideoCallPageOficial({Key? key}) : super(key: key);

  @override
  State<VideoCallPageOficial> createState() => _VideoCallPageOficialState();
}

class _VideoCallPageOficialState extends State<VideoCallPageOficial> {
  String channelName = "rehabis";

  int uid = int.parse(iinGlobal); // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine;
  bool isMuted = false; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    _isJoined = false;
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupVideoSDKEngine();
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) => showMessage(msg),
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  Widget toolBar(BuildContext context, double width) {
    return Center(
      child: SizedBox(
        width: width * 0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              fillColor: backgroundColor,
              onPressed: () {
                setState(() {
                  isMuted = !isMuted;
                });
              },
              child: isMuted
                  ? Icon(
                      Icons.mic_off,
                      color: primaryColor,
                    )
                  : Icon(
                      Icons.mic,
                      color: primaryColor,
                    ),
            ),
            RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                fillColor: backgroundColor,
                onPressed: () {
                  agoraEngine.disableVideo();
                },
                child: Icon(Icons.video_call)),
            RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                fillColor: backgroundColor,
                onPressed: () {
                  agoraEngine.switchCamera();
                },
                child: Icon(Icons.camera_front)),
            RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                fillColor: Colors.red,
                onPressed: () {
                  leave(context);
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.call_end)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _localPreview()),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(child: _remoteVideo()),
              )
            ]),

            // Stack(
            //         alignment: Alignment.center,
            //         children: [
            //           Positioned(
            //             child: Container(
            //               height: MediaQuery.of(context).size.height,
            //               width: MediaQuery.of(context).size.width,
            //               decoration: BoxDecoration(border: Border.all()),
            //               child: Center(child: _remoteVideo()),
            //             ),
            //           ),
            //           Positioned(
            //             top: height * 0.62,
            //             child: SizedBox(
            //               width: width * 0.9,
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.end,
            //                 children: [

            //                   SizedBox(
            //                     height: 20,
            //                   ),
            //                   toolBar(context, width)
            //                 ],
            //               ),
            //             ),
            //           ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isJoined ? null : () => {join()},
                    child: const Text("Join"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isJoined ? () => {leave(context)} : null,
                    child: const Text("Leave"),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave(BuildContext context) {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    Navigator.of(context).pop();
  }

  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
