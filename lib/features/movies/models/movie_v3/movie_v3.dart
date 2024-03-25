import 'package:equatable/equatable.dart';

import 'backdrop.dart';
import 'cast.dart';
import 'category.dart';
import 'crew.dart';
import 'genre.dart';
import 'logo.dart';
import 'poster.dart';
import 'version.dart';

class MovieV3 extends Equatable {
  final bool? adult;
  final Backdrop? backdrop;
  final num? budget;
  final List<Cast>? cast;
  final List<CategoryV3>? categories;
  final List<Crew>? crew;
  final List<Genre>? genres;
  final num? id;
  final Logo? logo;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final num? popularity;
  final Poster? poster;
  final String? releaseDate;
  final num? revenue;
  final num? runtime;
  final String? status;
  final String? tagline;
  final String? title;
  final List<VersionV3>? versions;
  final bool? video;
  final num? voteAverage;
  final num? voteCount;
  final String? year;

  const MovieV3({
    this.adult,
    this.backdrop,
    this.budget,
    this.cast,
    this.categories,
    this.crew,
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

  factory MovieV3.fromJson(Map<String, dynamic> json) => MovieV3(
        adult: json['adult'] as bool?,
        backdrop: json['backdrop'] == null
            ? null
            : Backdrop.fromJson(json['backdrop'] as Map<String, dynamic>),
        budget: json['budget'] as num?,
        cast: (json['cast'] as List<dynamic>?)
            ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
            .toList(),
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => CategoryV3.fromJson(e as Map<String, dynamic>))
            .toList(),
        crew: (json['crew'] as List<dynamic>?)
            ?.map((e) => Crew.fromJson(e as Map<String, dynamic>))
            .toList(),
        genres: (json['genres'] as List<dynamic>?)
            ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
            .toList(),
        id: json['id'] as num?,
        logo: json['logo'] == null
            ? null
            : Logo.fromJson(json['logo'] as Map<String, dynamic>),
        originalLanguage: json['original_language'] as String?,
        originalTitle: json['original_title'] as String?,
        overview: json['overview'] as String?,
        popularity: json['popularity'] as num?,
        poster: json['poster'] == null
            ? null
            : Poster.fromJson(json['poster'] as Map<String, dynamic>),
        releaseDate: json['release_date'] as String?,
        revenue: json['revenue'] as num?,
        runtime: json['runtime'] as num?,
        status: json['status'] as String?,
        tagline: json['tagline'] as String?,
        title: json['title'] as String?,
        versions: (json['versions'] as List<dynamic>?)
            ?.map((e) => VersionV3.fromJson(e as Map<String, dynamic>))
            .toList(),
        video: json['video'] as bool?,
        voteAverage: json['vote_average'] as num?,
        voteCount: json['vote_count'] as num?,
        year: json['year'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'backdrop': backdrop?.toJson(),
        'budget': budget,
        'cast': cast?.map((e) => e.toJson()).toList(),
        'categories': categories?.map((e) => e.toJson()).toList(),
        'crew': crew?.map((e) => e.toJson()).toList(),
        'genres': genres?.map((e) => e.toJson()).toList(),
        'id': id,
        'logo': logo?.toJson(),
        'original_language': originalLanguage,
        'original_title': originalTitle,
        'overview': overview,
        'popularity': popularity,
        'poster': poster?.toJson(),
        'release_date': releaseDate,
        'revenue': revenue,
        'runtime': runtime,
        'status': status,
        'tagline': tagline,
        'title': title,
        'versions': versions?.map((e) => e.toJson()).toList(),
        'video': video,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'year': year,
      };

  MovieV3 copyWith({
    bool? adult,
    Backdrop? backdrop,
    num? budget,
    List<Cast>? cast,
    List<CategoryV3>? categories,
    List<Crew>? crew,
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
    List<VersionV3>? versions,
    bool? video,
    num? voteAverage,
    num? voteCount,
    String? year,
  }) {
    return MovieV3(
      adult: adult ?? this.adult,
      backdrop: backdrop ?? this.backdrop,
      budget: budget ?? this.budget,
      cast: cast ?? this.cast,
      categories: categories ?? this.categories,
      crew: crew ?? this.crew,
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
      crew,
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
