import 'package:equatable/equatable.dart';

class CategoryV3 extends Equatable {
	final num? id;
	final String? name;
	final num? order;

	const CategoryV3({this.id, this.name, this.order});

	factory CategoryV3.fromJson(Map<String, dynamic> json) => CategoryV3(
				id: json['id'] as num?,
				name: json['name'] as String?,
				order: json['order'] as num?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'order': order,
			};

	CategoryV3 copyWith({
		num? id,
		String? name,
		num? order,
	}) {
		return CategoryV3(
			id: id ?? this.id,
			name: name ?? this.name,
			order: order ?? this.order,
		);
	}

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [id, name, order];
}
