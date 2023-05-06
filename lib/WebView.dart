import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url;

  MyWebView({required this.url});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

String word = words[i].replaceAll(RegExp(r'[^АаӘәБбВвГгҒғДдЕеЁёЖжЗзИиЙйКкҚқЛлМмНнҢңОоӨөПпРрСсТтУуҰұҮүФфХхҺһЦцЧчШшЩщЪъЫыІіЬьЭэЮюЯя]'), '');
body > section > div > div > div.col-lg-8 > div > div > ul
MyWebView(url: 'https://sozdikqor.kz/search?q=${word}', path: 'body > section > div > div > div.col-lg-8 > div');
MyWebView(url: 'https://sozdik.kz/kk/dictionary/translate/kk/ru/', path: '#dictionary_translate_article_translation');