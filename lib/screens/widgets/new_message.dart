import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      'message': message,
      'senderId': currentUserId,
      'date': Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: 5, left: 5),
          child: TextFormField(
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
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _message.trim().isEmpty
              ? null
              : () {
                  _controller.clear();
                  setMessage(
                      chatId: widget.chatRoomId,
                      currentUserId: widget.currentUserId,
                      message: _message.trim());
                },
          iconSize: 30,
          color: Theme.of(context).accentColor,
        )
      ],
    );
  }
}
