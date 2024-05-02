import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class FireStoreDataBase {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<List<String>>> listFiles() async {
    try {
      firebase_storage.ListResult result =
          await storage.ref("combos/").listAll();
      firebase_storage.ListResult result2 =
          await storage.ref("subCombo/").listAll();

      List<String> fileNames = [];
      List<String> fileNames2 = [];

      result.items.forEach((firebase_storage.Reference ref) {
        fileNames.add(ref.name);
      });

      result2.items.forEach((firebase_storage.Reference ref) {
        fileNames2.add(ref.name);
      });

      print(fileNames);

      return [fileNames, fileNames2];
    } catch (e) {
      print("Error fetching files: $e");
      return []; // or handle error as appropriate
    }
  }

  Future<List<String>> downloadURLs() async {
    try {
      final fileNames = await listFiles();
      List<String> downloadURLs = [];

      for (String fileName in fileNames[0]) {
        String url = await storage.ref("combos/$fileName").getDownloadURL();
        downloadURLs.add(url);
      }

      return downloadURLs;
    } catch (e) {
      print("Error fetching download URLs: $e");
      return []; // or handle error as appropriate
    }
  }

  Future<List<String>> downloadURLs2() async {
    try {
      final fileNames = await listFiles();
      List<String> downloadURLs = [];

      for (String fileName in fileNames[1]) {
        String url = await storage.ref("subCombo/$fileName").getDownloadURL();
        downloadURLs.add(url);
      }

      print(downloadURLs);
      return downloadURLs;
    } catch (e) {
      print("Error fetching download URLs for subCombo: $e");
      return []; // or handle error as appropriate
    }
  }
}
