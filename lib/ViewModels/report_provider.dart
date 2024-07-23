import 'package:flutter/material.dart';

import '../Models/Report.dart';
import '../Models/ReportComment.dart';
import '../Services/RestAPI/ReportService.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();
  List<Report> _reports = [];
  List<ReportComment> _comments = [];

  List<Report> get reports => _reports;
  List<ReportComment> get comments => _comments;

  Future<void> fetchReportsByUser(String userId) async {
    try {
      _reports = await _reportService.getReportsByUser(userId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> submitReport(Report report) async {
    try {
      await _reportService.submitReport(report);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchCommentsByCase(String caseId) async {
    try {
      _comments = await _reportService.getCommentsByCase(caseId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> submitComment(String userType, String commentText, String caseId) async {
    try {
      await _reportService.submitComment(userType, commentText, caseId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> uploadFile(List<int> fileBytes) async {
    try {
      await _reportService.uploadFile(fileBytes);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> detectPothole(String imageUrl) async {
    try {
      return await _reportService.detectPothole(imageUrl);
    } catch (error) {
      throw error;
    }
  }
}
