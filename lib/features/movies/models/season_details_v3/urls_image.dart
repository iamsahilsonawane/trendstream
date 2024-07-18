import 'package:equatable/equatable.dart';

import 'size.dart';

class UrlsImage extends Equatable {
  final int? id;
  final String? url;
  final String? blurHash;
  final Size? size;
  final int? idUrlImage;

  const UrlsImage(
      {this.id, this.url, this.blurHash, this.size, this.idUrlImage});

  factory UrlsImage.fromJson(Map<String, dynamic> json) => UrlsImage(
        id: json['id'] as int?,
        url: json['url'] as String?,
        blurHash: json['blur_hash'] as String?,
        size: json['size'] == null
            ? null
            : Size.fromJson(json['size'] as Map<String, dynamic>),
        idUrlImage: json['id_url_image'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'blur_hash': blurHash,
        'size': size?.toJson(),
        'id_url_image': idUrlImage,
      };

  UrlsImage copyWith({
    int? id,
    String? url,
    String? blurHash,
    Size? size,
    int? idUrlImage,
  }) {
    return UrlsImage(
      id: id ?? this.id,
      url: url ?? this.url,
      blurHash: blurHash ?? this.blurHash,
      size: size ?? this.size,
      idUrlImage: idUrlImage ?? this.idUrlImage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, url, size, blurHash, idUrlImage];
}
