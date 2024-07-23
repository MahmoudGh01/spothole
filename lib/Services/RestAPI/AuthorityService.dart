import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_seeker/Services/api_service.dart';

import '../../Models/Authority.dart';
import '../../Models/Report.dart';
import '../../Models/ReportComment.dart';
import '../../Utils/constants.dart';


// AuthorityService
class AuthorityService  {
  Future<List<Report>> getAllReports() async {
    final response = await http.post(Uri.parse('${Constants.uri}/api/reports/all'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Report.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }

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

  Future<void> submitReport(Report report) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/api/submit/report'),
      body: report.toMap(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to submit report');
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
