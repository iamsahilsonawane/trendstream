import 'package:equatable/equatable.dart';

class Size extends Equatable {
	final bool? active;
	final num? id;
	final String? value;

	const Size({this.active, this.id, this.value});

	factory Size.fromJson(Map<String, dynamic> json) => Size(
				active: json['active'] as bool?,
				id: json['id'] as num?,
				value: json['value'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'active': active,
				'id': id,
				'value': value,
			};

	Size copyWith({
		bool? active,
		num? id,
		String? value,
	}) {
		return Size(
			active: active ?? this.active,
			id: id ?? this.id,
			value: value ?? this.value,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [active, id, value];
}
