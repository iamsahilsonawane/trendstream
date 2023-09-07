import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'size.dart';

part 'urls_image.g.dart';

@JsonSerializable()
class UrlsImage extends Equatable {
  final num? id;
  @JsonKey(name: 'id_url_image')
  final num? idUrlImage;
  final Size? size;
  final String? url;

  const UrlsImage({this.id, this.idUrlImage, this.size, this.url});

  factory UrlsImage.fromJson(Map<String, dynamic> json) {
    return _$UrlsImageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UrlsImageToJson(this);

  UrlsImage copyWith({
    num? id,
    num? idUrlImage,
    Size? size,
    String? url,
  }) {
    return UrlsImage(
      id: id ?? this.id,
      idUrlImage: idUrlImage ?? this.idUrlImage,
      size: size ?? this.size,
      url: url ?? this.url,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, idUrlImage, size, url];
}
