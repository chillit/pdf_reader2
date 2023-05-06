import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader2/TextScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pdf_reader2/dict.dart';

Future main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
  ));}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'My App',
      home: TextFilePicker(),
      debugShowCheckedModeBanner: false,

    );
  }
}

class TextFilePicker extends StatefulWidget {
  @override
  _TextFilePickerState createState() => _TextFilePickerState();
}

class _TextFilePickerState extends State<TextFilePicker> {
  String _fileContents = "";

  Future<void> _loadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      String contents = await file.readAsString();
      setState(() {
        _fileContents = contents;
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TextScreen(text: _fileContents)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All resumes"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => dict()),
                );
              },
              icon: Icon(Icons.book))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _loadFile,
              child: Text('Select Text File'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
