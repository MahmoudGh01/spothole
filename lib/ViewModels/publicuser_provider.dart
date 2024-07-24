import 'package:flutter/material.dart';

import '../Services/RestAPI/PublicUserService.dart';

class PublicUserProvider with ChangeNotifier {
  final PublicUserService _publicUserService = PublicUserService();

  Future<void> updateProfile(String userId, String email, String name, String photoUrl) async {
    try {
      await _publicUserService.updateProfile(userId, email, name, photoUrl);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> validateUser(String emailId) async {
    try {
      return await _publicUserService.validateUser(emailId);
    } catch (error) {
      throw error;
    }
  }
}
