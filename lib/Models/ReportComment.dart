import 'dart:convert';

class ReportComment {
  String userType;
  String commentId;
  String commentText;
  String caseId;
  String commentDateTime;

  ReportComment({
    required this.userType,
    required this.commentId,
    required this.commentText,
    required this.caseId,
    required this.commentDateTime,
  });

  factory ReportComment.fromJson(Map<String, dynamic> json) {
    return ReportComment(
      userType: json['user_type'] ?? '',
      commentId: json['comment_id'] ?? '',
      commentText: json['comment_text'] ?? '',
      caseId: json['case_id'] ?? '',
      commentDateTime: json['comment_date_time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_type': userType,
      'comment_id': commentId,
      'comment_text': commentText,
      'case_id': caseId,
      'comment_date_time': commentDateTime,
    };
  }

  String toJson() => json.encode(toMap());
}
