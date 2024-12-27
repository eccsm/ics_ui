// lib/services/classification_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/inference_result.dart';


class ClassificationService {
  final String baseUrl;

  ClassificationService({required this.baseUrl});

  /// Sends the image file to the backend and returns the best class result.
  /// [imagePath]: local path to the image file.
  Future<InferenceResult> classifyImage(String imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/classify'));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonMap = json.decode(responseData);

      // If the JSON is like:
      // { "className": "...", "probability": 0.12 }
      return InferenceResult.fromJson(jsonMap);
    } else {
      var responseData = await response.stream.bytesToString();
      throw Exception(
        "Failed to classify. Status: ${response.statusCode}\nMessage: $responseData",
      );
    }
  }
}
