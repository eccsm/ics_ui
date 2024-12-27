import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  // Controller for the single historical data input field
  final TextEditingController _historicalDataController = TextEditingController(
    text: "15.2,64.0,2.1,1015.0,15.8,60.0,2.3,1013.5,16.0,62.0,2.2,1014.0,15.5,63.0,2.1,1013.8,15.7,61.0,2.3,1014.2,15.9,60.5,2.2,1013.9,16.1,62.5,2.4,1014.1,15.6,63.5,2.2,1013.7,15.8,61.5,2.3,1014.3,16.0,62.5,2.2,1013.6,15.5,64.0,2.1,1014.0,15.7,60.0,2.3,1013.8,15.9,62.0,2.2,1014.2,16.1,61.0,2.4,1013.9",
  );

  // The user picks start date and end date to define forecast length
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = false;
  List<double> _forecastResults = [];

  // Helper to open a date picker for start date or end date
  Future<void> _pickDate({required bool isStart}) async {
    final today = DateTime.now();
    final initialDate = isStart
        ? (_startDate ?? today)
        : (_endDate ?? today);
    final firstDate = DateTime(2022);  // earliest date
    final lastDate = DateTime(2030);   // some future limit

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }


  int get _calculatedPredictionLength {
    if (_startDate == null || _endDate == null) return 0;
    final diff = _endDate!.difference(_startDate!).inDays;
    // if the user picks the same day for start & end, that might be 0 or 1 day
    return diff > 0 ? diff : 0;
  }

  Future<void> _getForecast() async {
    // parse the historical data from text
    final histStr = _historicalDataController.text.trim();

    if (histStr.isEmpty) {
      _showErrorDialog("Historical data cannot be empty.");
      return;
    }

    List<double> historicalData = [];
    List<int> invalidIndices = [];

    List<String> entries = histStr.split(",");
    if (entries.length != 56) {
      _showErrorDialog("Expected 56 data points, but got ${entries.length}. Please enter exactly 56 comma-separated float values.");
      return;
    }

    for (int i = 0; i < entries.length; i++) {
      String valueStr = entries[i].trim();
      if (valueStr.isEmpty) {
        invalidIndices.add(i + 1); // 1-based indexing for user-friendly messages
        continue;
      }
      try {
        double value = double.parse(valueStr);
        historicalData.add(value);
      } catch (e) {
        invalidIndices.add(i + 1);
      }
    }

    if (invalidIndices.isNotEmpty) {
      _showErrorDialog(
          "Invalid entries found at positions: ${invalidIndices.join(", ")}. Please enter valid numbers.");
      return;
    }

    if (_startDate == null || _endDate == null) {
      _showErrorDialog("Please pick both start date and end date.");
      return;
    }

    final predictionLength = _calculatedPredictionLength;
    if (predictionLength <= 0) {
      _showErrorDialog("End date must be after start date to get a valid forecast length.");
      return;
    }

    // Format startDate as an ISO string, e.g., 2024-12-26T09:40:32
    final startTimeStr = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(
      DateTime(_startDate!.year, _startDate!.month, _startDate!.day, 0, 0, 0)
    );

    // Build request JSON
    final requestBody = {
      "historicalData": historicalData,  // float[]
      "startTime": startTimeStr,         // string
      "predictionLength": predictionLength,
    };

    final uri = Uri.parse("http://localhost:8080/api/forecast");
    try {
      setState(() => _isLoading = true);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> arr = responseBody["forecast"];
        
        final List<double> preds = arr.map((e) {
          if (e is num) return e.toDouble();
          throw FormatException("Invalid number format in response.");
        }).toList();
        setState(() => _forecastResults = preds);
            } else {
        _showErrorDialog("Error: ${response.statusCode}\n${response.body}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog("Exception: $e");
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
  void dispose() {
    _historicalDataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final predictionLength = _calculatedPredictionLength;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forecasting"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                const Text(
                  "Enter Historical Data (56 comma-separated float values):",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                
                // Single TextField for historical data
                TextField(
                  controller: _historicalDataController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "e.g., 15.2,64.0,2.1,1015.0,15.8,60.0,2.3,1013.5,...",
                  ),
                  maxLines: null, // Allow multiple lines
                ),
                const SizedBox(height: 20),

                // Start date picker
                const Text(
                  "Select Start Date (the date your historical data ends):",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickDate(isStart: true),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Pick Start Date"),
                    ),
                    const SizedBox(width: 10),
                    Text(_startDate == null
                        ? "No date chosen"
                        : DateFormat("yyyy-MM-dd").format(_startDate!)),
                  ],
                ),
                const SizedBox(height: 20),

                // End date picker
                const Text(
                  "Select End Date (the day you want to forecast up to):",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickDate(isStart: false),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Pick End Date"),
                    ),
                    const SizedBox(width: 10),
                    Text(_endDate == null
                        ? "No date chosen"
                        : DateFormat("yyyy-MM-dd").format(_endDate!)),
                  ],
                ),
                const SizedBox(height: 20),

                // Display calculated predictionLength
                Text(
                  "Calculated Prediction Length: $predictionLength days",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _getForecast,
                  child: const Text("Get Forecast"),
                ),
                const SizedBox(height: 20),

                if (_forecastResults.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Forecast Results:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "We forecast $predictionLength days from ${_startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : ''} to ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : ''}:",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      // Display forecasts in a list
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _forecastResults.length,
                        itemBuilder: (context, index) {
                          return Text(
                            "Day ${index + 1}: ${_forecastResults[index].toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 14),
                          );
                        },
                      ),
                    ],
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
