import 'dart:async';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;



const appId = "f4cc478d0aad4422936ac6584c5b0b3b";
const token = "006f4cc478d0aad4422936ac6584c5b0b3bIACHrmlXDfdHFXP9dD9UXSAy5oKaVVIR9XqcmIqDFvRojVfucZIAAAAAEADIUmqkERC9YAEAAQATEL1g";




class VideoCall extends StatefulWidget {
  const VideoCall({Key key}) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  int _remoteUid;
  RtcEngine _engine;
  @override
  void initState() {
    super.initState();
    initForAgora();
  }
  Future<void> initForAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(appId));

    await _engine.enableVideo();

    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(token, "first", null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _renderRemoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: _renderLocalPreview(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // current user video
  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }

  // remote user video
  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid);
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
