/**
 * Created by trungduc.vnu@gmail.com.
 */
import 'package:flutter/material.dart';
import 'package:gcaeco_app/helper/Config.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebViewContainer extends StatefulWidget {
  final url;
  final title;
    WebViewContainer(this.url,this.title);
  @override
  createState() => _WebViewContainerState(this);
}
class _WebViewContainerState extends State<WebViewContainer> {
  WebViewContainer webViewContainer;
  final _key = UniqueKey();
  bool isLoading= true;
  _WebViewContainerState(this.webViewContainer);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Config().colorMain,
          title: Text(webViewContainer.title,style: TextStyle(
            fontSize: 16
          ),),
        ),
        body:Stack(
          children: <Widget>[
            WebView(
              key: _key,
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading ? Center( child: CircularProgressIndicator(),)
                : Container(),
          ],
        ),);
  }
}