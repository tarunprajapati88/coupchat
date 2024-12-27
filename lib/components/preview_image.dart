import 'package:coupchat/components/themes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return Scaffold(
      backgroundColor: themeColors[1],
      appBar: AppBar(
        title:  Text(
          "Image Preview",
          style: TextStyle(color: themeColors[6], fontFamily: 'PlaywriteCU'),
        ),
        backgroundColor: themeColors[0],
        iconTheme: IconThemeData(color: themeColors[6]),
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
