import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;


class NewMessage extends StatefulWidget {
  final currentUserId;

  final userName;
  final chatRoomId;

  NewMessage(
      {@required this.currentUserId,
      @required this.userName,
      @required this.chatRoomId});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String path = '';
  double radius=30;
  var _message = '';
  final _controller = TextEditingController();
  void setMessage(
      {String currentUserId,
      String otherUserId,
      String message,
      String chatId}) async {
     await Firestore.instance
        .collection('chat_rooms')
        .document('$chatId')
        .collection('messages')
        .add({
       'audio':'',
      'message': message,
      'senderId': currentUserId,
      'date': Timestamp.now()
    });
  }

  FocusNode _focus = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      Firestore.instance
          .document('users/${widget.currentUserId}')
          .updateData({'status': 'Typing...'});
    } else {
      Firestore.instance
          .document('users/${widget.currentUserId}')
          .updateData({'status': 'online'});
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {


            io.Directory appDocDirectory =
            await getApplicationDocumentsDirectory();
            path = appDocDirectory.path+Timestamp.now().toString();

          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);

      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }
  _stop() async {
    var recording = await AudioRecorder.stop();
    if(io.File(recording.path)!=null){

      final ref = FirebaseStorage.instance.ref().child('records').child(
          widget.currentUserId ).child(Timestamp.now().toString()+ '.m4a');
      await ref
          .putFile(io.File(recording.path))
          .onComplete;
      final url = await ref.getDownloadURL();

      await Firestore.instance.collection('chat_rooms').document(widget.chatRoomId).collection('messages').add(
          {
            'audio':url,
            'date':Timestamp.now(),
            'senderId':widget.currentUserId,
            'message':''

          });


    }




  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: 5, left: 5),
          child: TextField(
            focusNode: _focus,
            onChanged: (value) {
              setState(() {
                _message = value;
              });
            },
            controller: _controller,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
        )),
        SizedBox(
          width: 15,
        ),
        _message.trim().isEmpty
            ? GestureDetector(
          onLongPress: (){
            setState(() {
              radius=35;

            });
            _start();
          },
          onLongPressEnd: (value){
            setState(() {
              radius=30;

            });
            _stop();
            print('2');
          },
              child: CircleAvatar(
                  radius: radius,
                  child: Icon(Icons.keyboard_voice_rounded),),
            )
            : CircleAvatar(
          radius: 30,
              child: IconButton(
                  icon: Icon(Icons.send,color: Colors.white,),
                  onPressed: () {
                    _focus.unfocus();

                    _controller.clear();
                    setMessage(
                        chatId: widget.chatRoomId,
                        currentUserId: widget.currentUserId,
                        message: _message.trim());
                    _message = '';
                  },
                  iconSize: 30,
                  color: Theme.of(context).accentColor,
                ),
            ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
