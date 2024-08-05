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
      locationPoint: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'locationLatLng': {
        'lat': latitude,
        'lng': longitude,
      },
      'imageURL': imageURL,
      'address': address,
      'status': status,
      'severity': severity,
      'userId': userId,
      'createdDate': createdDate,
    };
  }

  String toJson() => json.encode(toMap());
}
