import 'package:camera/camera.dart';
import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chat_app/screens/auth_screen.dart';
import 'package:my_chat_app/screens/chat_screen.dart';
import 'package:my_chat_app/screens/image_preview.dart';
import 'package:my_chat_app/screens/status_view_screen.dart';
import 'package:my_chat_app/screens/user_details_screen.dart';
import 'package:my_chat_app/tab_screen.dart';
import './screens/camera_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
   cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp();
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
           return TabScreen();
         }
         return AuthScreen();
     },
     ),
      routes: {
        TabScreen.routName:(ctx)=>TabScreen(),
        AuthScreen.routeName:(ctx)=>AuthScreen(),
        ChatScreen.routName:(ctx)=>ChatScreen(),
        UserDetailsScreen.routeName:(ctx)=>UserDetailsScreen(),
        ImagePreview.routeName:(ctx)=>ImagePreview(),
        StatusViewScreen.routName:(ctx)=>StatusViewScreen()
      },
    );
  }
}

