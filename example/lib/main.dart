import 'package:flutter/material.dart';
import 'dart:async';

import 'package:native_dup2/native_dup2.dart';
import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ffi/src/utf8.dart';

Future<bool> shareFile(BuildContext context, String filePath) async {
  final box = context.findRenderObject() as RenderBox?;
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  if (await Permission.storage.isGranted) {

    await Share.shareFiles([filePath],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    return true;
  }
  return false;
}

///
///***************************************************************************** */
///this example shows how to redirect dart console ouput to a file
///
///tap the rundup will create a file and duplicate the file descriptor
///tap the show text will read the file and show its content
///note that the terminal control character cant be decode to readable character
///you can send the file by taping the share button
///***************************************************************************** */

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> runDup() async {
    // print(await getLocalPath());
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (await Permission.storage.isGranted) {
      var path = await getLocalPath();
      path = "$path/tmp.txt";

      // 3 is the file descriptor of android std output?
      int result = nativeRunDup2(path.toNativeUtf8(), 3);

      if (result < 0) {
        print("fail to runDup2");
        print(result);
      }
    }
  }

  String _text = "";

  Future<void> showText() async {
    var path = await getLocalPath();
    path = "$path/tmp.txt";
    String text = "";
    try {
      File file = File(path);
      final contents = await file.readAsBytes();

      inspect(contents);

      //simply filt out control charater
      for (var i = 0; i < contents.length; i++) {
        if (contents[i] < 32 || contents[i] > 127) contents[i] = 32;
      }
      text = String.fromCharCodes(contents);
      //the log wont be redirect?
      log(text);
    } catch (e) {
      inspect(e);
      text = "load failed";
    }

    // var temp=[2,3];
    // print(temp[3]);

    setState(() {
      _text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("Print out Test");

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: runDup, child: const Text("run Dup2")),
              ElevatedButton(
                  onPressed: showText, child: const Text("Show text")),
              ElevatedButton(
                  onPressed: () async {
                    var path = await getLocalPath();
                    path = "$path/tmp.txt";
                    shareFile(context, path);
                  },
                  child: const Icon(Icons.share)),
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  _text,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
