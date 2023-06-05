import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../movie/credits/credits.dart';

part 'tv_show.g.dart';

@JsonSerializable()
class TvShow extends Equatable {
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  final double? popularity;
  final int? id;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  final String? overview;
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  @JsonKey(name: 'origin_country')
  final List<String>? originCountry;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'vote_count')
  final int? voteCount;
  final String? name;
  @JsonKey(name: 'original_name')
  final String? originalName;
  final Credits? credits;

  const TvShow({
    this.posterPath,
    this.popularity,
    this.id,
    this.backdropPath,
    this.voteAverage,
    this.overview,
    this.firstAirDate,
    this.originCountry,
    this.genreIds,
    this.originalLanguage,
    this.voteCount,
    this.name,
    this.originalName,
    this.credits,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return _$TvShowFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TvShowToJson(this);

  TvShow copyWith({
    String? posterPath,
    double? popularity,
    int? id,
    String? backdropPath,
    double? voteAverage,
    String? overview,
    String? firstAirDate,
    List<String>? originCountry,
    List<int>? genreIds,
    String? originalLanguage,
    int? voteCount,
    String? name,
    String? originalName,
    Credits? credits,
  }) {
    return TvShow(
      posterPath: posterPath ?? this.posterPath,
      popularity: popularity ?? this.popularity,
      id: id ?? this.id,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      overview: overview ?? this.overview,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      originCountry: originCountry ?? this.originCountry,
      genreIds: genreIds ?? this.genreIds,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      voteCount: voteCount ?? this.voteCount,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      credits: credits ?? this.credits,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      posterPath,
      popularity,
      id,
      backdropPath,
      voteAverage,
      overview,
      firstAirDate,
      originCountry,
      genreIds,
      originalLanguage,
      voteCount,
      name,
      originalName,
      credits,
    ];
  }
}
