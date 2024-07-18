import 'package:equatable/equatable.dart';

import 'category.dart';

class SportsEvent extends Equatable {
  final int? id;
  final String? name;
  final String? poster;
  final DateTime? eventDate;
  final dynamic icon;
  final Category? category;
  final String? url;

  const SportsEvent({
    this.id,
    this.name,
    this.poster,
    this.eventDate,
    this.icon,
    this.category,
    this.url,
  });

  factory SportsEvent.fromJson(Map<String, dynamic> json) => SportsEvent(
        id: json['id'] as int?,
        name: json['name'] as String?,
        poster: json['poster'] as String?,
        eventDate: json['event_date'] != null ? DateTime.parse(json['event_date'] as String) : null,
        icon: json['icon'] as dynamic,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'poster': poster,
        'event_date': eventDate?.toIso8601String(),
        'icon': icon,
        'category': category?.toJson(),
        'url': url,
      };

  SportsEvent copyWith({
    int? id,
    String? name,
    String? poster,
    DateTime? eventDate,
    dynamic icon,
    Category? category,
    String? url,
  }) {
    return SportsEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      poster: poster ?? this.poster,
      eventDate: eventDate ?? this.eventDate,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      url: url ?? this.url,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      poster,
      eventDate,
      icon,
      category,
      url,
    ];
  }
}
