// lib/pages/classification_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/inference_result.dart';
import '../services/classification_service.dart';

class ImageClassificationPage extends StatefulWidget {
  const ImageClassificationPage({super.key});

  @override
  State<ImageClassificationPage> createState() => _ImageClassificationPageState();
}

class _ImageClassificationPageState extends State<ImageClassificationPage> {
  File? _selectedImage;
  bool _isLoading = false;

  // Example: set your backend base URL
  // e.g., "http://10.0.2.2:8080/api" for local dev on Android emulator
  final ClassificationService _service = ClassificationService(
    baseUrl: 'http://localhost:8080/api',
  );

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _classifyImage() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);

    try {
      // Use the ClassificationService
      InferenceResult result = await _service.classifyImage(_selectedImage!.path);

      setState(() => _isLoading = false);

      // Show the dialog with the classification result
      _showResultDialog(
        "Class: ${result.className}\n"
        "Probability: ${(result.probability * 100).toStringAsFixed(2)}%"
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog("An error occurred:\n$e");
    }
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Classification Result"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Close this dialog and return to screen behind it
              Navigator.of(context).pop(); // pop the dialog
            },
            child: const Text("OK"),
          )
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
            onPressed: () {
              // Close dialog
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Classification'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                height: 250,
                color: Colors.grey[200],
                child: _selectedImage == null
                    ? const Center(child: Text('No image selected'))
                    : Image.file(_selectedImage!, fit: BoxFit.contain),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                onPressed: _pickImage,
                label: const Text("Pick Image"),
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: _classifyImage,
                  label: const Text("Classify Image"),
                ),
              ]
            ],
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
