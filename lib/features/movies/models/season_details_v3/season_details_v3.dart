import 'package:equatable/equatable.dart';

import 'episode.dart';
import 'poster.dart';

class SeasonDetailsV3 extends Equatable {
  final int? id;
  final String? name;
  final String? overview;
  final int? seasonNumber;
  final int? numberOfEpisodes;
  final String? airDate;
  final List<Episode>? episodes;
  final Poster? poster;

  const SeasonDetailsV3({
    this.id,
    this.name,
    this.overview,
    this.seasonNumber,
    this.numberOfEpisodes,
    this.airDate,
    this.episodes,
    this.poster,
  });

  factory SeasonDetailsV3.fromJson(Map<String, dynamic> json) {
    return SeasonDetailsV3(
      id: json['id'] as int?,
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      seasonNumber: json['season_number'] as int?,
      numberOfEpisodes: json['number_of_episodes'] as int?,
      airDate: json['air_date'] as String?,
      episodes: (json['episodes'] as List<dynamic>?)
          ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
      poster: json['poster'] == null
          ? null
          : Poster.fromJson(json['poster'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'season_number': seasonNumber,
        'number_of_episodes': numberOfEpisodes,
        'air_date': airDate,
        'episodes': episodes?.map((e) => e.toJson()).toList(),
        'poster': poster?.toJson(),
      };

  SeasonDetailsV3 copyWith({
    int? id,
    String? name,
    String? overview,
    int? seasonNumber,
    int? numberOfEpisodes,
    String? airDate,
    List<Episode>? episodes,
    Poster? poster,
  }) {
    return SeasonDetailsV3(
      id: id ?? this.id,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
      airDate: airDate ?? this.airDate,
      episodes: episodes ?? this.episodes,
      poster: poster ?? this.poster,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      overview,
      seasonNumber,
      numberOfEpisodes,
      airDate,
      episodes,
      poster,
    ];
  }
}
