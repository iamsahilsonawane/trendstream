// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosResult _$VideosResultFromJson(Map<String, dynamic> json) => VideosResult(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => MovieVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VideosResultToJson(VideosResult instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
