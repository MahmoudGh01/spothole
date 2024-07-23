import 'dart:convert';

// Authority model
class Authority {
  String authorityId;
  String emailId;
  String name;
  String photoUrl;
  String latitude;
  String longitude;
  String address;

  Authority({
    required this.authorityId,
    required this.emailId,
    required this.name,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      authorityId: json['authority_id'] ?? '',
      emailId: json['email_id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authority_id': authorityId,
      'email_id': emailId,
      'name': name,
      'photo_url': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  String toJson() => json.encode(toMap());
}
