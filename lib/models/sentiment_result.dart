// lib/models/sentiment_result.dart

class SentimentResult {
  final String sentiment;
  final double probability;

  SentimentResult({required this.sentiment, required this.probability});

  factory SentimentResult.fromJson(Map<String, dynamic> json) {
    return SentimentResult(
      sentiment: json['sentiment'] as String? ?? 'Unknown',
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
