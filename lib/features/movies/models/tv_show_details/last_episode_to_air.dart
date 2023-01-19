import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'last_episode_to_air.g.dart';

@JsonSerializable()
class LastEpisodeToAir extends Equatable {
  @JsonKey(name: 'air_date')
  final String? airDate;
  @JsonKey(name: 'episode_number')
  final int? episodeNumber;
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

  const LastEpisodeToAir({
    this.airDate,
    this.episodeNumber,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.seasonNumber,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
  });

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) {
    return _$LastEpisodeToAirFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LastEpisodeToAirToJson(this);

  LastEpisodeToAir copyWith({
    String? airDate,
    int? episodeNumber,
    int? id,
    String? name,
    String? overview,
    String? productionCode,
    int? seasonNumber,
    String? stillPath,
    double? voteAverage,
    int? voteCount,
  }) {
    return LastEpisodeToAir(
      airDate: airDate ?? this.airDate,
      episodeNumber: episodeNumber ?? this.episodeNumber,
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
