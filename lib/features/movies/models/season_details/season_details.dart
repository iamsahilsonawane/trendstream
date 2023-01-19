import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'episode.dart';

part 'season_details.g.dart';

@JsonSerializable()
class SeasonDetails extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'air_date')
  final String? airDate;
  final List<Episode>? episodes;
  final String? name;
  final String? overview;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'season_number')
  final int? seasonNumber;

  const SeasonDetails({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
  });

  factory SeasonDetails.fromJson(Map<String, dynamic> json) {
    return _$SeasonDetailsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SeasonDetailsToJson(this);

  SeasonDetails copyWith({
    int? id,
    String? airDate,
    List<Episode>? episodes,
    String? name,
    String? overview,
    String? posterPath,
    int? seasonNumber,
  }) {
    return SeasonDetails(
      id: id ?? this.id,
      airDate: airDate ?? this.airDate,
      episodes: episodes ?? this.episodes,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      seasonNumber: seasonNumber ?? this.seasonNumber,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      airDate,
      episodes,
      name,
      overview,
      posterPath,
      seasonNumber,
    ];
  }
}
