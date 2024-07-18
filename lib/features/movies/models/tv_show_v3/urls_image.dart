import 'package:equatable/equatable.dart';

import 'size.dart';

class UrlsImage extends Equatable {
  final num? id;
  final num? idUrlImage;
  final Size? size;
  final String? url;
  final String? blurHash;

  const UrlsImage(
      {this.id,
      this.idUrlImage,
      this.size,
      this.url,
      this.blurHash}); // Update this line

  factory UrlsImage.fromJson(Map<String, dynamic> json) => UrlsImage(
        id: json['id'] as num?,
        idUrlImage: json['id_url_image'] as num?,
        size: json['size'] == null
            ? null
            : Size.fromJson(json['size'] as Map<String, dynamic>),
        url: json['url'] as String?,
        blurHash: json['blur_hash'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_url_image': idUrlImage,
        'size': size?.toJson(),
        'url': url,
        'blur_hash': blurHash,
      };

  UrlsImage copyWith({
    num? id,
    num? idUrlImage,
    Size? size,
    String? url,
    String? blurHash,
  }) {
    return UrlsImage(
        id: id ?? this.id,
        idUrlImage: idUrlImage ?? this.idUrlImage,
        size: size ?? this.size,
        url: url ?? this.url,
        blurHash: blurHash ?? this.blurHash);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, idUrlImage, size, url, blurHash];
}
