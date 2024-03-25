import 'package:equatable/equatable.dart';

import 'character_name.dart';
import 'person.dart';
import 'urls_image.dart';

class Crew extends Equatable {
	final bool? adult;
	final num? castId;
	final List<CharacterName>? characterNames;
	final String? characterName;
	final String? creditId;
	final String? department;
	final num? gender;
	final num? id;
	final num? idPerson;
	final String? job;
	final String? knownForDepartment;
	final String? name;
	final num? order;
	final String? originalName;
	final Person? person;
	final num? popularity;
	final String? profilePath;
	final String? registerDate;
	final List<UrlsImage>? urlsImage;

	const Crew({
		this.adult, 
		this.castId, 
		this.characterNames, 
		this.characterName, 
		this.creditId, 
		this.department, 
		this.gender, 
		this.id, 
		this.idPerson, 
		this.job, 
		this.knownForDepartment, 
		this.name, 
		this.order, 
		this.originalName, 
		this.person, 
		this.popularity, 
		this.profilePath, 
		this.registerDate, 
		this.urlsImage, 
	});

	factory Crew.fromJson(Map<String, dynamic> json) => Crew(
				adult: json['adult'] as bool?,
				castId: json['cast_id'] as num?,
				characterNames: (json['characterNames'] as List<dynamic>?)
						?.map((e) => CharacterName.fromJson(e as Map<String, dynamic>))
						.toList(),
				characterName: json['character_name'] as String?,
				creditId: json['credit_id'] as String?,
				department: json['department'] as String?,
				gender: json['gender'] as num?,
				id: json['id'] as num?,
				idPerson: json['id_person'] as num?,
				job: json['job'] as String?,
				knownForDepartment: json['known_for_department'] as String?,
				name: json['name'] as String?,
				order: json['order'] as num?,
				originalName: json['original_name'] as String?,
				person: json['person'] == null
						? null
						: Person.fromJson(json['person'] as Map<String, dynamic>),
				popularity: json['popularity'] as num?,
				profilePath: json['profile_path'] as String?,
				registerDate: json['register_date'] as String?,
				urlsImage: (json['urls_image'] as List<dynamic>?)
						?.map((e) => UrlsImage.fromJson(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toJson() => {
				'adult': adult,
				'cast_id': castId,
				'characterNames': characterNames?.map((e) => e.toJson()).toList(),
				'character_name': characterName,
				'credit_id': creditId,
				'department': department,
				'gender': gender,
				'id': id,
				'id_person': idPerson,
				'job': job,
				'known_for_department': knownForDepartment,
				'name': name,
				'order': order,
				'original_name': originalName,
				'person': person?.toJson(),
				'popularity': popularity,
				'profile_path': profilePath,
				'register_date': registerDate,
				'urls_image': urlsImage?.map((e) => e.toJson()).toList(),
			};

	Crew copyWith({
		bool? adult,
		num? castId,
		List<CharacterName>? characterNames,
		String? characterName,
		String? creditId,
		String? department,
		num? gender,
		num? id,
		num? idPerson,
		String? job,
		String? knownForDepartment,
		String? name,
		num? order,
		String? originalName,
		Person? person,
		num? popularity,
		String? profilePath,
		String? registerDate,
		List<UrlsImage>? urlsImage,
	}) {
		return Crew(
			adult: adult ?? this.adult,
			castId: castId ?? this.castId,
			characterNames: characterNames ?? this.characterNames,
			characterName: characterName ?? this.characterName,
			creditId: creditId ?? this.creditId,
			department: department ?? this.department,
			gender: gender ?? this.gender,
			id: id ?? this.id,
			idPerson: idPerson ?? this.idPerson,
			job: job ?? this.job,
			knownForDepartment: knownForDepartment ?? this.knownForDepartment,
			name: name ?? this.name,
			order: order ?? this.order,
			originalName: originalName ?? this.originalName,
			person: person ?? this.person,
			popularity: popularity ?? this.popularity,
			profilePath: profilePath ?? this.profilePath,
			registerDate: registerDate ?? this.registerDate,
			urlsImage: urlsImage ?? this.urlsImage,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props {
		return [
				adult,
				castId,
				characterNames,
				characterName,
				creditId,
				department,
				gender,
				id,
				idPerson,
				job,
				knownForDepartment,
				name,
				order,
				originalName,
				person,
				popularity,
				profilePath,
				registerDate,
				urlsImage,
		];
	}
}
