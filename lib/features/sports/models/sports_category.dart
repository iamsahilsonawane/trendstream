import 'package:equatable/equatable.dart';

class SportsCategory extends Equatable {
  final int? id;
  final String? name;

  const SportsCategory({this.id, this.name});

  factory SportsCategory.fromJson(Map<String, dynamic> json) {
    return SportsCategory(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  SportsCategory copyWith({
    int? id,
    String? name,
  }) {
    return SportsCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
