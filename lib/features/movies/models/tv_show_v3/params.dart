import 'package:equatable/equatable.dart';

import 'additional_prop1.dart';
import 'additional_prop2.dart';
import 'additional_prop3.dart';

class Params extends Equatable {
  final AdditionalProp1? additionalProp1;
  final AdditionalProp2? additionalProp2;
  final AdditionalProp3? additionalProp3;

  const Params({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        additionalProp1: json['additionalProp1'] == null
            ? null
            : AdditionalProp1.fromJson(
                json['additionalProp1'] as Map<String, dynamic>),
        additionalProp2: json['additionalProp2'] == null
            ? null
            : AdditionalProp2.fromJson(
                json['additionalProp2'] as Map<String, dynamic>),
        additionalProp3: json['additionalProp3'] == null
            ? null
            : AdditionalProp3.fromJson(
                json['additionalProp3'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'additionalProp1': additionalProp1?.toJson(),
        'additionalProp2': additionalProp2?.toJson(),
        'additionalProp3': additionalProp3?.toJson(),
      };

  Params copyWith({
    AdditionalProp1? additionalProp1,
    AdditionalProp2? additionalProp2,
    AdditionalProp3? additionalProp3,
  }) {
    return Params(
      additionalProp1: additionalProp1 ?? this.additionalProp1,
      additionalProp2: additionalProp2 ?? this.additionalProp2,
      additionalProp3: additionalProp3 ?? this.additionalProp3,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      additionalProp1,
      additionalProp2,
      additionalProp3,
    ];
  }
}
