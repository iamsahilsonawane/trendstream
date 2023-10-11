import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.height,
  });

  final String imageUrl;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, dynamic)? errorWidget;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      image: CachedNetworkImageProvider(imageUrl),
      placeholderBuilder: OctoPlaceholder.blurHash(
        r"dOI.]h--}ln$]WNZIUWXI_I:ROof=|s=${R*R+$zNGbE",
      ),
      fit: fit,
      height: height,
      errorBuilder:
          errorWidget ?? (context, url, error) => const Icon(Icons.error),
    );
  }
}
