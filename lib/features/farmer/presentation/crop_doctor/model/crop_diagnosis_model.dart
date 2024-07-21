// lib/models/crop_diagnosis.dart
class CropDiagnosis {
  final String id;
  final String imagePath;
  final String diagnosis;
  final DateTime timestamp;

  CropDiagnosis({
    required this.id,
    required this.imagePath,
    required this.diagnosis,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'diagnosis': diagnosis,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CropDiagnosis.fromJson(Map<String, dynamic> json) {
    return CropDiagnosis(
      id: json['id'],
      imagePath: json['imagePath'],
      diagnosis: json['diagnosis'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}