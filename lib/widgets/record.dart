import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Record extends StatefulWidget {
  final String url;
  final bool isMe;
  Record({this.url, this.isMe});

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayerState _audioPlayerState = AudioPlayerState.PAUSED;
  int timeProg = 0;
  int duration = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        _audioPlayerState = event;
      });
    });
    _audioPlayer.setUrl(widget.url);
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event.inMilliseconds;
      });
    });
    _audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        timeProg = event.inMilliseconds;
      });
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        timeProg = 0;
        _audioPlayerState = AudioPlayerState.PAUSED;
        _audioPlayer.pause();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.release();
    _audioPlayer.dispose();
  }

  void _play() async {
    await _audioPlayer.play(
      widget.url,
      isLocal: false,
    );
  }

  void _pause() async {
    await _audioPlayer.pause();
  }

  void seekTo(int sec) {
    Duration pos = Duration(seconds: sec);
    _audioPlayer.seek(pos);
  }

  String getTimeString(int seconds) {


    String secondString =
        '${(seconds/1000).floor()%60<10?0:''}${(seconds/1000).floor()%60}';
    return '$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return widget.isMe
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: _audioPlayerState == AudioPlayerState.PAUSED
                      ? _play
                      : _pause,
                  child: Icon(
                    _audioPlayerState == AudioPlayerState.PAUSED
                        ? Icons.play_arrow
                        : Icons.pause,
                    size: 40,
                  )),
              Container(
                width: 240,
                height: 2,
                child: Slider.adaptive(
                  value: (timeProg / 1000).floorToDouble(),
                  onChanged: (value) {
                    seekTo(value.toInt());
                  },
                  max: (duration / 1000).floorToDouble(),
                ),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(getTimeString(timeProg)),
              Container(
                width: 240,
                height: 2,
                child: Slider.adaptive(
                  value: (timeProg / 1000).floorToDouble(),
                  onChanged: (value) {
                    seekTo(value.toInt());
                  },
                  max: (duration / 1000).floorToDouble(),
                ),
              ),
              InkWell(
                  onTap: _audioPlayerState == AudioPlayerState.PAUSED
                      ? _play
                      : _pause,
                  child: Icon(
                    _audioPlayerState == AudioPlayerState.PAUSED
                        ? Icons.play_arrow
                        : Icons.pause,
                    size: 40,
                  )),
            ],
          );
  }
}
