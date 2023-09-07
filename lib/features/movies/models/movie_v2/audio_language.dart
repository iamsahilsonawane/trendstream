import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio_language.g.dart';

@JsonSerializable()
class AudioLanguage extends Equatable {
  final num? id;
  final String? name;

  const AudioLanguage({this.id, this.name});

  factory AudioLanguage.fromJson(Map<String, dynamic> json) {
    return _$AudioLanguageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AudioLanguageToJson(this);

  AudioLanguage copyWith({
    num? id,
    String? name,
  }) {
    return AudioLanguage(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
