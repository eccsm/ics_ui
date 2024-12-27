// lib/pages/object_detection_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/detected_object.dart';
import '../models/detection_result.dart';
import '../services/object_detection_service.dart';


class ObjectDetectionPage extends StatefulWidget {
  const ObjectDetectionPage({super.key});

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  File? _selectedImage;
  bool _isLoading = false;

  List<DetectedObject> _objects = []; // typed list instead of dynamic

  // Example: Provide your actual backend base URL
  final ObjectDetectionService _service = ObjectDetectionService(
    baseUrl: "http://localhost:8080/api",
  );

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _objects.clear();
      });
    }
  }

  Future<void> _detectObjects() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);

    try {
      DetectionResult result =
          await _service.detectObjects(_selectedImage!.path);

      setState(() {
        _objects = result.objects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog("Failed to detect objects:\n$e");
    }
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
        title: const Text('Object Detection'),
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
                    : Image.file(
                        _selectedImage!,
                        fit: BoxFit.contain,
                      ),
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
                  icon: const Icon(Icons.search),
                  onPressed: _detectObjects,
                  label: const Text("Detect Objects"),
                ),
              ],
              const SizedBox(height: 20),
              if (_objects.isNotEmpty) ...[
                const Text(
                  "Detected Objects:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var obj in _objects)
                  Text(
                    "${obj.className} - ${(obj.probability * 100).toStringAsFixed(2)}%",
                  ),
              ],
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
