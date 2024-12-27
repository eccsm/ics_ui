// lib/models/detected_object.dart

class DetectedObject {
  final String className;
  final double probability;

  DetectedObject({required this.className, required this.probability});

  factory DetectedObject.fromJson(Map<String, dynamic> json) {
    return DetectedObject(
      className: json['className'] as String? ?? 'Unknown',
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
