import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_seeker/Utils/alert_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';
import '../Utils/constants.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    lastname: '',
    email: '',
    token: '',
    password: '',
    profilePicturePath: '',
    birthdate: '',
    phone: '',
    role: 'user',
    refresh: '',
  );


  User get user => _user;
  Map<String, User> _reportUsers = {}; // Store fetched report users by user ID

  void setUser(Map<String, dynamic> userMap) {
    _user = User.fromJson(userMap);
    notifyListeners();
  }
  User? getReportUser(String userId) {
    return _reportUsers[userId];
  }
  void setReportUser(String userId, Map<String, dynamic> userMap) {
    _reportUsers[userId] = User.fromJson(userMap);
    notifyListeners();
  }
  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void setPasswordResetEmail(String email) {
    _user.email = email;
    notifyListeners();
  }



  void addSkill(String skill) {
    if (!_user.skills.contains(skill)) {
      _user.skills.add(skill);
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _user.skills.remove(skill);
    notifyListeners();
  }

  Future<bool> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh');
    if (refreshToken == null) return false;

    try {
      var response = await http.post(
        Uri.parse('${Constants.uri}/refreshToken'),
        headers: {
          'Content-Type': "application/json; charset=UTF-8",
          'Authorization': "Bearer $refreshToken"
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String newAccessToken = body['access_token'];
        await prefs.setString(
            'token', newAccessToken); // Save the new access token
        return true; // Indicate success
      }
      return false; // Indicate failure
    } catch (e) {
      print(e.toString());
      return false; // Indicate failure on exception
    }
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // No token available, user needs to log in
      prefs.setString('token', '');
  return;
    }

    var tokenRes = await http.get(
      Uri.parse('${Constants.uri}/tokenIsValid'),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
        'Authorization': "Bearer $token"
      },
    );

    var body = jsonDecode(tokenRes.body);

    if (tokenRes.statusCode == 200 && body["valid"] == true) {
      // Token is valid, process user data
      prefs.setString('token', token!); // Refresh the token in local storage if needed

      var userMap = body as Map<String, dynamic>;
      setUser(userMap); // Assuming setUser is a method to update user info in the app
      notifyListeners();

    } else if (tokenRes.statusCode == 401 ||tokenRes.statusCode == 500|| tokenRes.statusCode == 422  || !body["valid"]) {
      // Token is not valid or expired, try to refresh it
      bool refreshed = await refreshToken();
      if (refreshed) {
        // If token refresh was successful, fetch user data again
        await fetchUserData();
      } else {
        prefs.remove('token');
        // Unable to refresh the token, possibly log the user out or prompt re-login
        print("Unable to refresh token. User must log in again.");
      }
    } else {
      // Handle other errors or scenarios as needed
      print("An error occurred: ${body['message']}");
    }
  }

  Future<void> editUser({
    required String userId,
    required String name,
    required String email,
    String? profilePicturePath,
    String? lastname,
    String? phone,
    String? birthdate,
    String? role,
    List<String>? skills,
  }) async {
    try {
      Uri uri = Uri.parse('${Constants.uri}/edit-user/$userId');
      Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'profile_picture': profilePicturePath ?? '',
        'lastname': lastname ?? '',
        'phone': phone ?? '',
        'birthdate': birthdate ?? '',
        'role': role ?? 'User',
        'skills': skills ?? [],
      };

      http.Response res = await http.put(
        uri,
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8"
        },
      );

      if (res.statusCode == 200) {
        //success(context);
        fetchUserData(); // Refresh user data after update
      } else {
        print('Failed to update user details: ${res.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchUserById(String userId) async {
    // If user is already cached, no need to refetch
    if (_reportUsers.containsKey(userId)) return;

    try {
      Uri uri = Uri.parse('${Constants.uri}/users/$userId');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        var userMap = jsonDecode(response.body) as Map<String, dynamic>;
        setReportUser(userId, userMap);
      } else {
        print('Failed to fetch user by ID: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

}
