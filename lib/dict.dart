import 'package:flutter/material.dart';
import 'package:pdf_reader2/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf_reader2/nWebView.dart';

Future main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();}

class dict extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('List of Cards'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("words").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("сөз жоқ"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  String word = snapshot.data!.docs[index].get("name");
                  return Card(
                      child: ListTile(
                          title: Text(word),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200.0,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                                      return AlertDialog(

                                                        title: Text('Заголовок диалога'),
                                                        content: Text("перевод"),
                                                      );
                                                    },
                                                  ),
                                                );
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
                          }));
                });
          },
        )
      ),
    );
  }
}