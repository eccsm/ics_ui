// lib/models/detection_result.dart

import 'detected_object.dart';

class DetectionResult {
  final List<DetectedObject> objects;

  DetectionResult({required this.objects});

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    var list = json['objects'] as List? ?? [];
    List<DetectedObject> detectedObjects =
        list.map((item) => DetectedObject.fromJson(item)).toList();

    return DetectionResult(objects: detectedObjects);
  }
}
