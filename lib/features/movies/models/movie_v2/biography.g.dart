// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Biography _$BiographyFromJson(Map<String, dynamic> json) => Biography(
      biography: json['biography'] as String?,
      id: json['id'] as num?,
      idInfoLanguage: json['id_info_language'] as num?,
      idPerson: json['id_person'] as num?,
    );

Map<String, dynamic> _$BiographyToJson(Biography instance) => <String, dynamic>{
      'biography': instance.biography,
      'id': instance.id,
      'id_info_language': instance.idInfoLanguage,
      'id_person': instance.idPerson,
    };
