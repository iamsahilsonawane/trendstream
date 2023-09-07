import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'biography.g.dart';

@JsonSerializable()
class Biography extends Equatable {
  final String? biography;
  final num? id;
  @JsonKey(name: 'id_info_language')
  final num? idInfoLanguage;
  @JsonKey(name: 'id_person')
  final num? idPerson;

  const Biography({
    this.biography,
    this.id,
    this.idInfoLanguage,
    this.idPerson,
  });

  factory Biography.fromJson(Map<String, dynamic> json) {
    return _$BiographyFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BiographyToJson(this);

  Biography copyWith({
    String? biography,
    num? id,
    num? idInfoLanguage,
    num? idPerson,
  }) {
    return Biography(
      biography: biography ?? this.biography,
      id: id ?? this.id,
      idInfoLanguage: idInfoLanguage ?? this.idInfoLanguage,
      idPerson: idPerson ?? this.idPerson,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [biography, id, idInfoLanguage, idPerson];
}
