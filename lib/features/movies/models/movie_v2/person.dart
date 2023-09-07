import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'biography.dart';
import 'urls_image.dart';

part 'person.g.dart';

@JsonSerializable()
class Person extends Equatable {
  final bool? adult;
  final List<Biography>? biographies;
  final String? biography;
  final String? birthday;
  @JsonKey(name: 'death_day')
  final String? deathDay;
  final num? gender;
  final num? id;
  @JsonKey(name: 'id_person_tmdb')
  final num? idPersonTmdb;
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;
  final String? name;
  @JsonKey(name: 'place_of_birth')
  final String? placeOfBirth;
  final num? popularity;
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  @JsonKey(name: 'register_date')
  final String? registerDate;
  @JsonKey(name: 'suggested_name')
  final String? suggestedName;
  @JsonKey(name: 'urls_image')
  final List<UrlsImage>? urlsImage;

  const Person({
    this.adult,
    this.biographies,
    this.biography,
    this.birthday,
    this.deathDay,
    this.gender,
    this.id,
    this.idPersonTmdb,
    this.imdbId,
    this.knownForDepartment,
    this.name,
    this.placeOfBirth,
    this.popularity,
    this.profilePath,
    this.registerDate,
    this.suggestedName,
    this.urlsImage,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return _$PersonFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  Person copyWith({
    bool? adult,
    List<Biography>? biographies,
    String? biography,
    String? birthday,
    String? deathDay,
    num? gender,
    num? id,
    num? idPersonTmdb,
    String? imdbId,
    String? knownForDepartment,
    String? name,
    String? placeOfBirth,
    num? popularity,
    String? profilePath,
    String? registerDate,
    String? suggestedName,
    List<UrlsImage>? urlsImage,
  }) {
    return Person(
      adult: adult ?? this.adult,
      biographies: biographies ?? this.biographies,
      biography: biography ?? this.biography,
      birthday: birthday ?? this.birthday,
      deathDay: deathDay ?? this.deathDay,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      idPersonTmdb: idPersonTmdb ?? this.idPersonTmdb,
      imdbId: imdbId ?? this.imdbId,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
      name: name ?? this.name,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      popularity: popularity ?? this.popularity,
      profilePath: profilePath ?? this.profilePath,
      registerDate: registerDate ?? this.registerDate,
      suggestedName: suggestedName ?? this.suggestedName,
      urlsImage: urlsImage ?? this.urlsImage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      adult,
      biographies,
      biography,
      birthday,
      deathDay,
      gender,
      id,
      idPersonTmdb,
      imdbId,
      knownForDepartment,
      name,
      placeOfBirth,
      popularity,
      profilePath,
      registerDate,
      suggestedName,
      urlsImage,
    ];
  }
}
