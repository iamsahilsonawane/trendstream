// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backdrop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Backdrop _$BackdropFromJson(Map<String, dynamic> json) => Backdrop(
      active: json['active'] as bool?,
      aspectRatio: json['aspect_ratio'] as num?,
      filePath: json['file_path'] as String?,
      height: json['height'] as num?,
      id: json['id'] as num?,
      idImage: json['id_image'] as num?,
      iso6391: json['iso_639_1'] as String?,
      params: json['params'],
      suggestedName: json['suggested_name'] as String?,
      urlsImage: (json['urls_image'] as List<dynamic>?)
          ?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      voteAverage: json['vote_average'] as num?,
      voteCount: json['vote_count'] as num?,
      width: json['width'] as num?,
    );

Map<String, dynamic> _$BackdropToJson(Backdrop instance) => <String, dynamic>{
      'active': instance.active,
      'aspect_ratio': instance.aspectRatio,
      'file_path': instance.filePath,
      'height': instance.height,
      'id': instance.id,
      'id_image': instance.idImage,
      'iso_639_1': instance.iso6391,
      'params': instance.params,
      'suggested_name': instance.suggestedName,
      'urls_image': instance.urlsImage,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'width': instance.width,
    };
