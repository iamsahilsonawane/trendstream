import 'package:equatable/equatable.dart';

class Biography extends Equatable {
	final String? biography;
	final num? id;
	final num? idInfoLanguage;
	final num? idPerson;

	const Biography({
		this.biography, 
		this.id, 
		this.idInfoLanguage, 
		this.idPerson, 
	});

	factory Biography.fromJson(Map<String, dynamic> json) => Biography(
				biography: json['biography'] as String?,
				id: json['id'] as num?,
				idInfoLanguage: json['id_info_language'] as num?,
				idPerson: json['id_person'] as num?,
			);

	Map<String, dynamic> toJson() => {
				'biography': biography,
				'id': id,
				'id_info_language': idInfoLanguage,
				'id_person': idPerson,
			};

	Biography copyWith({
		String? biography,
		num? id,
		num? idInfoLanguage,
		num? idPerson,
	}) {
		return Biography(
			biography: biography ?? this.biography,
			id: id ?? this.id,
			idInfoLanguage: idInfoLanguage ?? this.idInfoLanguage,
			idPerson: idPerson ?? this.idPerson,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [biography, id, idInfoLanguage, idPerson];
}
