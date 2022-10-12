import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gcaeco_app/helper/helper_functions.dart';
import 'package:gcaeco_app/item_share/pickup_layout.dart';
import 'package:gcaeco_app/validators/app_constants.dart';
import 'package:gcaeco_app/validators/enum.dart';

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl(
      {Key key, @required this.url, @required this.title})
      : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.getNTPWrappedWidget(
        child: Scaffold(
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
            title: Text(
              title,
              style: TextStyle(
                  color: DESIGN_TYPE == Themetype.whatsapp
                      ? fiberchatWhite
                      : fiberchatBlack,
                  fontSize: 18),
            ),
            backgroundColor: DESIGN_TYPE == Themetype.whatsapp
                ? fiberchatDeepGreen
                : fiberchatWhite,
          ),
          body: const PDF().cachedFromUrl(
            url,
            placeholder: (double progress) => Center(child: Text('$progress %')),
            errorWidget: (dynamic error) => Center(child: Text(error.toString())),
          ),
        ));
  }
}
