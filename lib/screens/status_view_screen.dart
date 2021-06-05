import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StatusViewScreen extends StatefulWidget {
  static const routName = '/status_view_screen';

  @override
  _StatusViewScreenState createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  List<StoryItem> list = [];
  final _controller = StoryController();

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: StreamBuilder(
          stream: Firestore.instance.document('users/$id').snapshots(),
          builder: (ctx, snapshots) =>
              snapshots.connectionState == ConnectionState.waiting
                  ? CircularProgressIndicator()
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(snapshots.data['userImage']),
                        ),
                        SizedBox(width: 12,),
                        Text(snapshots.data['username'])
                      ],
                    ),
        ),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('stories')
              .document(id)
              .collection('story').orderBy('time',descending: false)
              .snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            for (int i = 0; i < snap.data.documents.length; i++) {
              list.add(StoryItem.pageImage(
                  NetworkImage(snap.data.documents[i]['image']),
                  imageFit: BoxFit.contain,
                  duration: Duration(seconds: 10),
                  caption: snap.data.documents[i]['caption']));
            }
            return StoryView(
              list,
              controller: _controller,
              inline: false,
              onComplete: () {
                list=[];
                Navigator.of(context).pop();
              },
            );
          }),
    );
  }
}
