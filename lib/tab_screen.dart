import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/camera_screen.dart';
import 'package:my_chat_app/screens/status_screen.dart';
import 'package:my_chat_app/screens/user_screen.dart';

class TabScreen extends StatefulWidget {
static const routName='/tab_screen';
  TabScreen();
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  String id;

  void getId() async {
    final data = await FirebaseAuth.instance.currentUser();
    id = data.uid;
  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
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
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onChanged: (itemIdentifier) async {
                if (itemIdentifier == 'logOut') {
                  getId();
                  await Firestore.instance
                      .document('users/$id')
                      .updateData({'status': Timestamp.now()});

                  FirebaseAuth.instance.signOut();
                }
              },
            )
          ],
          title: Text('Chat App'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                child: Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Tab(
                  child: Text('Status',
                      style: TextStyle(
                        fontSize: 20,
                      ))),
              Tab(
                  child: Text('Calls',
                      style: TextStyle(
                        fontSize: 20,
                      ))),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CameraScreen(),
            UserScreen(
              id: id,
            ),
           StatusScreen(),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }

  //
  //     DefaultTabController(
  //       length: 4,
  //       initialIndex: 1,
  //       child: SafeArea(
  //         child: Scaffold(
  //           extendBody: false,
  //           body: NestedScrollView(
  //             headerSliverBuilder: (ctx, innerBoxIsScrolled) {
  //               return <Widget>[
  //                 SliverAppBar(
  //                   actions: [
  //                     DropdownButton(
  //                       items: [
  //                         DropdownMenuItem(
  //                             child: Container(
  //                               child: Row(
  //                                 children: [
  //                                   Icon(Icons.exit_to_app),
  //                                   SizedBox(
  //                                     width: 8,
  //                                   ),
  //                                   Text('log Out')
  //                                 ],
  //                               ),
  //                             ),
  //                             value: 'logOut')
  //                       ],
  //                       icon: Icon(Icons.more_vert),
  //                       onChanged: (itemIdentifier) async {
  //                         if (itemIdentifier == 'logOut') {
  //                           getId();
  //                           await Firestore.instance
  //                               .document('users/$id')
  //                               .updateData({'status': Timestamp.now()});
  //
  //                           FirebaseAuth.instance.signOut();
  //                         }
  //                       },
  //                     )
  //                   ],
  //                   title: const Text('Chat App'),
  //                   pinned: true,
  //                   floating: true,
  //
  //                   bottom:const TabBar(
  //                     tabs: [
  //                       Tab(
  //                         child: Icon(Icons.camera_alt),
  //                       ),
  //                       Tab(child: Text('Chats')),
  //                       Tab(child: Text('Status')),
  //                       Tab(child: Text('Calls')),
  //                     ],
  //                   ),
  //                 ),
  //               ];
  //             },
  //             body:  TabBarView(
  //
  //               children: <Widget>[
  //
  //                 Icon(
  //                   Icons.airplanemode_active,
  //                   size: 250,
  //                 ),
  //                 UserScreen(
  //                   id: id,
  //                 ),
  //                 Icon(
  //                   Icons.airplanemode_active,
  //                   size: 250,
  //                 ),
  //                 Icon(
  //                   Icons.airplanemode_active,
  //                   size: 250,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  // }
}
