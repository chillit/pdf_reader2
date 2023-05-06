import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader2/text.dart';
import 'package:translator/translator.dart';
import 'package:pdf_reader2/nWebView.dart';

class TextScreen extends StatefulWidget {
  final String text;

  TextScreen({Key? key, required this.text}) : super(key: key);

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String traslatedword = "";
  bool _contentChanged = false;

  void _changeContent() {
    setState(() {
      _contentChanged = !_contentChanged;
    });
  }
  String info = "choose the web site";
  final PageController _pageController = PageController();
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _totalPages = _splitTextIntoPages().length;
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    int currentPage = (_pageController.page?.floor() ?? 0) + 1;
    setState(() {
      _currentPage = currentPage;
    });
  }

  List<String> _splitTextIntoPages({int characterCount = 1000}) {
    List<String> pages = [];

    for (int i = 0; i < widget.text.length; i += characterCount) {
      int endIndex = i + characterCount;
      String page = widget.text.substring(i, endIndex < widget.text.length ? endIndex : widget.text.length);
      pages.add(page);
    }

    return pages;
  }

  Widget _buildPage(String pageText) {
    return SingleChildScrollView(
      child:  Center(
        child: ClickableText(
          text: pageText,
          style: TextStyle(fontSize: 20, color: Colors.black),
          onWordTap: (String word) {
            word = word.replaceAll(RegExp(r'[^АаӘәБбВвГгҒғДдЕеЁёЖжЗзИиЙйКкҚқЛлМмНнҢңОоӨөПпРрСсТтУуҰұҮүФфХхҺһЦцЧчШшЩщЪъЫыІіЬьЭэЮюЯя]'), '');
            print(word);
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200.0,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Select content:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.access_alarm),
                              title: Text('Дифиниция'),
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return AlertDialog(
                                        title: Text('Заголовок диалога'),
                                        content: MyWebView(url: 'https://sozdikqor.kz/search?q=${word}', path: 'body > section > div > div > div.col-lg-8 > div'),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.accessibility),
                              title: Text('Орысша дифиниция'),
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return AlertDialog(
                                        title: Text('Заголовок диалога'),
                                        content: MyWebView(url: 'https://sozdik.kz/kk/dictionary/translate/kk/ru/${word}/', path: '#dictionary_translate_article_translation'),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text('Аударма'),
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return const AlertDialog(

                                        title: Text('Заголовок диалога'),
                                        content: Text("перевод"),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.book),
                              title: Text('сөздікке қосу'),
                              onTap: () {
                                createUser(name: word);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    List<String> pages = _splitTextIntoPages();

    return Scaffold(
      appBar: AppBar(
        title: Text('Text from PDF - Page $_currentPage of $_totalPages'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return _buildPage(pages[index]);
        },
        itemCount: pages.length,
      ),
    );

  }
}

Future createUser({required String name}) async{
  final docUser = FirebaseFirestore.instance.collection("words").doc(name);
  final json = {
    'name': name,
  };
  await docUser.set(json);
}
