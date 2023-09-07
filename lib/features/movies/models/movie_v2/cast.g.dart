// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cast _$CastFromJson(Map<String, dynamic> json) => Cast(
      adult: json['adult'] as bool?,
      castId: json['cast_id'] as num?,
      characterNames: (json['characterNames'] as List<dynamic>?)
          ?.map((e) => CharacterName.fromJson(e as Map<String, dynamic>))
          .toList(),
      characterName: json['character_name'] as String?,
      creditId: json['credit_id'] as String?,
      id: json['id'] as num?,
      idPerson: json['id_person'] as num?,
      knownForDepartment: json['known_for_department'] as String?,
      name: json['name'] as String?,
      order: json['order'] as num?,
      originalName: json['original_name'] as String?,
      person: json['person'] == null
          ? null
          : Person.fromJson(json['person'] as Map<String, dynamic>),
      popularity: json['popularity'] as num?,
      profilePath: json['profile_path'] as String?,
      registerDate: json['register_date'] as String?,
      urlsImage: (json['urls_image'] as List<dynamic>?)
          ?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CastToJson(Cast instance) => <String, dynamic>{
      'adult': instance.adult,
      'cast_id': instance.castId,
      'characterNames': instance.characterNames,
      'character_name': instance.characterName,
      'credit_id': instance.creditId,
      'id': instance.id,
      'id_person': instance.idPerson,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'order': instance.order,
      'original_name': instance.originalName,
      'person': instance.person,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'register_date': instance.registerDate,
      'urls_image': instance.urlsImage,
    };
