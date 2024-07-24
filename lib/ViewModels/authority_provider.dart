import 'package:flutter/material.dart';
import '../Models/Report.dart';
import '../Models/ReportComment.dart';
import '../Services/RestAPI/AuthorityService.dart';


class AuthorityProvider with ChangeNotifier {
  final AuthorityService _authorityService = AuthorityService();
  List<Report> _reports = [];
  List<ReportComment> _comments = [];

  List<Report> get reports => _reports;
  List<ReportComment> get comments => _comments;

  Future<void> fetchAllReports() async {
    try {
      _reports = await _authorityService.getAllReports();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchReportsByUser(String userId) async {
    try {
      _reports = await _authorityService.getReportsByUser(userId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> submitComment(String userType, String commentText, String caseId) async {
    try {
      await _authorityService.submitComment(userType, commentText, caseId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchCommentsByCase(String caseId) async {
    try {
      _comments = await _authorityService.getCommentsByCase(caseId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> submitReport(Report report) async {
    try {
      await _authorityService.submitReport(report);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> uploadFile(List<int> fileBytes) async {
    try {
      await _authorityService.uploadFile(fileBytes);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> detectPothole(String imageUrl) async {
    try {
      return await _authorityService.detectPothole(imageUrl);
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProfile(String userId, String email, String name, String photoUrl) async {
    try {
      await _authorityService.updateProfile(userId, email, name, photoUrl);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> validateUser(String emailId) async {
    try {
      return await _authorityService.validateUser(emailId);
    } catch (error) {
      throw error;
    }
  }
}