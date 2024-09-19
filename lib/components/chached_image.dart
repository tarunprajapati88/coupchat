import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;

  const ProfileImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
    )
        : Image.asset(
      'assets/avatar.png.png',
      fit: BoxFit.cover,
    );
  }
}