// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      adult: json['adult'] as bool?,
      biographies: (json['biographies'] as List<dynamic>?)
          ?.map((e) => Biography.fromJson(e as Map<String, dynamic>))
          .toList(),
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathDay: json['death_day'] as String?,
      gender: json['gender'] as num?,
      id: json['id'] as num?,
      idPersonTmdb: json['id_person_tmdb'] as num?,
      imdbId: json['imdb_id'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      name: json['name'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      popularity: json['popularity'] as num?,
      profilePath: json['profile_path'] as String?,
      registerDate: json['register_date'] as String?,
      suggestedName: json['suggested_name'] as String?,
      urlsImage: (json['urls_image'] as List<dynamic>?)
          ?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'adult': instance.adult,
      'biographies': instance.biographies,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'death_day': instance.deathDay,
      'gender': instance.gender,
      'id': instance.id,
      'id_person_tmdb': instance.idPersonTmdb,
      'imdb_id': instance.imdbId,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'place_of_birth': instance.placeOfBirth,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'register_date': instance.registerDate,
      'suggested_name': instance.suggestedName,
      'urls_image': instance.urlsImage,
    };
