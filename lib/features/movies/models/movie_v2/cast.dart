import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'character_name.dart';
import 'person.dart';
import 'urls_image.dart';

part 'cast.g.dart';

@JsonSerializable()
class Cast extends Equatable {
  final bool? adult;
  @JsonKey(name: 'cast_id')
  final num? castId;
  final List<CharacterName>? characterNames;
  @JsonKey(name: 'character_name')
  final String? characterName;
  @JsonKey(name: 'credit_id')
  final String? creditId;
  final num? id;
  @JsonKey(name: 'id_person')
  final num? idPerson;
  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;
  final String? name;
  final num? order;
  @JsonKey(name: 'original_name')
  final String? originalName;
  final Person? person;
  final num? popularity;
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  @JsonKey(name: 'register_date')
  final String? registerDate;
  @JsonKey(name: 'urls_image')
  final List<UrlsImage>? urlsImage;

  const Cast({
    this.adult,
    this.castId,
    this.characterNames,
    this.characterName,
    this.creditId,
    this.id,
    this.idPerson,
    this.knownForDepartment,
    this.name,
    this.order,
    this.originalName,
    this.person,
    this.popularity,
    this.profilePath,
    this.registerDate,
    this.urlsImage,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  Map<String, dynamic> toJson() => _$CastToJson(this);

  Cast copyWith({
    bool? adult,
    num? castId,
    List<CharacterName>? characterNames,
    String? characterName,
    String? creditId,
    num? id,
    num? idPerson,
    String? knownForDepartment,
    String? name,
    num? order,
    String? originalName,
    Person? person,
    num? popularity,
    String? profilePath,
    String? registerDate,
    List<UrlsImage>? urlsImage,
  }) {
    return Cast(
      adult: adult ?? this.adult,
      castId: castId ?? this.castId,
      characterNames: characterNames ?? this.characterNames,
      characterName: characterName ?? this.characterName,
      creditId: creditId ?? this.creditId,
      id: id ?? this.id,
      idPerson: idPerson ?? this.idPerson,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
      name: name ?? this.name,
      order: order ?? this.order,
      originalName: originalName ?? this.originalName,
      person: person ?? this.person,
      popularity: popularity ?? this.popularity,
      profilePath: profilePath ?? this.profilePath,
      registerDate: registerDate ?? this.registerDate,
      urlsImage: urlsImage ?? this.urlsImage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      adult,
      castId,
      characterNames,
      characterName,
      creditId,
      id,
      idPerson,
      knownForDepartment,
      name,
      order,
      originalName,
      person,
      popularity,
      profilePath,
      registerDate,
      urlsImage,
    ];
  }
}
