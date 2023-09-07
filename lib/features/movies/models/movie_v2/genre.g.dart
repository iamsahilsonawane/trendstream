// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Genre _$GenreFromJson(Map<String, dynamic> json) => Genre(
      id: json['id'] as num?,
      idGenre: json['id_genre'] as num?,
      idInfoLanguage: json['id_info_language'] as num?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
      'id': instance.id,
      'id_genre': instance.idGenre,
      'id_info_language': instance.idInfoLanguage,
      'name': instance.name,
    };
