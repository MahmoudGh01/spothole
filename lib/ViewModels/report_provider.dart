import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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

  Future<void> submitReport(BuildContext context,Report report) async {
    print(report.toJson());
    try {
      print(report.toJson());
      await _reportService.submitReport(context,report);

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

  Future<String?> uploadFile(File file) async {
    try {

        var fileUrl = await _reportService.uploadFile(file);
        notifyListeners();
        return fileUrl;


    } catch (error) {
      throw error;
    }
  }


}
