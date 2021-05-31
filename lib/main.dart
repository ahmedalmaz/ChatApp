import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/auth_screen.dart';
import 'package:my_chat_app/screens/chat_screen.dart';
import 'package:my_chat_app/screens/user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
     home: StreamBuilder(
       stream: FirebaseAuth.instance.onAuthStateChanged,builder: (ctx ,authSnap){
         if(authSnap.hasData){
           return UserScreen();
         }
         return AuthScreen();
     },
     ),
      routes: {
        AuthScreen.routeName:(ctx)=>AuthScreen(),
        ChatScreen.routName:(ctx)=>ChatScreen(),
      },
    );
  }
}
