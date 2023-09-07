import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'backdrop.dart';
import 'cast.dart';
import 'category.dart';
import 'genre.dart';
import 'logo.dart';
import 'poster.dart';
import 'version.dart';

part 'movie_v2.g.dart';

@JsonSerializable()
class MovieV2 extends Equatable {
  final bool? adult;
  final Backdrop? backdrop;
  final num? budget;
  final List<Cast>? cast;
  final List<Category>? categories;
  final List<Genre>? genres;
  final num? id;
  final Logo? logo;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'original_title')
  final String? originalTitle;
  final String? overview;
  final num? popularity;
  final Poster? poster;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  final num? revenue;
  final num? runtime;
  final String? status;
  final String? tagline;
  final String? title;
  final List<Version>? versions;
  final bool? video;
  @JsonKey(name: 'vote_average')
  final num? voteAverage;
  @JsonKey(name: 'vote_count')
  final num? voteCount;
  final String? year;

  const MovieV2({
    this.adult,
    this.backdrop,
    this.budget,
    this.cast,
    this.categories,
    this.genres,
    this.id,
    this.logo,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.poster,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.status,
    this.tagline,
    this.title,
    this.versions,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.year,
  });

  factory MovieV2.fromJson(Map<String, dynamic> json) {
    return _$MovieV2FromJson(json);
  }

  Map<String, dynamic> toJson() => _$MovieV2ToJson(this);

  MovieV2 copyWith({
    bool? adult,
    Backdrop? backdrop,
    num? budget,
    List<Cast>? cast,
    List<Category>? categories,
    List<Genre>? genres,
    num? id,
    Logo? logo,
    String? originalLanguage,
    String? originalTitle,
    String? overview,
    num? popularity,
    Poster? poster,
    String? releaseDate,
    num? revenue,
    num? runtime,
    String? status,
    String? tagline,
    String? title,
    List<Version>? versions,
    bool? video,
    num? voteAverage,
    num? voteCount,
    String? year,
  }) {
    return MovieV2(
      adult: adult ?? this.adult,
      backdrop: backdrop ?? this.backdrop,
      budget: budget ?? this.budget,
      cast: cast ?? this.cast,
      categories: categories ?? this.categories,
      genres: genres ?? this.genres,
      id: id ?? this.id,
      logo: logo ?? this.logo,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      poster: poster ?? this.poster,
      releaseDate: releaseDate ?? this.releaseDate,
      revenue: revenue ?? this.revenue,
      runtime: runtime ?? this.runtime,
      status: status ?? this.status,
      tagline: tagline ?? this.tagline,
      title: title ?? this.title,
      versions: versions ?? this.versions,
      video: video ?? this.video,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      year: year ?? this.year,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      adult,
      backdrop,
      budget,
      cast,
      categories,
      genres,
      id,
      logo,
      originalLanguage,
      originalTitle,
      overview,
      popularity,
      poster,
      releaseDate,
      revenue,
      runtime,
      status,
      tagline,
      title,
      versions,
      video,
      voteAverage,
      voteCount,
      year,
    ];
  }
}
