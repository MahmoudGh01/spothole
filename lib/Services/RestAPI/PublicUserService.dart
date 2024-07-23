import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Utils/constants.dart';

class PublicUserService {
  Future<void> updateProfile(String userId, String email, String name, String photoUrl) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/profile/update'),
      body: {
        'userId': userId,
        'emailId': email,
        'name': name,
        'photoURL': photoUrl,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  Future<bool> validateUser(String emailId) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/user/validate'),
      body: {'emailId': emailId},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['status'] == 'allowed';
    } else {
      throw Exception('Failed to validate user');
    }
  }
}