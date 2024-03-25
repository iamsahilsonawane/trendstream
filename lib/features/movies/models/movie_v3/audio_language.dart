import 'package:equatable/equatable.dart';

class AudioLanguage extends Equatable {
	final num? id;
	final String? name;

	const AudioLanguage({this.id, this.name});

	factory AudioLanguage.fromJson(Map<String, dynamic> json) => AudioLanguage(
				id: json['id'] as num?,
				name: json['name'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
			};

	AudioLanguage copyWith({
		num? id,
		String? name,
	}) {
		return AudioLanguage(
			id: id ?? this.id,
			name: name ?? this.name,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, name];
}
