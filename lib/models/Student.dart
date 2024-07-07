
import 'package:job_seeker/Models/Class.dart';

class Student {
  final int idStudent;
  final String name;
  final int classId;
  final Classe classe;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool canDeleted;
  final DateTime? deletedAt;

  Student({
  required this.idStudent,
  required this.name,
  required this.classId,
  required this.classe,
  required this.createdAt,
  this.updatedAt,
  required this.canDeleted,
  this.deletedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
  return Student(
  idStudent: json['id_student'],
  name: json['name'],
  classId: json['class_id'],
  classe: Classe.fromJson(json['class']),
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
  'id_student': idStudent,
  'name': name,
  'class_id': classId,
  'class': classe.toJson(),
  'created_at': createdAt.toIso8601String(),
  'updated_at': updatedAt?.toIso8601String(),
  'can_deleted': canDeleted,
  'deleted_at': deletedAt?.toIso8601String(),
  };
  }
}
