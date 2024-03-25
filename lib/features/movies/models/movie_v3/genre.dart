import 'package:equatable/equatable.dart';

class Genre extends Equatable {
	final num? id;
	final num? idGenre;
	final num? idInfoLanguage;
	final String? name;

	const Genre({this.id, this.idGenre, this.idInfoLanguage, this.name});

	factory Genre.fromJson(Map<String, dynamic> json) => Genre(
				id: json['id'] as num?,
				idGenre: json['id_genre'] as num?,
				idInfoLanguage: json['id_info_language'] as num?,
				name: json['name'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'id_genre': idGenre,
				'id_info_language': idInfoLanguage,
				'name': name,
			};

	Genre copyWith({
		num? id,
		num? idGenre,
		num? idInfoLanguage,
		String? name,
	}) {
		return Genre(
			id: id ?? this.id,
			idGenre: idGenre ?? this.idGenre,
			idInfoLanguage: idInfoLanguage ?? this.idInfoLanguage,
			name: name ?? this.name,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, idGenre, idInfoLanguage, name];
}
