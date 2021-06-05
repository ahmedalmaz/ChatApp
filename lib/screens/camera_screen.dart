import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/screens/image_preview.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key key,
  }) : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture=_controller.initialize();

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  void takePhoto() async{

    await _controller.takePicture().then((value){
      Navigator.of(context).pushNamed(ImagePreview.routeName, arguments: value.path);
    });
  }


    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (ctx, snapshots) {
              if (snapshots.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width - 80,
            margin: EdgeInsets.only(right: 40, left: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.flash_off),
                      onPressed: () {},
                      iconSize: 30,
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.panorama_fish_eye),
                      onPressed: takePhoto,
                      iconSize: 70,
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.flip_camera_ios),
                      onPressed: () {},
                      iconSize: 30,
                      color: Colors.white,
                    )
                  ],
                ),
                Text(
                  'Tab to take photo , Hold for video',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
