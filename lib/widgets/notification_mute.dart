import 'package:flutter/material.dart';

class NotificationMute extends StatefulWidget {
  const NotificationMute({Key key}) : super(key: key);

  @override
  _NotificationMuteState createState() => _NotificationMuteState();
}

class _NotificationMuteState extends State<NotificationMute> {
  var onOf=false;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Mute Notification ' ,style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17
          ),),
          Switch.adaptive(value: onOf, onChanged: (bool){
            setState(() {
              onOf=bool;
            });
          })
        ],
      ),
    );
  }
}
