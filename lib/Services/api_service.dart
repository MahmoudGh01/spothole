import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/base_model.dart';
import '../Utils/constants.dart';



class ApiService<T extends BaseModel> {
  final String endpoint;
  final T Function(Map<String, dynamic>) fromJson;

  ApiService({required this.endpoint, required this.fromJson});

  Future<List<T>> getAll() async {
    final response = await http.get(Uri.parse('${Constants.uri}/$endpoint'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<T> getById(String id) async {
    final response = await http.get(Uri.parse('${Constants.uri}/$endpoint/$id'));
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load item details');
    }
  }

  Future<List<T>> create(T newItem) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newItem.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return getAll(); // Return the updated list of items
    } else {
      throw Exception('Failed to create item. Server returned ${response.statusCode}');
    }
  }

  Future<List<T>> edit(T updatedItem, String id) async {
    final response = await http.put(
      Uri.parse('${Constants.uri}/$endpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedItem.toJson()),
    );

    if (response.statusCode == 200) {
      return getAll(); // Return the updated list of items
    } else {
      throw Exception('Failed to edit item');
    }
  }

  Future<List<T>> delete(String id) async {
    final response = await http.delete(Uri.parse('${Constants.uri}/$endpoint/$id'));

    if (response.statusCode == 200) {
      return getAll(); // Return the updated list of items
    } else {
      throw Exception('Failed to delete item');
    }
  }
}
