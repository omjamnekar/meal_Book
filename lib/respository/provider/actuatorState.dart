import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageListModel {
  final List<String> imageUrls;
  final bool dataCame;

  ImageListModel(this.imageUrls, this.dataCame);
}

class ImageListNotifier extends StateNotifier<ImageListModel> {
  ImageListNotifier([ImageListModel? value])
      : super(value ?? ImageListModel([], false));

  Future<void> fetchData() async {
    final storageRef = FirebaseStorage.instance.ref('combos');

    try {
      final ListResult result = await storageRef.listAll();

      final List<String> imageUrls = [];

      for (var item in result.items) {
        final url = await item.getDownloadURL();
        imageUrls.add(url);
      }

      state = ImageListModel(imageUrls, true);
    } catch (error) {
      state = ImageListModel([], false);
    }
  }

  Future<void> _saveDataLocally(List<String> imageUrls) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('imageUrls', imageUrls);
    } catch (error) {
      print('Error saving data locally: $error');
    }
  }

  ImageListModel get currentImageState => state;
}

final imageListProvider =
    StateNotifierProvider<ImageListNotifier, ImageListModel>((ref) {
  return ImageListNotifier();
});
