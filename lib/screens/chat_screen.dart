import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/widgets/Message.dart';
import 'package:my_chat_app/screens/widgets/new_message.dart';

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

        title:  InkWell(child: Container(
            width: double.infinity,
            height: 50,
            child: Text(userName),alignment: Alignment.centerLeft,),onTap: (){},),
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_outlined,size: 20,),
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 18,
              ),
            ],
          ),
        ),

      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chat_rooms/$chatroomId/messages')
            .orderBy('date' ,descending: true)
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
                            itemBuilder: (ctx, i) => Message(isMe:snapshots.data.documents[i]['senderId']==currentUserId? true:false , message: snapshots.data.documents[i]['message'],)
                          ),
                        ),
                      ),
                     NewMessage(chatRoomId: chatroomId,currentUserId: currentUserId  ,userName: userName,)
                    ],
                  ),
      ),
    );
  }
}
