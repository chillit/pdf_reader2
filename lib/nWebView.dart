import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' show parse;

class MyWebView extends StatelessWidget {
  final String url;
  final String path;

  MyWebView({required this.url, required this.path});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadHtmlFromUrl(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return WebView(
            initialUrl: '',
            onWebViewCreated: (WebViewController controller) {
              controller.loadUrl(Uri.dataFromString(
                '<html><head><style>body {font-size: 70px;}</style></head><body>${snapshot.data}</body></html>',
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              ).toString());
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<String> _loadHtmlFromUrl() async {
    final response = await http.get(Uri.parse(url));
    final document = parse(response.body);
    final element = document.querySelector(path);
    if (element != null) {
      return element.outerHtml;
    } else {
      return '<html><body>No data found</body></html>';
    }
  }
}