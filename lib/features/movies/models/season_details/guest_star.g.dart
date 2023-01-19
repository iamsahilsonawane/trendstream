// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_star.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestStar _$GuestStarFromJson(Map<String, dynamic> json) => GuestStar(
      creditId: json['credit_id'] as String?,
      order: json['order'] as int?,
      character: json['character'] as String?,
      adult: json['adult'] as bool?,
      gender: json['gender'] as int?,
      id: json['id'] as int?,
      knownForDepartment: json['known_for_department'] as String?,
      name: json['name'] as String?,
      originalName: json['original_name'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$GuestStarToJson(GuestStar instance) => <String, dynamic>{
      'credit_id': instance.creditId,
      'order': instance.order,
      'character': instance.character,
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
    };
