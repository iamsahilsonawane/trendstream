import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholder,
    this.height,
    this.blurHash,
  });

  final String imageUrl;
  final BoxFit fit;
  final String? blurHash;
  final Widget Function(BuildContext, Object, dynamic)? errorWidget;
  final Widget Function(BuildContext, String hash)? placeholder;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      image: CachedNetworkImageProvider(imageUrl),
      placeholderBuilder: blurHashPlaceholderBuilder(
        blurHash ?? r"dOI.]h--}ln$]WNZIUWXI_I:ROof=|s=${R*R+$zNGbE",
      ),
      fit: fit,
      height: height,
      errorBuilder:
          errorWidget ?? (context, url, error) => const Icon(Icons.error),
    );
  }

  OctoPlaceholderBuilder blurHashPlaceholderBuilder(String hash,
      {BoxFit? fit}) {
    return (context) =>
        placeholder?.call(context, hash) ??
        SizedBox.expand(
          child: Image(
            image: BlurHashImage(hash),
            fit: fit ?? BoxFit.cover,
          ),
        );
  }
}
