import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_seeker/Utils/constants.dart';
import '../models/school.dart';

class ApiService {

  // Fetch all schools
  Future<List<School>> fetchSchools() async {
    final response = await http.get(Uri.parse('${Constants.uri}/schools'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => School.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load schools');
    }
  }

  // Fetch school by ID
  Future<School> fetchSchoolById(int id) async {
    final response = await http.get(Uri.parse('${Constants.uri}/schools/$id'));
    if (response.statusCode == 200) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load school');
    }
  }

  // Create a new school
  Future<School> createSchool(School school) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/schools'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );
    if (response.statusCode == 201) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create school');
    }
  }

  // Update an existing school
  Future<School> updateSchool(School school) async {
    final response = await http.put(
      Uri.parse('${Constants.uri}/schools/${school.idSchool}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );
    if (response.statusCode == 200) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update school');
    }
  }

  // Delete a school
  Future<void> deleteSchool(int id) async {
    final response = await http.delete(Uri.parse('${Constants.uri}/schools/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete school');
    }
  }

// Similar CRUD operations for Class and Student can be implemented
}
