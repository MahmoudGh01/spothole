

import 'package:job_seeker/Models/School.dart';
import 'package:job_seeker/Models/Student.dart';

class Classe {
  final int idClass;
  final String name;
  final List<School> schools;
  final List<Student> students;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool canDeleted;
  final DateTime? deletedAt;

  Classe({
    required this.idClass,
    required this.name,
    required this.schools,
    required this.students,
    required this.createdAt,
    this.updatedAt,
    required this.canDeleted,
    this.deletedAt,
  });

  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      idClass: json['id_class'],
      name: json['name'],
      schools: (json['schools'] as List)
          .map((i) => School.fromJson(i))
          .toList(),
      students: (json['students'] as List)
          .map((i) => Student.fromJson(i))
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
      'id_class': idClass,
      'name': name,
      'schools': schools.map((s) => s.toJson()).toList(),
      'students': students.map((s) => s.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'can_deleted': canDeleted,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
