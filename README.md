# ICS UI Application

ICS UI is a Flutter application that provides an intuitive and responsive user interface for AI/ML inference tasks, including image classification, object detection, sentiment analysis, and forecasting. 

This app demonstrates the use of Dart services, models, and pages to create a structured and maintainable Flutter project.

## Features

- **Image Classification**: Classify uploaded images using a pre-trained model.
- **Object Detection**: Detect objects within images and display their details.
- **Sentiment Analysis**: Analyze text to determine its sentiment (e.g., positive or negative).
- **Forecasting**: Predict future values based on historical time series data.

---

## Project Structure

```plaintext
lib
├── models                         # Data models for application logic
│   ├── detected_object.dart        # Model for detected objects
│   ├── detection_result.dart       # Model for object detection results
│   ├── inference_result.dart       # Model for general inference results
│   └── sentiment_result.dart       # Model for sentiment analysis results
├── pages                          # UI pages for user interaction
│   ├── forecast_page.dart          # Page for forecasting functionality
│   ├── image_classification_page.dart # Page for image classification
│   ├── landing_page.dart           # Landing/home page
│   ├── object_detection_page.dart  # Page for object detection
│   └── sentiment_page.dart         # Page for sentiment analysis
├── services                       # Service classes for business logic and APIs
│   ├── classification_service.dart # Handles image classification logic
│   ├── object_detection_service.dart # Handles object detection logic
│   └── sentiment_service.dart      # Handles sentiment analysis logic
└── main.dart                      # Entry point of the Flutter application
```

## Getting Started
### Prerequisites
Flutter SDK: Make sure you have Flutter installed. You can download it from Flutter's official website.
Dart SDK: Comes bundled with Flutter.
An editor or IDE such as Visual Studio Code or Android Studio.
### Installation
Clone the repository:

```bash
git clone https://github.com/eccsm/ics_ui.git
cd ics_ui
```
Install dependencies:

```bash
flutter pub get
```

Run the app:
```bash
flutter run
```

### Usage
Navigate through the app to explore the different features:

    1.Landing Page: Start here to navigate to other functionalities.

    2.Image Classification: Upload an image and classify it using AI models.

    3.Object Detection: Detect objects in an uploaded image.

    4.Sentiment Analysis: Analyze a piece of text for sentiment.

    5.Forecasting: Input time-series data and generate forecasts.

### Dependencies
Add any significant dependencies used in your project here. Example:

    http: For making HTTP requests.
    provider: For state management.
    flutter/material.dart: For building the UI.
    Check the full list in pubspec.yaml.

## License
This project is licensed under the MIT License - see the LICENSE file for details.