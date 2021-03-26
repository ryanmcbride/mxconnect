import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'network.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final String title;
  WebviewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

/*
WebView(
          initialUrl: 'https://flutter.io',
          javascriptMode: JavascriptMode.unrestricted,
        ),
 */
class _WebviewPageState extends State<WebviewPage> {
  WebViewController _controller;
  //String bearerToken = Network.bearerToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          color: Colors.white,
          child: WebView(
            initialUrl: "about.blank",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              //_controller.loadUrl(widget.url, headers: <String, String>{
              //  "Authorization": "Basic $bearerToken"
              //});
              _controller.loadUrl(widget.url);
            },
          ),
        ));
  }
}
