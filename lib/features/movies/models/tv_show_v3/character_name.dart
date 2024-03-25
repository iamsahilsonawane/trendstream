import 'package:equatable/equatable.dart';

class CharacterName extends Equatable {
  final String? characterName;
  final num? id;
  final num? idCast;
  final num? idInfoLanguage;

  const CharacterName({
    this.characterName,
    this.id,
    this.idCast,
    this.idInfoLanguage,
  });

  factory CharacterName.fromJson(Map<String, dynamic> json) => CharacterName(
        characterName: json['character_name'] as String?,
        id: json['id'] as num?,
        idCast: json['id_cast'] as num?,
        idInfoLanguage: json['id_info_language'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'character_name': characterName,
        'id': id,
        'id_cast': idCast,
        'id_info_language': idInfoLanguage,
      };

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
