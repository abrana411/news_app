import 'dart:async';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class newsView extends StatefulWidget {
  final String url;
  const newsView({Key? key, required this.url}) : super(key: key);

  @override
  _newsViewState createState() => _newsViewState();
}

class _newsViewState extends State<newsView> {
  final Completer<WebViewController> webController = Completer<
      WebViewController>(); //making a web view controller that will help us in showing the content as web view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AB News"),
      ),
      body: Container(
        child: WebView(
          initialUrl: widget.url, //url whose data we want to show
          javascriptMode: JavascriptMode
              .unrestricted, //so that js can handle he web view wihout an restrictions
          onWebViewCreated: (WebViewController WBcontroller) {
            //after the web view is ready then giving i he web controller this all helps in shwing he web view of thing which we wan to show
            setState(() {
              webController.complete(WBcontroller);
            });
          },
        ),
      ),
    );
  }
}
