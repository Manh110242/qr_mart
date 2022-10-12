//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/item_share/video_picker.dart';
import 'package:gcaeco_app/provider/observer.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:gcaeco_app/validators/enum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HybridImagePicker extends StatefulWidget {
  HybridImagePicker(
      {Key key,
        @required this.title,
        @required this.callback,
        this.profile = false})
      : super(key: key);

  final String title;
  final Function callback;
  final bool profile;

  @override
  _HybridImagePickerState createState() => new _HybridImagePickerState();
}

class _HybridImagePickerState extends State<HybridImagePicker> {
  File _imageFile;
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  String error;
  @override
  void initState() {
    super.initState();
  }

  void captureImage(ImageSource captureMode) async {
    final observer = Provider.of<Observer>(this.context, listen: false);
    error = null;
    try {
      PickedFile pickedImage = await (picker.getImage(source: captureMode));
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        setState(() {});
        if (_imageFile.lengthSync() / 1000000 >
            observer.maxFileSizeAllowedInMB) {
          error =
          'Max File Size ${observer.maxFileSizeAllowedInMB}MB\n\nSelected File Size ${(_imageFile.lengthSync() / 1000000).round()}MB';

          setState(() {
            _imageFile = null;
          });
        } else {
          setState(() {
            _imageFile = File(_imageFile.path);
          });
        }
      }
    } catch (e) {}
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return new Image.file(_imageFile);
    } else {
      return new Text('Chọn Ảnh',
          style: new TextStyle(
            fontSize: 18.0,
            color: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatWhite
                : fiberchatBlack,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.getNTPWrappedWidget(child: WillPopScope(
      child: Scaffold(
        backgroundColor:
        DESIGN_TYPE == Themetype.whatsapp ? fiberchatBlack : fiberchatWhite,
        appBar: new AppBar(
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
            title: new Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                color: DESIGN_TYPE == Themetype.whatsapp
                    ? fiberchatWhite
                    : fiberchatBlack,
              ),
            ),
            backgroundColor: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatBlack
                : fiberchatWhite,
            actions: _imageFile != null
                ? <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.check,
                    color: DESIGN_TYPE == Themetype.whatsapp
                        ? fiberchatWhite
                        : fiberchatBlack,
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    widget.callback(_imageFile).then((imageUrl) {
                      Navigator.pop(context, imageUrl);
                    });
                  }),
              SizedBox(
                width: 8.0,
              )
            ]
                : []),
        body: Stack(children: [
          new Column(children: [
            new Expanded(
                child: new Center(
                    child: error != null
                        ? fileSizeErrorWidget(error)
                        : _buildImage())),
            _buildButtons()
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
                  ? fiberchatBlack.withOpacity(0.8)
                  : fiberchatWhite.withOpacity(0.8),
            )
                : Container(),
          )
        ]),
      ),
      onWillPop: () => Future.value(!isLoading),
    ));
  }

  Widget _buildButtons() {
    return new ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(new Key('retake'), Icons.photo_library, () {
                HelperFunctions.checkAndRequestPermission(Permission.photos)
                    .then((res) {
                  if (res) {
                    captureImage(ImageSource.gallery);
                  } else {
                    HelperFunctions.toast('Cần cấp quyền');
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
                    captureImage(ImageSource.camera);
                  } else {
                    // getTranslated(context, 'pci');
                    // Navigator.pushReplacement(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) => OpenSettings()));
                  }
                });
              }),
            ]));
  }

  Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
    return new Expanded(
      // ignore: deprecated_member_use
      child: new RaisedButton(
          key: key,
          child: Icon(icon, size: 30.0),
          shape: new RoundedRectangleBorder(),
          color: DESIGN_TYPE == Themetype.whatsapp
              ? fiberchatDeepGreen
              : fiberchatgreen,
          textColor: fiberchatWhite,
          onPressed: onPressed as void Function()),
    );
  }
}
