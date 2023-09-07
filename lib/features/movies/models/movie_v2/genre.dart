import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable()
class Genre extends Equatable {
  final num? id;
  @JsonKey(name: 'id_genre')
  final num? idGenre;
  @JsonKey(name: 'id_info_language')
  final num? idInfoLanguage;
  final String? name;

  const Genre({this.id, this.idGenre, this.idInfoLanguage, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);

  Genre copyWith({
    num? id,
    num? idGenre,
    num? idInfoLanguage,
    String? name,
  }) {
    return Genre(
      id: id ?? this.id,
      idGenre: idGenre ?? this.idGenre,
      idInfoLanguage: idInfoLanguage ?? this.idInfoLanguage,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, idGenre, idInfoLanguage, name];
}
