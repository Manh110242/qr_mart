//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/provider/observer.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:gcaeco_app/validators/enum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StatusVideoEditor extends StatefulWidget {
  StatusVideoEditor({
    Key key,
    @required this.title,
    @required this.callback,
  }) : super(key: key);

  final String title;
  final Function(String str, File file, double duration) callback;
  @override
  _StatusVideoEditorState createState() => _StatusVideoEditorState();
}

class _StatusVideoEditorState extends State<StatusVideoEditor> {
  // File _image;
  // File _cameraImage;
  File _video;
  // File _video;
  final videoInfo = FlutterVideoInfo();

  ImagePicker picker = ImagePicker();
  final TextEditingController textEditingController =
  new TextEditingController();
  VideoPlayerController _videoPlayerController;
  var info;
  // This funcion will helps you to pick a Video File
  String error;

  _pickVideo() async {
    final observer = Provider.of<Observer>(this.context, listen: false);
    error = null;
    PickedFile pickedFile =
    await (picker.getVideo(source: ImageSource.gallery));

    _video = File(pickedFile.path);

    if (_video.lengthSync() / 1000000 > observer.maxFileSizeAllowedInMB) {
      error =
      'Max file Size ${observer.maxFileSizeAllowedInMB}MB\n\nSelected File Size ${(_video.lengthSync() / 1000000).round()}MB';

      setState(() {
        _video = null;
      });
    } else {
      info = await videoInfo.getVideoInfo(pickedFile.path);

      setState(() {});
      _videoPlayerController = VideoPlayerController.file(_video)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    }
  }

  // This funcion will helps you to pick a Video File from Camera
  _pickVideoFromCamera() async {
    final observer = Provider.of<Observer>(this.context, listen: false);
    error = null;
    PickedFile pickedFile =
    await (picker.getVideo(source: ImageSource.camera));

    _video = File(pickedFile.path);

    if (_video.lengthSync() / 1000000 > observer.maxFileSizeAllowedInMB) {
      error =
      'Max File Size ${observer.maxFileSizeAllowedInMB}MB\n\nSelected File Size ${(_video.lengthSync() / 1000000).round()}MB';

      setState(() {
        _video = null;
      });
    } else {
      info = await videoInfo.getVideoInfo(pickedFile.path);

      setState(() {});
      _videoPlayerController = VideoPlayerController.file(_video)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    }
  }

  _buildVideo(BuildContext context) {
    if (_video != null) {
        return _videoPlayerController.value.initialized
          ? AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController),
      )
          : Container();
    } else {
      return new Text('Chọn File',
          style: new TextStyle(
            fontSize: 18.0,
            color: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatWhite
                : fiberchatBlack,
          ));
    }
  }

  Widget _buildButtons() {
    return new ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(new Key('retake'), Icons.video_library_rounded,
                      () {
                    HelperFunctions.checkAndRequestPermission(Platform.isIOS
                        ? Permission.mediaLibrary
                        : Permission.storage)
                        .then((res) {
                      if (res) {
                        _pickVideo();
                      } else {
                        HelperFunctions.toast(
                          'Cần cấp quyền',
                        );
                        // Navigator.pushReplacement(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => OpenSettings()));
                      }
                    });
                  }),
              _buildActionButton(new Key('upload'), Icons.photo_camera, () {
                HelperFunctions.checkAndRequestPermission(Permission.camera)
                    .then((res) {
                  if (res) {
                    _pickVideoFromCamera();
                  } else {
                    HelperFunctions.toast(
                      'Cần cấp quyền',
                    );
                    // Navigator.pushReplacement(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) => OpenSettings()));
                  }
                });
              }),
            ]));
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      DESIGN_TYPE == Themetype.whatsapp ? Colors.black : fiberchatWhite,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 30,
            color: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatWhite
                : fiberchatBlack,
          ),
        ),
        backgroundColor:
        DESIGN_TYPE == Themetype.whatsapp ? Colors.black : fiberchatWhite,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            color: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatWhite
                : fiberchatBlack,
          ),
        ),
        actions: _video != null
            ? <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
                color: DESIGN_TYPE == Themetype.whatsapp
                    ? fiberchatWhite
                    : fiberchatBlack,
              ),
              onPressed: () {
                _videoPlayerController.pause();
                widget.callback(
                    textEditingController.text.isEmpty
                        ? ''
                        : textEditingController.text,
                    _video,
                    info.duration);
              }),
          SizedBox(
            width: 8.0,
          )
        ]
            : [],
      ),
      body: Stack(children: [
        new Column(children: [
          new Expanded(
              child: new Center(
                  child: error != null
                      ? fileSizeErrorWidget(error)
                      : _buildVideo(context))),
          _video != null
              ? Container(
            padding: EdgeInsets.all(12),
            height: 80,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(children: [
              Flexible(
                child: TextField(
                  maxLength: 100,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: fiberchatWhite),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.circular(1),
                      borderSide: BorderSide(
                          color: Colors.transparent, width: 1.5),
                    ),
                    hoverColor: Colors.transparent,
                    focusedBorder: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.circular(1),
                      borderSide: BorderSide(
                          color: Colors.transparent, width: 1.5),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                        borderSide:
                        BorderSide(color: Colors.transparent)),
                    contentPadding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                    hintText: 'Viết Caption',
                    hintStyle:
                    TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ]),
          )
              : _buildButtons()
        ]),
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(fiberchatBlue)),
            ),
            color: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatBlack.withOpacity(0.6)
                : fiberchatWhite.withOpacity(0.6),
          )
              : Container(),
        )
      ]),
    );
  }

  Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
    return new Expanded(
      // ignore: deprecated_member_use
      child: new RaisedButton(
          key: key,
          child: Icon(icon, size: 30.0),
          shape: new RoundedRectangleBorder(),
          color:
          DESIGN_TYPE == Themetype.whatsapp ? Colors.black : fiberchatgreen,
          textColor: fiberchatWhite,
          onPressed: onPressed as void Function()),
    );
  }
}

Widget fileSizeErrorWidget(String error) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, size: 60, color: Colors.red[300]),
        SizedBox(
          height: 15,
        ),
        Text(error,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.red[300])),
      ],
    ),
  );
}
