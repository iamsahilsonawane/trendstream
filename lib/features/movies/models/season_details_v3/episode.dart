import 'package:equatable/equatable.dart';

import 'guest_star.dart';
import 'still.dart';

class Episode extends Equatable {
  final int? id;
  final String? airDate;
  final String? name;
  final String? overview;
  final num? episodeNumber;
  final String? productionCode;
  final num? runtime;
  final num? seasonNumber;
  final dynamic stillPath;
  final double? voteAverage;
  final num? voteCount;
  final Still? still;
  final List<dynamic>? casts;
  final List<GuestStar>? guestStars;

  const Episode({
    this.id,
    this.airDate,
    this.name,
    this.overview,
    this.episodeNumber,
    this.productionCode,
    this.runtime,
    this.seasonNumber,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
    this.still,
    this.casts,
    this.guestStars,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json['id'] as int?,
        airDate: json['air_date'] as String?,
        name: json['name'] as String?,
        overview: json['overview'] as String?,
        episodeNumber: json['episode_number'] as num?,
        productionCode: json['production_code'] as String?,
        runtime: json['runtime'] as num?,
        seasonNumber: json['season_number'] as num?,
        stillPath: json['still_path'] as dynamic,
        voteAverage: (json['vote_average'] as num?)?.toDouble(),
        voteCount: json['vote_count'] as num?,
        still: json['still'] == null
            ? null
            : Still.fromJson(json['still'] as Map<String, dynamic>),
        casts: json['casts'] as List<dynamic>?,
        guestStars: (json['guest_stars'] as List<dynamic>?)
            ?.map((e) => GuestStar.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'air_date': airDate,
        'name': name,
        'overview': overview,
        'episode_number': episodeNumber,
        'production_code': productionCode,
        'runtime': runtime,
        'season_number': seasonNumber,
        'still_path': stillPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'still': still?.toJson(),
        'casts': casts,
        'guest_stars': guestStars?.map((e) => e.toJson()).toList(),
      };

  Episode copyWith({
    int? id,
    String? airDate,
    String? name,
    String? overview,
    num? episodeNumber,
    String? productionCode,
    num? runtime,
    num? seasonNumber,
    dynamic stillPath,
    double? voteAverage,
    num? voteCount,
    Still? still,
    List<dynamic>? casts,
    List<GuestStar>? guestStars,
  }) {
    return Episode(
      id: id ?? this.id,
      airDate: airDate ?? this.airDate,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      productionCode: productionCode ?? this.productionCode,
      runtime: runtime ?? this.runtime,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      stillPath: stillPath ?? this.stillPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      still: still ?? this.still,
      casts: casts ?? this.casts,
      guestStars: guestStars ?? this.guestStars,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      airDate,
      name,
      overview,
      episodeNumber,
      productionCode,
      runtime,
      seasonNumber,
      stillPath,
      voteAverage,
      voteCount,
      still,
      casts,
      guestStars,
    ];
  }
}
