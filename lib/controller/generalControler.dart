import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RecommendedData extends GetxController {
  Future<List<String>> imageURlList() async {
    try {
      final storageReference =
          FirebaseStorage.instance.ref().child('subCombo/');
      final ListResult result = await storageReference.listAll();
      final List<String> imageUrlList = [];

      for (final ref in result.items) {
        final url = await ref.getDownloadURL();
        imageUrlList.add(url);
      }

      return imageUrlList;
    } catch (e) {
      print('Error fetching image URLs: $e');
      return [];
    }
  }
}

class GeneralData extends GetxController {
  Future<List<String>> imageURlList() async {
    try {
      final storageReference = FirebaseStorage.instance.ref().child('genaral/');
      final ListResult result = await storageReference.listAll();
      final List<String> imageUrlList = [];

      for (final ref in result.items) {
        final url = await ref.getDownloadURL();
        imageUrlList.add(url);
      }

      return imageUrlList;
    } catch (e) {
      print('Error fetching image URLs: $e');
      return [];
    }
  }
}
