import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'icon.dart';

part 'program.g.dart';

@JsonSerializable()
class Program extends Equatable {
  final String? site;
  final String? channel;
  final List<dynamic>? titles;
  @JsonKey(name: 'sub_titles')
  final List<dynamic>? subTitles;
  final List<dynamic>? descriptions;
  final Icon? icon;
  final List<dynamic>? episodeNumbers;
  final dynamic date;
  final int? start;
  final int? stop;
  final List<dynamic>? urls;
  final List<dynamic>? ratings;
  final List<dynamic>? categories;
  final List<dynamic>? directors;
  final List<dynamic>? actors;
  final List<dynamic>? writers;
  final List<dynamic>? adapters;
  final List<dynamic>? producers;
  final List<dynamic>? composers;
  final List<dynamic>? editors;
  final List<dynamic>? presenters;
  final List<dynamic>? commentators;
  final List<dynamic>? guests;

  const Program({
    this.site,
    this.channel,
    this.titles,
    this.subTitles,
    this.descriptions,
    this.icon,
    this.episodeNumbers,
    this.date,
    this.start,
    this.stop,
    this.urls,
    this.ratings,
    this.categories,
    this.directors,
    this.actors,
    this.writers,
    this.adapters,
    this.producers,
    this.composers,
    this.editors,
    this.presenters,
    this.commentators,
    this.guests,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return _$ProgramFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProgramToJson(this);

  Program copyWith({
    String? site,
    String? channel,
    List<dynamic>? titles,
    List<dynamic>? subTitles,
    List<dynamic>? descriptions,
    Icon? icon,
    List<dynamic>? episodeNumbers,
    dynamic date,
    int? start,
    int? stop,
    List<dynamic>? urls,
    List<dynamic>? ratings,
    List<dynamic>? categories,
    List<dynamic>? directors,
    List<dynamic>? actors,
    List<dynamic>? writers,
    List<dynamic>? adapters,
    List<dynamic>? producers,
    List<dynamic>? composers,
    List<dynamic>? editors,
    List<dynamic>? presenters,
    List<dynamic>? commentators,
    List<dynamic>? guests,
  }) {
    return Program(
      site: site ?? this.site,
      channel: channel ?? this.channel,
      titles: titles ?? this.titles,
      subTitles: subTitles ?? this.subTitles,
      descriptions: descriptions ?? this.descriptions,
      icon: icon ?? this.icon,
      episodeNumbers: episodeNumbers ?? this.episodeNumbers,
      date: date ?? this.date,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      urls: urls ?? this.urls,
      ratings: ratings ?? this.ratings,
      categories: categories ?? this.categories,
      directors: directors ?? this.directors,
      actors: actors ?? this.actors,
      writers: writers ?? this.writers,
      adapters: adapters ?? this.adapters,
      producers: producers ?? this.producers,
      composers: composers ?? this.composers,
      editors: editors ?? this.editors,
      presenters: presenters ?? this.presenters,
      commentators: commentators ?? this.commentators,
      guests: guests ?? this.guests,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      site,
      channel,
      titles,
      subTitles,
      descriptions,
      icon,
      episodeNumbers,
      date,
      start,
      stop,
      urls,
      ratings,
      categories,
      directors,
      actors,
      writers,
      adapters,
      producers,
      composers,
      editors,
      presenters,
      commentators,
      guests,
    ];
  }
}
