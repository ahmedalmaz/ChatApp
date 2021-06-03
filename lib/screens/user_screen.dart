import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/chat_screen.dart';

class UserScreen extends StatefulWidget {
  static const routName = '/user_screen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with WidgetsBindingObserver {
  String id;
  void getId() async {
    final data = await FirebaseAuth.instance.currentUser();
    id = data.uid;
  }

  void prepareChatRoom({String meSid, String userName, String imageUrl , String status}) async {

    final chatRoomId = '$id$meSid';
    var isIn = false;
    var isSame = false;
     await Firestore.instance
        .collection('chat_rooms/')
        .getDocuments()
        .then((value) {
      if (value.documents.length <= 0) {
        Firestore.instance
            .collection('chat_rooms')
            .document(chatRoomId)
            .setData({}).then((value) {
          Navigator.of(context).pushNamed(ChatScreen.routName, arguments: {
            'id': meSid,
            'currentUser': id,
            'userName': userName,
            'docId': '$chatRoomId',
            'status':status
          });
        });
      } else {
        value.documents.forEach((element) {
          if (element.documentID.contains(id) &&
              element.documentID.contains(meSid)) {
            isIn = true;
          }
          if (element.documentID == chatRoomId) {
            isSame = true;
          }
          // Firestore.instance.collection('chat_rooms').document(chatRoomId).setData(
          //     {}).then((value) {
          //   Navigator.of(context).pushNamed(ChatScreen.routName,arguments: {'id':meSid,'currentUser':id , 'userName':userName ,'docId':'chat_rooms$chatRoomId'});
        });
        if (isIn && isSame) {
          isIn = false;
          isSame = false;
          Navigator.of(context).pushNamed(ChatScreen.routName, arguments: {
            'id': meSid,
            'currentUser': id,
            'userName': userName,
            'docId': '$chatRoomId',
            'image': imageUrl,
            'status':status
          });
        } else if (isIn) {
          isIn = false;
          isSame = false;
          Navigator.of(context).pushNamed(ChatScreen.routName, arguments: {
            'id': meSid,
            'currentUser': id,
            'userName': userName,
            'docId': '$meSid$id',
            'image': imageUrl,
            'status':status
          });
        } else {
          Firestore.instance
              .collection('chat_rooms')
              .document(chatRoomId)
              .setData({}).then((value) {
            Navigator.of(context).pushNamed(ChatScreen.routName, arguments: {
              'id': meSid,
              'currentUser': id,
              'userName': userName,
              'docId': '$chatRoomId',
              'image': imageUrl,
              'status':status
            });
          });
        }
      }
      //
    });
  }

  @override
  void didChangeDependencies() {
    getId();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Firestore.instance.document('users/$id').updateData({'status': 'online'});
    } else if (state == AppLifecycleState.paused) {
      Firestore.instance
          .document('users/$id')
          .updateData({'status': Timestamp.now()});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat app'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text('log Out')
                      ],
                    ),
                  ),
                  value: 'logOut')
            ],
            icon: Icon(Icons.more_vert),
            onChanged: (itemIdentifier)async {
              if (itemIdentifier == 'logOut') {
                await Firestore.instance
                    .document('users/$id')
                    .updateData({'status': Timestamp.now()});

                FirebaseAuth.instance.signOut();

              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (ctx, snapshots) => snapshots.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshots.data.documents.length,
                itemBuilder: (ctx, i) => id == snapshots.data.documents[i]['id']
                    ? Container()
                    : InkWell(
                        onTap: () {
                          var meSid =
                              snapshots.data.documents[i]['id'].toString();
                          var userName = snapshots.data.documents[i]['username']
                              .toString();
                          var imageUrl = snapshots
                              .data.documents[i]['userImage']
                              .toString();
                          var status= snapshots
                              .data.documents[i]['status']
                              .toString();
                          prepareChatRoom(
                            status: status,
                              meSid: meSid,
                              userName: userName,
                              imageUrl: imageUrl);
                        },
                        child: Card(
                          margin: EdgeInsets.all(8),
                          elevation: 5,
                          color: Colors.grey.shade200,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshots
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? 'https://png.pngitem.com/pimgs/s/24-248309_transparent-profile-clipart-font-awesome-user-circle-hd.png'
                                  : snapshots.data.documents[i]['userImage']),
                              radius: 25,
                            ),
                            title: Text(
                              snapshots.data.documents[i]['username'],
                              // id
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle:
                                Text(snapshots.data.documents[i]['email']),
                            trailing: (snapshots.data.documents[i]['status'] ==
                                    'online' || snapshots.data.documents[i]['status'] =='Typing...' )
                                ? CircleAvatar(
                                    radius: 5,
                                  )
                                : Container(
                              width: 0,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
