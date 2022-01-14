import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:webview_flutter/webview_flutter.dart';

// ignore: camel_case_types
class newsView extends StatefulWidget {
  final String url;
  const newsView({Key? key, required this.url}) : super(key: key);

  @override
  _newsViewState createState() => _newsViewState();
}

// ignore: camel_case_types
class _newsViewState extends State<newsView> {
  bool _isLoading = true;
  final Completer<WebViewController> webController = Completer<
      WebViewController>(); //making a web view controller that will help us in showing the content as web view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, //this make the content of body behind appbar too..and making it true as want to show rounded brder in appbar so...have to make color behind appbar same with body i will exend body from top itself

      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Title(
          color: Colors.black,
          child: const Text("Ab News"),
        ),
        centerTitle: true, //will make title appear on center
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        flexibleSpace: Container(
          //to give gradient we can use flexible
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.pink],
                  begin: Alignment.topRight,
                  end: Alignment.topLeft)),
        ),
      ),
      body: Stack(children: [
        WebView(
          initialUrl: widget.url, //url whose data we want to show
          javascriptMode: JavascriptMode
              .unrestricted, //so that js can handle he web view wihout an restrictions
          // ignore: non_constant_identifier_names
          onWebViewCreated: (WebViewController WBcontroller) {
            //after the web view is ready then giving i he web controller this all helps in shwing he web view of thing which we wan to show
            setState(() {
              webController.complete(WBcontroller);
            });
          },
          onPageFinished: (fin) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
        _isLoading
            ? const Center(
                child: SpinKitDualRing(
                  color: Colors.black,
                  size: 50.0,
                ),
              )
            : Container(), //otherwise show empty container
      ]),
    );
  }
}
