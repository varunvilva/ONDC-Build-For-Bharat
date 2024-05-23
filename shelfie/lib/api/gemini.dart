import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

final geminiProvider = Provider<GeminiApi>((ref) => GeminiApi());

class GeminiApi {
  final _client = Dio(
    BaseOptions(
      // baseUrl: 'https://dummyjson.com/products/1',
      baseUrl: 'https://ondc-build-for-bharat.onrender.com',
      //  baseUrl: 'https://35.200.151.42',
      validateStatus: (status) {
        return status! <= 500;
      },
    ),
  );
  final Logger _logger = Logger();

  void testApiCall(BuildContext context) async {
    try {
      // _client.options.headers["Access-Control-Allow-Origin"] = "*";
      // _client.options.headers["Access-Control-Allow-Credentials"] = true;
      // _client.options.headers["Access-Control-Allow-Headers"] =
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale";
      // _client.options.headers["Access-Control-Allow-Methods"] = "GET, HEAD, POST, OPTIONS";
      final response = await _client.get(
        '/',
      );
      _logger.i(response.data);
      _logger.i(response.statusCode);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Response'),
              content: Text(response.data.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      _logger.e('testApiCall $e');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<String> proVisionModel({required XFile image}) async {
    try {
      // Read image as bytes
      final imageBytes = await image.readAsBytes();
      // Convert image bytes to base64
      final base64Image = base64Encode(imageBytes);

      // Define payload
      final payload = {
        'image': base64Image,
        // Add any other required parameters here
      };

      // Make POST request
      final response = await _client.post(
        '/pro-vision',
        data: jsonEncode(payload),
      );

      // Handle response
      if (response.statusCode == 200) {
        return jsonEncode(response.data);
      } else {
        _logger.e('Failed to execute proVisionModel request');
        return ''; // or handle the error accordingly
      }
    } catch (e) {
      _logger.e('proVisionModel $e');
      return ''; // or handle the error accordingly
    }
  }

  Future<String> proModel({required String prompt}) async {
    try {
      // Make POST request
      final response = await _client.post(
        '/pro-text',
        data: {
          'text': prompt,
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        return jsonEncode(response.data);
      } else {
        _logger.e('Failed to execute proModel request');
        return ''; // or handle the error accordingly
      }
    } catch (e) {
      _logger.e('proModel $e');
      return ''; // or handle the error accordingly
    }
  }
}
