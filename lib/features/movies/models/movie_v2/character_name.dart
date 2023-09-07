import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character_name.g.dart';

@JsonSerializable()
class CharacterName extends Equatable {
  @JsonKey(name: 'character_name')
  final String? characterName;
  final num? id;
  @JsonKey(name: 'id_cast')
  final num? idCast;
  @JsonKey(name: 'id_info_language')
  final num? idInfoLanguage;

  const CharacterName({
    this.characterName,
    this.id,
    this.idCast,
    this.idInfoLanguage,
  });

  factory CharacterName.fromJson(Map<String, dynamic> json) {
    return _$CharacterNameFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CharacterNameToJson(this);

  CharacterName copyWith({
    String? characterName,
    num? id,
    num? idCast,
    num? idInfoLanguage,
  }) {
    return CharacterName(
      characterName: characterName ?? this.characterName,
      id: id ?? this.id,
      idCast: idCast ?? this.idCast,
      idInfoLanguage: idInfoLanguage ?? this.idInfoLanguage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [characterName, id, idCast, idInfoLanguage];
}
