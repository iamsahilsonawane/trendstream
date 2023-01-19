import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'crew.dart';
import 'guest_star.dart';

part 'episode.g.dart';

@JsonSerializable()
class Episode extends Equatable {
  @JsonKey(name: 'air_date')
  final String? airDate;
  @JsonKey(name: 'episode_number')
  final int? episodeNumber;
  final List<Crew>? crew;
  @JsonKey(name: 'guest_stars')
  final List<GuestStar>? guestStars;
  final int? id;
  final String? name;
  final String? overview;
  @JsonKey(name: 'production_code')
  final String? productionCode;
  @JsonKey(name: 'season_number')
  final int? seasonNumber;
  @JsonKey(name: 'still_path')
  final String? stillPath;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;

  const Episode({
    this.airDate,
    this.episodeNumber,
    this.crew,
    this.guestStars,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.seasonNumber,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return _$EpisodeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);

  Episode copyWith({
    String? airDate,
    int? episodeNumber,
    List<Crew>? crew,
    List<GuestStar>? guestStars,
    int? id,
    String? name,
    String? overview,
    String? productionCode,
    int? seasonNumber,
    String? stillPath,
    double? voteAverage,
    int? voteCount,
  }) {
    return Episode(
      airDate: airDate ?? this.airDate,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      crew: crew ?? this.crew,
      guestStars: guestStars ?? this.guestStars,
      id: id ?? this.id,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      productionCode: productionCode ?? this.productionCode,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      stillPath: stillPath ?? this.stillPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      airDate,
      episodeNumber,
      crew,
      guestStars,
      id,
      name,
      overview,
      productionCode,
      seasonNumber,
      stillPath,
      voteAverage,
      voteCount,
    ];
  }
}
