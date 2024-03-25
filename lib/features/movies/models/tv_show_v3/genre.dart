import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final num? id;
  final String? name;

  const Genre({this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json['id'] as num?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Genre copyWith({
    num? id,
    String? name,
  }) {
    return Genre(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
