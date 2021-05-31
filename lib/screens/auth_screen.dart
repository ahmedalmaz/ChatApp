import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

enum AuthMode { SignUp, Login }

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class AuthScreen extends StatelessWidget {
  static const routeName = '/Auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                width: deviceSize.width,
                height: 250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/chat.png')),
                    gradient: LinearGradient(
                        colors: [Color(0xFF3883CD), Color(0xFF11249F)],
                        stops: [0, 1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
              ),
            ),
            AuthCard(),
            Row(
              children: [
                Text(
                  'Forgot your password ?',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 30,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Reset password'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  String name;
  String email;
  String password;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    } else {
      _formKey.currentState.save();
      final authFireBase = FirebaseAuth.instance;
      try {
        if (_authMode == AuthMode.Login) {
          await authFireBase.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          final data=await authFireBase.createUserWithEmailAndPassword(
              email: email, password: password);
        String uri='';
        if(_image!=null) {
          final ref = FirebaseStorage.instance.ref().child('userImages').child(
              data.user.uid + '.jpg');
          await ref
              .putFile(_image)
              .onComplete;
          final url = await ref.getDownloadURL();
          uri=url;
        }else{
          uri='https://png.pngitem.com/pimgs/s/130-1300400_user-hd-png-download.png';
        }
          Firestore.instance.collection('users').document(data.user.uid).setData(
              {'username':name ,
              'email':email,
                'id':data.user.uid,
                'userImage':uri
              });
        }
      } on PlatformException catch (error) {
        var message = 'failed';
        if (error != null) {
          message = error.message;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('an Error Occurred'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }
  File _image;
  void _pickImage()async{
        final _pickedImage= await ImagePicker.pickImage(source: ImageSource.camera);
        if(_pickedImage != null){
          setState(() {
            _image=File(_pickedImage.path);
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('You didn\'t Pick image') ));
        }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        height: _authMode == AuthMode.SignUp ? 465 : 275,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if(_authMode==AuthMode.SignUp)
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: AnimatedContainer(

                      duration: Duration(milliseconds: 500),
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                        maxHeight: _authMode == AuthMode.SignUp ? 145 : 0,
                      ),
                      curve: Curves.easeIn,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage: _image==null?AssetImage('assets/images/user.png'):FileImage(_image),
                            ),
                            TextButton.icon(onPressed: _pickImage, label: Text('Pick image') , icon: Icon(Icons.image),)
                          ],
                        )
                      ),
                    ),
                  ),

                TextFormField(
                  onSaved: (value) {
                    email = value;
                  },
                  validator: (data) {
                    if (data.isEmpty || !data.contains('@')) {
                      return 'enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                  // decoration: ,
                ),
                SizedBox(height: 10,),
                if(_authMode==AuthMode.SignUp)
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: AnimatedContainer(
                     margin: EdgeInsets.only(bottom: 10),
                      duration: Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                        maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                      ),
                      curve: Curves.easeIn,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          onSaved: (value) {
                            name = value;
                          },
                          validator: (data) {
                            if (data.isEmpty) {
                              return 'enter user name ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'User name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          // decoration: ,
                        ),
                      ),
                    ),
                  ),


                TextFormField(
                  validator: (data) {
                    if (data.length < 6) {
                      return 'pls enter stronger password ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                  // decoration: ,
                ),
                SizedBox(
                  height: 22,
                ),
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: Icon(Icons.login),
                  label: Text(
                    _authMode == AuthMode.Login ? 'Log in' : 'sign Up',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                      elevation: MaterialStateProperty.all(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
