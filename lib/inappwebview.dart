import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Inappwebview extends StatelessWidget {
  const Inappwebview({super.key});

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      onLoadStart: (controller, url) {
        
      },
    );
  }
}