// lib/models/inference_result.dart

class InferenceResult {
  final String className;
  final double probability;

  InferenceResult({
    required this.className,
    required this.probability,
  });

  // Construct from JSON
  factory InferenceResult.fromJson(Map<String, dynamic> json) {
    return InferenceResult(
      className: json['className'] as String? ?? 'Unknown',
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
