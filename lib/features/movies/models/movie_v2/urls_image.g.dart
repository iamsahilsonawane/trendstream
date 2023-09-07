// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urls_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UrlsImage _$UrlsImageFromJson(Map<String, dynamic> json) => UrlsImage(
      id: json['id'] as num?,
      idUrlImage: json['id_url_image'] as num?,
      size: json['size'] == null
          ? null
          : Size.fromJson(json['size'] as Map<String, dynamic>),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$UrlsImageToJson(UrlsImage instance) => <String, dynamic>{
      'id': instance.id,
      'id_url_image': instance.idUrlImage,
      'size': instance.size,
      'url': instance.url,
    };
