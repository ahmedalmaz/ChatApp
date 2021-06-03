import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/widgets/notification_mute.dart';

class UserDetailsScreen extends StatelessWidget {
  static const routeName = '/user_details_screen';

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
        body: StreamBuilder(
      stream: Firestore.instance.document('users/$userId').snapshots(),
      builder: (ctx, snapShots) =>
          snapShots.connectionState == ConnectionState.waiting
              ? CircularProgressIndicator()
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      stretch: true,
                      expandedHeight: 250,
                      elevation: 5,
                      forceElevated: true,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(left: 50, bottom: 10),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapShots.data['username'],
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              snapShots.data['status'] == 'online'
                                  ? 'online'
                                  : snapShots.data['status'] == 'Typing...'
                                      ? 'Typing...'
                                      : 'last seen at ${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(snapShots.data['status'].microsecondsSinceEpoch))}',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey.shade300,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        background: Hero(
                          tag: userId,
                          child: Image.network(
                            snapShots.data['userImage'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Card(
                            elevation: 5,
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            color: Colors.blue.shade200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 40,child: NotificationMute()),
                                Divider(color: Colors.white,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Custom Notification',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Divider(color: Colors.white,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Media visibility',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Divider(color: Colors.white,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Starred messages',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 450,)
                        ],
                      ),
                    )
                  ],
                ),
    ));
  }
}
