import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SubtitleColor extends Equatable {
  final Color color;
  final Color? backgroundColor;

  const SubtitleColor({required this.color, this.backgroundColor});

  @override
  List<Object?> get props => [color, backgroundColor];
}
