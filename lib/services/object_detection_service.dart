// lib/services/object_detection_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/detection_result.dart';

class ObjectDetectionService {
  final String baseUrl;

  ObjectDetectionService({required this.baseUrl});

  /// Sends the image to the backend's `/detect` endpoint and returns a list of detected objects.
  Future<DetectionResult> detectObjects(String imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/detect'));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonMap = json.decode(responseData);

      // Parse into a DetectionResult
      return DetectionResult.fromJson(jsonMap);
    } else {
      var responseData = await response.stream.bytesToString();
      throw Exception(
        "Failed to detect objects. Status: ${response.statusCode}\nMessage: $responseData",
      );
    }
  }
}
