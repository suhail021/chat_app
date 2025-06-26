import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  const Webview({super.key});

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  late final WebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: webViewController,
    
    ));
  }
}
