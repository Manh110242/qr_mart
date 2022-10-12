//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:gcaeco_app/validators/download_media.dart';
import 'package:gcaeco_app/validators/save.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoViewWrapper extends StatelessWidget {
  PhotoViewWrapper(
      {this.imageProvider,
        this.message,
        this.loadingChild,
        this.backgroundDecoration,
        this.minScale,
        this.maxScale,
        @required this.tag});

  final String tag;
  final String message;

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  final GlobalKey<ScaffoldState> _scaffoldd = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoaderr =
  new GlobalKey<State>(debugLabel: 'qqgfggqesqeqsseaadqeqe');
  @override
  Widget build(BuildContext context) {
    return HelperFunctions.getNTPWrappedWidget(child: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldd,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24,
              color: fiberchatWhite,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: fiberchatLightGreen,
          onPressed: Platform.isIOS
              ? () {
            launch(message);
          }
              : () async {
            HelperFunctions.checkAndRequestPermission(Permission.storage)
                .then((res) async {
              if (res) {
                Save.saveToDisk(imageProvider, tag);
                await downloadFile(
                  context: _scaffoldd.currentContext,
                  fileName:
                  '${DateTime.now().millisecondsSinceEpoch}.png',
                  isonlyview: false,
                  keyloader: _keyLoaderr,
                  uri: message,
                );
              } else {
                HelperFunctions.toast('Cần cấp quyền');

              }
            });
          },
          child: Icon(
            Icons.file_download,
          ),
        ),
        body: Container(
            color: Colors.black,
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              loadingBuilder: (BuildContext context, var image) {
                return loadingChild ??
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(fiberchatBlue),
                        ),
                      ),
                    );
              },
              imageProvider: imageProvider,
              backgroundDecoration: backgroundDecoration as BoxDecoration,
              minScale: minScale,
              maxScale: maxScale,
            ))));
  }
}
