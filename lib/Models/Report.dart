import 'dart:convert';

class Report {
  String caseId;
  String description;
  String imageURL;
  String latitude;
  String longitude;
  int severity;
  String userId;
  String status;
  String createdDate;
  String lastUpdated;
  String address;
  String locationPoint;

  Report({
    required this.caseId,
    required this.description,
    required this.imageURL,
    required this.latitude,
    required this.longitude,
    required this.severity,
    required this.userId,
    required this.status,
    required this.createdDate,
    required this.lastUpdated,
    required this.address,
    required this.locationPoint,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      caseId: json['case_id'] ?? '',
      description: json['description'] ?? '',
      imageURL: json['imageURL'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      severity: json['severity'] ?? 0,
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      createdDate: json['created_date'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
      address: json['address'] ?? '',
      locationPoint: json['location_point'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'case_id': caseId,
      'description': description,
      'imageURL': imageURL,
      'latitude': latitude,
      'longitude': longitude,
      'severity': severity,
      'userId': userId,
      'status': status,
      'created_date': createdDate,
      'last_updated': lastUpdated,
      'address': address,
      'location_point': locationPoint,
    };
  }

  String toJson() => json.encode(toMap());
}