import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Preview",
          style: TextStyle(color: Colors.white, fontFamily: 'PlaywriteCU'),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
