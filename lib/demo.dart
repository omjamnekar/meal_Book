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
