import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_seeker/Views/job_gloabelclass/job_icons.dart';
import 'package:job_seeker/Views/job_pages/job_home/job_applyjob.dart';

import '../../Models/Report.dart';
import '../../Models/ReportComment.dart';
import '../../Utils/alert_dialog.dart';
import '../../Utils/constants.dart';

class ReportService {
  Future<List<Report>> getReportsByUser(String userId) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/reports'),
      body: {'userId': userId},
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Report.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }
  Future<void> submitReport(BuildContext context,Report report) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/submit/report'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: report.toJson(),
    );

    if (response.statusCode != 200) {
      showDialog(
        context: context,
        builder: (context) => GlobalAlertDialog(
          imagePath: JobPngimage.applyfail,
          title: 'Oops, Failed!',
          titleColor: Colors.red,
          message: 'Please check your internet connection then try again.',
          primaryButtonText: 'Try Again',
          primaryButtonAction: () {
            // Retry action
            Navigator.pop(context); // Close the dialog
          },
          secondaryButtonText: 'Cancel',
          secondaryButtonAction: () {
            Navigator.pop(context); // Close the dialog
          },
        ),
      );
      // Print response details for debugging

      print('Failed to submit report: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to submit report');
    }
    showDialog(
      context: context,
      builder: (context) => GlobalAlertDialog(
        imagePath: JobPngimage.successlogo,
        title: 'Reported Submitted',
        titleColor: Colors.green,
        message: 'Your Report has been successfully submitted. You can track the progress of your case through My Reports.',
        primaryButtonText: 'Go to My Reports',
        primaryButtonAction: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const JobApply();
          },));
          // Navigate to applications
          Navigator.pop(context); // Close the dialog
        },
        secondaryButtonText: 'Exit',
        secondaryButtonAction: () {
          Navigator.pop(context); // Close the dialog
        },
      ),
    );
  }


  Future<List<ReportComment>> getCommentsByCase(String caseId) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/reports/comments'),
      body: {'caseId': caseId},
    );
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => ReportComment.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> submitComment(String userType, String commentText, String caseId) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/submit/report/comment'),
      body: {
        'userType': userType,
        'commentText': commentText,
        'caseId': caseId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to submit comment');
    }
  }

  Future<void> uploadFile(List<int> fileBytes) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/upload'),
      body: {'bytes': base64Encode(fileBytes)},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to upload file');
    }
  }

  Future<bool> detectPothole(String imageUrl) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/detect/single'),
      body: {'image_url': imageUrl},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      throw Exception('Failed to detect pothole');
    }
  }
}
