import 'package:json_annotation/json_annotation.dart';

import 'cast.dart';
import 'crew.dart';

part 'credits.g.dart';

@JsonSerializable()
class Credits {
  final List<Cast>? cast;
  final List<Crew>? crew;

  const Credits({this.cast, this.crew});

  @override
  String toString() => 'Credits(cast: $cast, crew: $crew)';

  factory Credits.fromJson(Map<String, dynamic> json) {
    return _$CreditsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CreditsToJson(this);

  Credits copyWith({
    List<Cast>? cast,
    List<Crew>? crew,
  }) {
    return Credits(
      cast: cast ?? this.cast,
      crew: crew ?? this.crew,
    );
  }
}
