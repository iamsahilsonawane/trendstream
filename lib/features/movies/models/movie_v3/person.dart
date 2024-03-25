import 'package:equatable/equatable.dart';

import 'biography.dart';
import 'urls_image.dart';

class Person extends Equatable {
	final bool? adult;
	final List<Biography>? biographies;
	final String? biography;
	final String? birthday;
	final String? deathDay;
	final num? gender;
	final num? id;
	final num? idPersonTmdb;
	final String? imdbId;
	final String? knownForDepartment;
	final String? name;
	final String? placeOfBirth;
	final num? popularity;
	final String? profilePath;
	final String? registerDate;
	final String? suggestedName;
	final List<UrlsImage>? urlsImage;

	const Person({
		this.adult, 
		this.biographies, 
		this.biography, 
		this.birthday, 
		this.deathDay, 
		this.gender, 
		this.id, 
		this.idPersonTmdb, 
		this.imdbId, 
		this.knownForDepartment, 
		this.name, 
		this.placeOfBirth, 
		this.popularity, 
		this.profilePath, 
		this.registerDate, 
		this.suggestedName, 
		this.urlsImage, 
	});

	factory Person.fromJson(Map<String, dynamic> json) => Person(
				adult: json['adult'] as bool?,
				biographies: (json['biographies'] as List<dynamic>?)
						?.map((e) => Biography.fromJson(e as Map<String, dynamic>))
						.toList(),
				biography: json['biography'] as String?,
				birthday: json['birthday'] as String?,
				deathDay: json['death_day'] as String?,
				gender: json['gender'] as num?,
				id: json['id'] as num?,
				idPersonTmdb: json['id_person_tmdb'] as num?,
				imdbId: json['imdb_id'] as String?,
				knownForDepartment: json['known_for_department'] as String?,
				name: json['name'] as String?,
				placeOfBirth: json['place_of_birth'] as String?,
				popularity: json['popularity'] as num?,
				profilePath: json['profile_path'] as String?,
				registerDate: json['register_date'] as String?,
				suggestedName: json['suggested_name'] as String?,
				urlsImage: (json['urls_image'] as List<dynamic>?)
						?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toJson() => {
				'adult': adult,
				'biographies': biographies?.map((e) => e.toJson()).toList(),
				'biography': biography,
				'birthday': birthday,
				'death_day': deathDay,
				'gender': gender,
				'id': id,
				'id_person_tmdb': idPersonTmdb,
				'imdb_id': imdbId,
				'known_for_department': knownForDepartment,
				'name': name,
				'place_of_birth': placeOfBirth,
				'popularity': popularity,
				'profile_path': profilePath,
				'register_date': registerDate,
				'suggested_name': suggestedName,
				'urls_image': urlsImage?.map((e) => e.toJson()).toList(),
			};

	Person copyWith({
		bool? adult,
		List<Biography>? biographies,
		String? biography,
		String? birthday,
		String? deathDay,
		num? gender,
		num? id,
		num? idPersonTmdb,
		String? imdbId,
		String? knownForDepartment,
		String? name,
		String? placeOfBirth,
		num? popularity,
		String? profilePath,
		String? registerDate,
		String? suggestedName,
		List<UrlsImage>? urlsImage,
	}) {
		return Person(
			adult: adult ?? this.adult,
			biographies: biographies ?? this.biographies,
			biography: biography ?? this.biography,
			birthday: birthday ?? this.birthday,
			deathDay: deathDay ?? this.deathDay,
			gender: gender ?? this.gender,
			id: id ?? this.id,
			idPersonTmdb: idPersonTmdb ?? this.idPersonTmdb,
			imdbId: imdbId ?? this.imdbId,
			knownForDepartment: knownForDepartment ?? this.knownForDepartment,
			name: name ?? this.name,
			placeOfBirth: placeOfBirth ?? this.placeOfBirth,
			popularity: popularity ?? this.popularity,
			profilePath: profilePath ?? this.profilePath,
			registerDate: registerDate ?? this.registerDate,
			suggestedName: suggestedName ?? this.suggestedName,
			urlsImage: urlsImage ?? this.urlsImage,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				adult,
				biographies,
				biography,
				birthday,
				deathDay,
				gender,
				id,
				idPersonTmdb,
				imdbId,
				knownForDepartment,
				name,
				placeOfBirth,
				popularity,
				profilePath,
				registerDate,
				suggestedName,
				urlsImage,
		];
	}
}
