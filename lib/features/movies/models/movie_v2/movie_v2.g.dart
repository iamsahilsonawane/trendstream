// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieV2 _$MovieV2FromJson(Map<String, dynamic> json) => MovieV2(
      adult: json['adult'] as bool?,
      backdrop: json['backdrop'] == null
          ? null
          : Backdrop.fromJson(json['backdrop'] as Map<String, dynamic>),
      budget: json['budget'] as num?,
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
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
          ?.map((e) => Version.fromJson(e as Map<String, dynamic>))
          .toList(),
      video: json['video'] as bool?,
      voteAverage: json['vote_average'] as num?,
      voteCount: json['vote_count'] as num?,
      year: json['year'] as String?,
    );

Map<String, dynamic> _$MovieV2ToJson(MovieV2 instance) => <String, dynamic>{
      'adult': instance.adult,
      'backdrop': instance.backdrop,
      'budget': instance.budget,
      'cast': instance.cast,
      'categories': instance.categories,
      'genres': instance.genres,
      'id': instance.id,
      'logo': instance.logo,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster': instance.poster,
      'release_date': instance.releaseDate,
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'status': instance.status,
      'tagline': instance.tagline,
      'title': instance.title,
      'versions': instance.versions,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'year': instance.year,
    };
