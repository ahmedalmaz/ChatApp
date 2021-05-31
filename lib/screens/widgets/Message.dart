import 'package:flutter/material.dart';

class Message extends StatelessWidget {

final bool isMe;
final String message;
Message({this.isMe , this.message});
  @override
  Widget build(BuildContext context) {
    return isMe? Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: 300,
              minWidth: 50,
              minHeight: 18
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(

              color: Colors.blue.shade300,
            borderRadius: BorderRadius.only(topLeft:Radius.circular(9), bottomLeft: Radius.circular(9),topRight: Radius.circular(9) )
          ),
          margin: EdgeInsets.only(bottom: 10 , right: 10),
          child: Text(message,textAlign: TextAlign.left,style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),),
        ),
      ],
    ):Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: 300,
              minWidth: 50,
            minHeight: 18
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(topLeft:Radius.circular(9), bottomRight: Radius.circular(9),topRight: Radius.circular(9) )
          ),
          margin: EdgeInsets.only(bottom: 10 , left: 10),
          child: Text(message,textAlign: TextAlign.left,style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),),
        ),
      ],
    );
  }
}
