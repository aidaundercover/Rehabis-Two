import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/utils/videocall_settings.dart';

class VideoCallPage extends StatefulWidget {
  final String? channelName;
  final ClientRoleType? role;
  const VideoCallPage({Key? key, this.channelName, this.role})
      : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final _users = <int>[];
  final _infoString = <String>[];
  bool isMuted = false;
  bool viewPanel = false;
  late RtcEngineEx _engine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _users.clear();
    _engine.leaveChannel();
    //_engine.
    super.dispose();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoString.add('APP ID is empty');
      });
      return;
    }

    await _engine.initialize(const RtcEngineContext(appId: appId));
    await _engine.enableAudio();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(role: widget.role!);

    addAgoraEventHandlers();

    final configuration = VideoEncoderConfiguration();
    var d = VideoDimensions(width: 1000, height: 500);
    configuration.dimensions = d;
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(
        token: token,
        channelId: widget.channelName!,
        uid: 0,
        options: ChannelMediaOptions());
  }

  Future<void> addAgoraEventHandlers() async {
    _engine.registerEventHandler(RtcEngineEventHandler(
        onError: (err, msg) => setState(() {
              final info = 'Error: $msg';
              _infoString.add(info);
            }),
        onJoinChannelSuccess: (connection, elapsed) => _infoString.add(
            'Uid: ${connection.localUid.toString()}' +
                'Channel: ${connection.channelId.toString()}'),
        onLeaveChannel: (connection, stats) {
          _infoString.add('Leave Channel');
          _users.clear();
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          _infoString.add('User Joined: $remoteUid');
          _users.add(remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          _infoString.add('User Offline: $remoteUid');
          _users.remove(remoteUid);
        }));
  }

  Widget viewRows() {
    VideoCanvas canvas = VideoCanvas();
    RtcConnection connection = RtcConnection();
    VideoViewController controller = VideoViewController.remote(
        rtcEngine: _engine, canvas: canvas, connection: connection);
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRoleType.clientRoleBroadcaster) {
      list.add(AgoraVideoView(controller: controller));
    }

    for (var uid in _users) {
      VideoCanvas _canvas = VideoCanvas();
      RtcConnection _connection =
          RtcConnection(localUid: uid, channelId: widget.channelName);
      VideoViewController _controller = VideoViewController.remote(
          rtcEngine: _engine, canvas: _canvas, connection: _connection);
      list.add(AgoraVideoView(controller: _controller));

      final views = list;

      return Column(
        children: List.generate(views.length, (index) => views[index]),
      );
    }

    return SizedBox();
  }

  Widget toolBar() {
    if (widget.role == ClientRoleType.clientRoleAudience) {
      return SizedBox();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
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
              fillColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.call_end)),
          RawMaterialButton(
            fillColor: backgroundColor,
            onPressed: () {
              _engine.switchCamera();
            },
            child: Icon(Icons.camera_front)
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          viewRows(),
          toolBar()
        ],
      ),
    );
  }
}
