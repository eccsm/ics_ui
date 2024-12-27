// lib/pages/sentiment_page.dart

import 'package:flutter/material.dart';

import '../models/sentiment_result.dart';
import '../services/sentiment_service.dart';


class SentimentPage extends StatefulWidget {
  const SentimentPage({super.key});

  @override
  State<SentimentPage> createState() => _SentimentPageState();
}

class _SentimentPageState extends State<SentimentPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // Provide your actual backend base URL
  final SentimentService _service = SentimentService(
    baseUrl: "http://localhost:8080/api",
  );

  Future<void> _analyzeSentiment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      SentimentResult result = await _service.analyzeSentiment(text);

      setState(() => _isLoading = false);

      _showResultDialog(
        "Sentiment: ${result.sentiment}\n"
        "Probability: ${(result.probability * 100).toStringAsFixed(2)}%"
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog("Failed to analyze sentiment:\n$e");
    }
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sentiment Result"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentiment Analysis'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text("Enter text to analyze:"),
                TextField(controller: _controller),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.analytics),
                  onPressed: _analyzeSentiment,
                  label: const Text("Analyze Sentiment"),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            )
        ],
      ),
    );
  }
}
