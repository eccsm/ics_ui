// lib/services/sentiment_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/sentiment_result.dart';


class SentimentService {
  final String baseUrl;

  SentimentService({required this.baseUrl});

  /// Sends text to the backend's `/sentiment?text=...` endpoint and returns
  /// a [SentimentResult].
  Future<SentimentResult> analyzeSentiment(String text) async {
    final uri = Uri.parse('$baseUrl/sentiment?text=${Uri.encodeQueryComponent(text)}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonMap = json.decode(response.body);
      return SentimentResult.fromJson(jsonMap);
    } else {
      throw Exception(
        "Failed to analyze sentiment. Status: ${response.statusCode}\nMessage: ${response.body}",
      );
    }
  }
}
