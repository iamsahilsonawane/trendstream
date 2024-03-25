import 'package:equatable/equatable.dart';

import 'size.dart';

class UrlsImage extends Equatable {
  final int? id;
  final String? url;
  final Size? size;
  final int? idUrlImage;

  const UrlsImage({this.id, this.url, this.size, this.idUrlImage});

  factory UrlsImage.fromJson(Map<String, dynamic> json) => UrlsImage(
        id: json['id'] as int?,
        url: json['url'] as String?,
        size: json['size'] == null
            ? null
            : Size.fromJson(json['size'] as Map<String, dynamic>),
        idUrlImage: json['id_url_image'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'size': size?.toJson(),
        'id_url_image': idUrlImage,
      };

  UrlsImage copyWith({
    int? id,
    String? url,
    Size? size,
    int? idUrlImage,
  }) {
    return UrlsImage(
      id: id ?? this.id,
      url: url ?? this.url,
      size: size ?? this.size,
      idUrlImage: idUrlImage ?? this.idUrlImage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, url, size, idUrlImage];
}
