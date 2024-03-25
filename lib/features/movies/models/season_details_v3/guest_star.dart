import 'package:equatable/equatable.dart';

import 'urls_image.dart';

class GuestStar extends Equatable {
  final int? id;
  final bool? adult;
  final String? creditId;
  final int? idPerson;
  final String? knownForDepartment;
  final String? name;
  final String? originalName;
  final double? popularity;
  final String? profilePath;
  final String? registerDate;
  final dynamic person;
  final String? characterName;
  final num? order;
  final List<UrlsImage>? urlsImage;

  const GuestStar({
    this.id,
    this.adult,
    this.creditId,
    this.idPerson,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.registerDate,
    this.person,
    this.characterName,
    this.order,
    this.urlsImage,
  });

  factory GuestStar.fromJson(Map<String, dynamic> json) => GuestStar(
        id: json['id'] as int?,
        adult: json['adult'] as bool?,
        creditId: json['credit_id'] as String?,
        idPerson: json['id_person'] as int?,
        knownForDepartment: json['known_for_department'] as String?,
        name: json['name'] as String?,
        originalName: json['original_name'] as String?,
        popularity: (json['popularity'] as num?)?.toDouble(),
        profilePath: json['profile_path'] as String?,
        registerDate: json['register_date'] as String?,
        person: json['person'] as dynamic,
        characterName: json['character_name'] as String?,
        order: json['order'] as num?,
        urlsImage: (json['urls_image'] as List<dynamic>?)
            ?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'adult': adult,
        'credit_id': creditId,
        'id_person': idPerson,
        'known_for_department': knownForDepartment,
        'name': name,
        'original_name': originalName,
        'popularity': popularity,
        'profile_path': profilePath,
        'register_date': registerDate,
        'person': person,
        'character_name': characterName,
        'order': order,
        'urls_image': urlsImage?.map((e) => e.toJson()).toList(),
      };

  GuestStar copyWith({
    int? id,
    bool? adult,
    String? creditId,
    int? idPerson,
    String? knownForDepartment,
    String? name,
    String? originalName,
    double? popularity,
    String? profilePath,
    String? registerDate,
    dynamic person,
    String? characterName,
    num? order,
    List<UrlsImage>? urlsImage,
  }) {
    return GuestStar(
      id: id ?? this.id,
      adult: adult ?? this.adult,
      creditId: creditId ?? this.creditId,
      idPerson: idPerson ?? this.idPerson,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      popularity: popularity ?? this.popularity,
      profilePath: profilePath ?? this.profilePath,
      registerDate: registerDate ?? this.registerDate,
      person: person ?? this.person,
      characterName: characterName ?? this.characterName,
      order: order ?? this.order,
      urlsImage: urlsImage ?? this.urlsImage,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      adult,
      creditId,
      idPerson,
      knownForDepartment,
      name,
      originalName,
      popularity,
      profilePath,
      registerDate,
      person,
      characterName,
      order,
      urlsImage,
    ];
  }
}
