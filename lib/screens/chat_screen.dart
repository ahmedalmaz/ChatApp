import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_chat_app/screens/user_details_screen.dart';
import 'package:my_chat_app/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  static const routName = '/Chat_screen';

  @override
  Widget build(BuildContext context) {
    final chatRomes =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final currentUserId = chatRomes['currentUser'];
    final user = chatRomes['id'];
    final userName = chatRomes['userName'];
    final chatroomId = chatRomes['docId'];
    final imageUrl = chatRomes['image'];

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, UserDetailsScreen.routeName,
                arguments: user);
          },
          child: StreamBuilder(
            stream: Firestore.instance.document('users/$user').snapshots(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              userName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              snapshot.data['status'] == 'online'
                                  ? 'online'
                                  : snapshot.data['status'] == 'Typing...'
                                      ? 'Typing...'
                                      : 'last seen at ${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(snapshot.data['status'].microsecondsSinceEpoch))}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: snapshot.data['status'] == 'online'
                                      ? Colors.cyanAccent
                                      : Colors.white),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ],
                      ),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
              ),
              Hero(
               tag: user,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chat_rooms/$chatroomId/messages')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (ctx, snapshots) =>
            snapshots.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                              reverse: true,
                              itemCount: snapshots.data.documents.length,
                              itemBuilder: (ctx, i) => Bubble(
                                    padding: BubbleEdges.all(10),
                                    child: Text(
                                      snapshots.data.documents[i]['message'],
                                      textAlign: snapshots.data.documents[i]
                                                  ['senderId'] ==
                                              currentUserId
                                          ? TextAlign.right
                                          : TextAlign.left,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    elevation: 5,
                                    margin: BubbleEdges.only(bottom: 10),
                                    color: snapshots.data.documents[i]
                                                ['senderId'] ==
                                            currentUserId
                                        ? Color.fromRGBO(30, 200, 255, 1.0)
                                        : Colors.grey.shade300,
                                    nip: snapshots.data.documents[i]
                                                ['senderId'] ==
                                            currentUserId
                                        ? BubbleNip.rightTop
                                        : BubbleNip.leftTop,
                                    alignment: snapshots.data.documents[i]
                                                ['senderId'] ==
                                            currentUserId
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                  )
                              //     Message(
                              //   isMe: snapshots.data.documents[i]['senderId'] ==
                              //           currentUserId
                              //       ? true
                              //       : false,
                              //   message: snapshots.data.documents[i]['message'],
                              // ),
                              ),
                        ),
                      ),
                      NewMessage(
                        chatRoomId: chatroomId,
                        currentUserId: currentUserId,
                        userName: userName,
                      )
                    ],
                  ),
      ),
    );
  }
}
