import 'package:equatable/equatable.dart';

import 'backdrop.dart';
import 'cast.dart';
import 'genre.dart';
import 'poster.dart';

class TvShowV3 extends Equatable {
  final String? actors;
  final bool? adult;
  final Backdrop? backdrop;
  final List<Cast>? casts;
  final String? country;
  final String? director;
  final String? firstAirDate;
  final List<Genre>? genres;
  final int? id;
  final bool? inProduction;
  final String? lastAirDate;
  final String? name;
  final String? network;
  final num? numberOfEpisodes;
  final String? numberOfEpisodesTmdb;
  final num? numberOfSeasons;
  final String? numberOfSeasonsTmdb;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final num? popularity;
  final Poster? poster;
  final String? rated;
  final num? runtime;
  final String? status;
  final num? voteAverage;
  final num? voteCount;
  final String? writer;
  final String? year;

  const TvShowV3({
    this.actors,
    this.adult,
    this.backdrop,
    this.casts,
    this.country,
    this.director,
    this.firstAirDate,
    this.genres,
    this.id,
    this.inProduction,
    this.lastAirDate,
    this.name,
    this.network,
    this.numberOfEpisodes,
    this.numberOfEpisodesTmdb,
    this.numberOfSeasons,
    this.numberOfSeasonsTmdb,
    this.originalLanguage,
    this.originalName,
    this.overview,
    this.popularity,
    this.poster,
    this.rated,
    this.runtime,
    this.status,
    this.voteAverage,
    this.voteCount,
    this.writer,
    this.year,
  });

  factory TvShowV3.fromJson(Map<String, dynamic> json) => TvShowV3(
        actors: json['actors'] as String?,
        adult: json['adult'] as bool?,
        backdrop: json['backdrop'] == null
            ? null
            : Backdrop.fromJson(json['backdrop'] as Map<String, dynamic>),
        casts: (json['casts'] as List<dynamic>?)
            ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
            .toList(),
        country: json['country'] as String?,
        director: json['director'] as String?,
        firstAirDate: json['first_air_date'] as String?,
        genres: (json['genres'] as List<dynamic>?)
            ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
            .toList(),
        id: json['id'] as int?,
        inProduction: json['in_production'] as bool?,
        lastAirDate: json['last_air_date'] as String?,
        name: json['name'] as String?,
        network: json['network'] as String?,
        numberOfEpisodes: json['number_of_episodes'] as num?,
        numberOfEpisodesTmdb: json['number_of_episodes_tmdb'] as String?,
        numberOfSeasons: json['number_of_seasons'] as num?,
        numberOfSeasonsTmdb: json['number_of_seasons_tmdb'] as String?,
        originalLanguage: json['original_language'] as String?,
        originalName: json['original_name'] as String?,
        overview: json['overview'] as String?,
        popularity: json['popularity'] as num?,
        poster: json['poster'] == null
            ? null
            : Poster.fromJson(json['poster'] as Map<String, dynamic>),
        rated: json['rated'] as String?,
        runtime: json['runtime'] as num?,
        status: json['status'] as String?,
        voteAverage: json['vote_average'] as num?,
        voteCount: json['vote_count'] as num?,
        writer: json['writer'] as String?,
        year: json['year'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'actors': actors,
        'adult': adult,
        'backdrop': backdrop?.toJson(),
        'casts': casts?.map((e) => e.toJson()).toList(),
        'country': country,
        'director': director,
        'first_air_date': firstAirDate,
        'genres': genres?.map((e) => e.toJson()).toList(),
        'id': id,
        'in_production': inProduction,
        'last_air_date': lastAirDate,
        'name': name,
        'network': network,
        'number_of_episodes': numberOfEpisodes,
        'number_of_episodes_tmdb': numberOfEpisodesTmdb,
        'number_of_seasons': numberOfSeasons,
        'number_of_seasons_tmdb': numberOfSeasonsTmdb,
        'original_language': originalLanguage,
        'original_name': originalName,
        'overview': overview,
        'popularity': popularity,
        'poster': poster?.toJson(),
        'rated': rated,
        'runtime': runtime,
        'status': status,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'writer': writer,
        'year': year,
      };

  TvShowV3 copyWith({
    String? actors,
    bool? adult,
    Backdrop? backdrop,
    List<Cast>? casts,
    String? country,
    String? director,
    String? firstAirDate,
    List<Genre>? genres,
    int? id,
    bool? inProduction,
    String? lastAirDate,
    String? name,
    String? network,
    num? numberOfEpisodes,
    String? numberOfEpisodesTmdb,
    num? numberOfSeasons,
    String? numberOfSeasonsTmdb,
    String? originalLanguage,
    String? originalName,
    String? overview,
    num? popularity,
    Poster? poster,
    String? rated,
    num? runtime,
    String? status,
    num? voteAverage,
    num? voteCount,
    String? writer,
    String? year,
  }) {
    return TvShowV3(
      actors: actors ?? this.actors,
      adult: adult ?? this.adult,
      backdrop: backdrop ?? this.backdrop,
      casts: casts ?? this.casts,
      country: country ?? this.country,
      director: director ?? this.director,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      genres: genres ?? this.genres,
      id: id ?? this.id,
      inProduction: inProduction ?? this.inProduction,
      lastAirDate: lastAirDate ?? this.lastAirDate,
      name: name ?? this.name,
      network: network ?? this.network,
      numberOfEpisodes: numberOfEpisodes ?? this.numberOfEpisodes,
      numberOfEpisodesTmdb: numberOfEpisodesTmdb ?? this.numberOfEpisodesTmdb,
      numberOfSeasons: numberOfSeasons ?? this.numberOfSeasons,
      numberOfSeasonsTmdb: numberOfSeasonsTmdb ?? this.numberOfSeasonsTmdb,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalName: originalName ?? this.originalName,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      poster: poster ?? this.poster,
      rated: rated ?? this.rated,
      runtime: runtime ?? this.runtime,
      status: status ?? this.status,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      writer: writer ?? this.writer,
      year: year ?? this.year,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      actors,
      adult,
      backdrop,
      casts,
      country,
      director,
      firstAirDate,
      genres,
      id,
      inProduction,
      lastAirDate,
      name,
      network,
      numberOfEpisodes,
      numberOfEpisodesTmdb,
      numberOfSeasons,
      numberOfSeasonsTmdb,
      originalLanguage,
      originalName,
      overview,
      popularity,
      poster,
      rated,
      runtime,
      status,
      voteAverage,
      voteCount,
      writer,
      year,
    ];
  }
}
