// lib/pages/landing_page.dart

import 'package:flutter/material.dart';
import 'forecast_page.dart';
import 'image_classification_page.dart';
import 'object_detection_page.dart';
import 'sentiment_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen dimensions for responsive design
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('AI Features')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the grid
            child: GridView.count(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: 20, // Vertical spacing
              crossAxisSpacing: 20, // Horizontal spacing
              childAspectRatio: (screenWidth / 2 - 24) /
                  ((screenHeight - 100) / 2), 
              // Adjust childAspectRatio based on screen size
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Image Classification Button
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ImageClassificationPage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.teal, // Button background color
                    backgroundColor: Colors.white, // text color
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40),
                      SizedBox(height: 10),
                      Text("Image Classification"),
                    ],
                  ),
                ),

                // Object Detection Button
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ObjectDetectionPage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam, size: 40),
                      SizedBox(height: 10),
                      Text("Object Detection"),
                    ],
                  ),
                ),

                // Sentiment Analysis Button
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SentimentPage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sentiment_satisfied, size: 40),
                      SizedBox(height: 10),
                      Text("Sentiment Analysis"),
                    ],
                  ),
                ),

                // Forecast Button
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForecastPage(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.trending_up, size: 40),
                      SizedBox(height: 10),
                      Text("Forecast"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
