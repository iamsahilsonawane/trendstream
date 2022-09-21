import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spoken_language.g.dart';

@JsonSerializable()
class SpokenLanguage extends Equatable {
  @JsonKey(name: 'iso_639_1')
  final String? iso6391;
  final String? name;

  const SpokenLanguage({this.iso6391, this.name});

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return _$SpokenLanguageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);

  SpokenLanguage copyWith({
    String? iso6391,
    String? name,
  }) {
    return SpokenLanguage(
      iso6391: iso6391 ?? this.iso6391,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [iso6391, name];
}
