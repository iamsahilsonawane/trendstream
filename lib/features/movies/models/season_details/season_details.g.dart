// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeasonDetails _$SeasonDetailsFromJson(Map<String, dynamic> json) =>
    SeasonDetails(
      id: json['id'] as int?,
      airDate: json['air_date'] as String?,
      episodes: (json['episodes'] as List<dynamic>?)
          ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      seasonNumber: json['season_number'] as int?,
    );

Map<String, dynamic> _$SeasonDetailsToJson(SeasonDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'air_date': instance.airDate,
      'episodes': instance.episodes,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'season_number': instance.seasonNumber,
    };
