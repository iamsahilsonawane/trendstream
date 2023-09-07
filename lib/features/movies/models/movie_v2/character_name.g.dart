// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterName _$CharacterNameFromJson(Map<String, dynamic> json) =>
    CharacterName(
      characterName: json['character_name'] as String?,
      id: json['id'] as num?,
      idCast: json['id_cast'] as num?,
      idInfoLanguage: json['id_info_language'] as num?,
    );

Map<String, dynamic> _$CharacterNameToJson(CharacterName instance) =>
    <String, dynamic>{
      'character_name': instance.characterName,
      'id': instance.id,
      'id_cast': instance.idCast,
      'id_info_language': instance.idInfoLanguage,
    };
