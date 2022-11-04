import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'title.g.dart';

@JsonSerializable()
class ProgramTitle extends Equatable {
  final String? value;
  final String? lang;

  const ProgramTitle({this.value, this.lang});

  factory ProgramTitle.fromJson(Map<String, dynamic> json) =>
      _$ProgramTitleFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramTitleToJson(this);

  ProgramTitle copyWith({
    String? value,
    String? lang,
  }) {
    return ProgramTitle(
      value: value ?? this.value,
      lang: lang ?? this.lang,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [value, lang];
}
