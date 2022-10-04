import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'guest_star.g.dart';

@JsonSerializable()
class GuestStar extends Equatable {
  @JsonKey(name: 'credit_id')
  final String? creditId;
  final int? order;
  final String? character;
  final bool? adult;
  final int? gender;
  final int? id;
  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;
  final String? name;
  @JsonKey(name: 'original_name')
  final String? originalName;
  final double? popularity;
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  const GuestStar({
    this.creditId,
    this.order,
    this.character,
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
  });

  factory GuestStar.fromJson(Map<String, dynamic> json) {
    return _$GuestStarFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GuestStarToJson(this);

  GuestStar copyWith({
    String? creditId,
    int? order,
    String? character,
    bool? adult,
    int? gender,
    int? id,
    String? knownForDepartment,
    String? name,
    String? originalName,
    double? popularity,
    String? profilePath,
  }) {
    return GuestStar(
      creditId: creditId ?? this.creditId,
      order: order ?? this.order,
      character: character ?? this.character,
      adult: adult ?? this.adult,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      popularity: popularity ?? this.popularity,
      profilePath: profilePath ?? this.profilePath,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      creditId,
      order,
      character,
      adult,
      gender,
      id,
      knownForDepartment,
      name,
      originalName,
      popularity,
      profilePath,
    ];
  }
}
