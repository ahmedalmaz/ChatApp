import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/screens/auth_screen.dart';
import 'package:my_chat_app/screens/chat_screen.dart';
import 'package:my_chat_app/screens/user_details_screen.dart';
import 'package:my_chat_app/screens/user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
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
        UserDetailsScreen.routeName:(ctx)=>UserDetailsScreen(),
      },
    );
  }
}

