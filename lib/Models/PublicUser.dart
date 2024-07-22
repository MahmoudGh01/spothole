import 'dart:convert';

class PublicUser {
  String userId;
  String emailId;
  String name;
  String badge;
  String photoUrl;
  String status;

  PublicUser({
    required this.userId,
    required this.emailId,
    required this.name,
    required this.badge,
    required this.photoUrl,
    required this.status,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      userId: json['user_id'] ?? '',
      emailId: json['email_id'] ?? '',
      name: json['name'] ?? '',
      badge: json['badge'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email_id': emailId,
      'name': name,
      'badge': badge,
      'photo_url': photoUrl,
      'status': status,
    };
  }

  String toJson() => json.encode(toMap());
}