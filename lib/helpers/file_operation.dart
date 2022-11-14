import 'dart:async';
import 'dart:io';
import 'package:contacts_list/model/contacts.dart';
import 'package:contacts_list/model/control_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

// 5. This class handles basic file operations such as save into file
// and read from file

class FileOperation {
  // GET LOCAL PATH
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // GET LOCAL FILE
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contacts.txt');
  }

  static Future<void> write(String data) async {
    final file = await _localFile;
    file.writeAsString(data);
  }

  static Future<void> read(var reload) async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      String json = contents;
      ContactsManager.data = dataFromJson(contents);
      // while (ContactsManager.data.contact!.length > 3) {
      //   ContactsManager.data.contact?.removeLast();
      //   FileOperation.write(dataToJson(ContactsManager.data));
      // }
      debugPrint("----> $contents");
      reload();
    } catch (e) {
      // If encountering an error, return 0
      debugPrint("----> --$e");
    }
  }
}
