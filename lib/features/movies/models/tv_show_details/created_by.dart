import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'created_by.g.dart';

@JsonSerializable()
class CreatedBy extends Equatable {
  final int? id;
  @JsonKey(name: 'credit_id')
  final String? creditId;
  final String? name;
  final int? gender;
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  const CreatedBy({
    this.id,
    this.creditId,
    this.name,
    this.gender,
    this.profilePath,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return _$CreatedByFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CreatedByToJson(this);

  CreatedBy copyWith({
    int? id,
    String? creditId,
    String? name,
    int? gender,
    String? profilePath,
  }) {
    return CreatedBy(
      id: id ?? this.id,
      creditId: creditId ?? this.creditId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      profilePath: profilePath ?? this.profilePath,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, creditId, name, gender, profilePath];
}
