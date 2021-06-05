import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tab_screen.dart';

class ImagePreview extends StatelessWidget {
  static const routeName='/image_preview';
  const ImagePreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller=TextEditingController();
    var caption='';

    final path =ModalRoute.of(context).settings.arguments ;
    void uploadImage(String path)async{

      if(File(path)!=null){
        final user=await FirebaseAuth.instance.currentUser();
        final ref = FirebaseStorage.instance.ref().child('story').child(
            user.uid+Timestamp.now().toString() + '.jpg');
        await ref
            .putFile(File(path))
            .onComplete;
        final url = await ref.getDownloadURL();
        final userdata=await Firestore.instance.collection('users').document(user.uid).get();

        await Firestore.instance.collection('stories').document('${user.uid}').collection('story').add(
            {
              'image':url,
              'name':userdata['username'],
              'time':Timestamp.now(),
              'caption':caption,
              'id':userdata['id']

            });

        await Firestore.instance.collection('stories').document('${user.uid}').setData(
            {
              'image':url,
              'name':userdata['username'],
              'time':Timestamp.now(),
              'caption':caption,
              'id':userdata['id']

            }).then((value) {
              Navigator.of(context).pop();
        });
      }


    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(icon:Icon(Icons.crop_rotate) , onPressed: (){},iconSize: 27,),
          IconButton(icon:Icon(Icons.emoji_emotions_outlined) , onPressed: (){},iconSize: 27,),
          IconButton(icon:Icon(Icons.title) , onPressed: (){},iconSize: 27,),
          IconButton(icon:Icon(Icons.edit) , onPressed: (){},iconSize: 27,),
        ],
        backgroundColor: Colors.black,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),

      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,

              child: Image.file(File(path),fit: BoxFit.cover,),
            ),
          ),
          Container(
            color: Colors.white.withOpacity(.2),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(12),
            child: TextFormField(
              controller: _controller,
              onChanged: (value){
                caption=value;
              },

              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.add_photo_alternate,color: Colors.white,),
                suffixIcon: InkWell(
                  onTap: ()=>uploadImage(path),


                  child: CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.tealAccent[700],
                    child: Icon(Icons.check , color: Colors.white,),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 5 ,top: 16),
                alignLabelWithHint: false,
                hintText: 'Caption...',
                hintStyle: TextStyle(
                  color: Colors.white
                )
              ),
              style: TextStyle(
                color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
  }
}
