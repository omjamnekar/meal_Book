import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  final String imageUrl;

  ImageLoader({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            CircularProgressIndicator(), // Placeholder widget while loading
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}

// Future<void> downloadAndSaveFile(String fileName) async {
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   final ref = storage.ref('your_storage_path/$fileName');

//   try {
//     final String downloadUrl = await ref.getDownloadURL();
//     // Use the ImageLoader widget to display the image with caching
//     // You can place this widget wherever you need to display the image
//     ImageLoader(imageUrl: downloadUrl);
//     print('File downloaded and displayed: $downloadUrl');
//   } catch (e) {
//     print('Error downloading file: $e');
//   }
// }
