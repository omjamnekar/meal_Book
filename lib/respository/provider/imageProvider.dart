import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageDataProvider {
  static Future<List<String>> getImagePathsFromSharedPreferences(
      String category, String foodname) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = _generateSharedPreferencesKey(category, foodname);
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> saveImagePathsToSharedPreferences(
      String category, String foodname, List<String> imagePaths) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = _generateSharedPreferencesKey(category, foodname);
    prefs.setStringList(key, imagePaths);
  }

  static String _generateSharedPreferencesKey(
      String category, String foodname) {
    return 'imagePaths_${category}_${foodname}';
  }

  static Future<List<String>> fetchImagePaths(
      String category, String foodname) async {
    // Check if image paths are stored in SharedPreferences
    List<String> cachedImagePaths =
        await getImagePathsFromSharedPreferences(category, foodname);
    print(cachedImagePaths);
    if (cachedImagePaths.isNotEmpty) {
      // If paths are available in SharedPreferences, return them
      return cachedImagePaths;
    } else {
      // Fetch data from Firebase Storage
      try {
        Reference storageReference = FirebaseStorage.instance.ref().child(
            "products/${category.toLowerCase().replaceAll(" ", "")}/${foodname}");

        ListResult result = await storageReference.listAll();
        List<String> imagePaths = [];

        for (Reference ref in result.items) {
          String url = await ref.getDownloadURL();
          imagePaths.add(url);
        }

        // Save image paths to SharedPreferences
        await saveImagePathsToSharedPreferences(category, foodname, imagePaths);

        return imagePaths;
      } catch (e, stackTrace) {
        print("Error getting image URL: $e");
        print("Stack Trace: $stackTrace");
        return [];
      }
    }
  }
}
