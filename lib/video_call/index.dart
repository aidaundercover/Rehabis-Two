import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rehabis/globalVars.dart';
import 'package:rehabis/video_call/call.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController(text: "");

  ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    // TODO: implement dispose
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing a VIDEO CALL'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Enter a channel ID', style: TextStyle(fontSize: 29,fontWeight: FontWeight.bold),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.5,
              child: TextFormField(
                controller: _channelController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Column(
              children: [
                RadioListTile<ClientRoleType>(
                    activeColor: primaryColor,
                    title: const Text('Audience'),
                    value: ClientRoleType.clientRoleAudience,
                    groupValue: _role,
                    onChanged: (ClientRoleType? value) {
                      setState(() {
                        _role = value;
                      });
                    }),
                RadioListTile(
                    activeColor: primaryColor,
                    title: const Text('Broadcaster'),
                    value: ClientRoleType.clientRoleBroadcaster,
                    groupValue: _role,
                    onChanged: (ClientRoleType? value) {
                      setState(() {
                        _role = value;
                      });
                    })
              ],
            ),
            ElevatedButton(onPressed: onJoin, child: Text('JOIN'))
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VideoCallPage(
                channelName: _channelController.text,
                role: _role,
              )));
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
