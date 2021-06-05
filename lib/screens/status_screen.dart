import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/screens/status_view_screen.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('stories').snapshots(),
        builder: (ctx, snapshots) => snapshots.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshots.data.documents.length,
                itemBuilder: (ctx, index) => Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                StatusViewScreen.routName,
                                arguments: snapshots.data.documents[index]
                                    ['id']);
                          },
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                snapshots.data.documents[index]['image']),
                          ),
                          title: Text(snapshots.data.documents[index]['name']),
                          subtitle: Text(
                              '${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(snapshots.data.documents[index]['time'].microsecondsSinceEpoch))}'),
                        ),
                        Divider()
                      ],
                    )));
  }
}
