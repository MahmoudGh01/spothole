import 'dart:convert';

import 'package:job_seeker/Models/Class.dart';


class School {
  final int idSchool;
  final String name;
  final List<Classe> classes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool canDeleted;
  final DateTime? deletedAt;

  School({
    required this.idSchool,
    required this.name,
    required this.classes,
    required this.createdAt,
    this.updatedAt,
    required this.canDeleted,
    this.deletedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      idSchool: json['id_school'],
      name: json['name'],
      classes: (json['classes'] as List)
          .map((i) => Classe.fromJson(i))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
      json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      canDeleted: json['can_deleted'],
      deletedAt:
      json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_school': idSchool,
      'name': name,
      'classes': classes.map((c) => c.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'can_deleted': canDeleted,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
