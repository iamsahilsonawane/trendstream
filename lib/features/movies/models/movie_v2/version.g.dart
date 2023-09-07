// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
      audioLanguage: json['audioLanguage'] == null
          ? null
          : AudioLanguage.fromJson(
              json['audioLanguage'] as Map<String, dynamic>),
      codec: json['codec'] == null
          ? null
          : Codec.fromJson(json['codec'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
      id: json['id'] as num?,
      idMovie: json['id_movie'] as num?,
      quality: json['quality'] == null
          ? null
          : Quality.fromJson(json['quality'] as Map<String, dynamic>),
      url: json['url'] as String?,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'audioLanguage': instance.audioLanguage,
      'codec': instance.codec,
      'comment': instance.comment,
      'id': instance.id,
      'id_movie': instance.idMovie,
      'quality': instance.quality,
      'url': instance.url,
      'version': instance.version,
    };
