// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Program _$ProgramFromJson(Map<String, dynamic> json) => Program(
      site: json['site'] as String?,
      channel: json['channel'] as String?,
      titles: (json['titles'] as List<dynamic>?)
          ?.map((e) => ProgramTitle.fromJson(e as Map<String, dynamic>))
          .toList(),
      subTitles: json['sub_titles'] as List<dynamic>?,
      descriptions: json['descriptions'] as List<dynamic>?,
      icon: json['icon'] == null
          ? null
          : Icon.fromJson(json['icon'] as Map<String, dynamic>),
      episodeNumbers: json['episodeNumbers'] as List<dynamic>?,
      date: json['date'],
      start: json['start'] as int?,
      stop: json['stop'] as int?,
      urls: json['urls'] as List<dynamic>?,
      ratings: json['ratings'] as List<dynamic>?,
      categories: json['categories'] as List<dynamic>?,
      directors: json['directors'] as List<dynamic>?,
      actors: json['actors'] as List<dynamic>?,
      writers: json['writers'] as List<dynamic>?,
      adapters: json['adapters'] as List<dynamic>?,
      producers: json['producers'] as List<dynamic>?,
      composers: json['composers'] as List<dynamic>?,
      editors: json['editors'] as List<dynamic>?,
      presenters: json['presenters'] as List<dynamic>?,
      commentators: json['commentators'] as List<dynamic>?,
      guests: json['guests'] as List<dynamic>?,
    );

Map<String, dynamic> _$ProgramToJson(Program instance) => <String, dynamic>{
      'site': instance.site,
      'channel': instance.channel,
      'titles': instance.titles,
      'sub_titles': instance.subTitles,
      'descriptions': instance.descriptions,
      'icon': instance.icon,
      'episodeNumbers': instance.episodeNumbers,
      'date': instance.date,
      'start': instance.start,
      'stop': instance.stop,
      'urls': instance.urls,
      'ratings': instance.ratings,
      'categories': instance.categories,
      'directors': instance.directors,
      'actors': instance.actors,
      'writers': instance.writers,
      'adapters': instance.adapters,
      'producers': instance.producers,
      'composers': instance.composers,
      'editors': instance.editors,
      'presenters': instance.presenters,
      'commentators': instance.commentators,
      'guests': instance.guests,
    };
