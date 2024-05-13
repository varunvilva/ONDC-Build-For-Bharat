import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

final geminiProvider = Provider<GeminiApi>((ref) => GeminiApi());

class GeminiApi {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'https://ondc-build-for-bharat.onrender.com/',
      // baseUrl: 'http://localhost:3000/',
      validateStatus: (status) {
        return status! <= 500;
      },
    ),
  );
  final Logger _logger = Logger();

  // Define headers
  final Map<String, String> _headers = {
    "Access-Control_Allow_Origin": "*"
  };

  void testApiCall() async {
    try {
      // _client.options.headers['Origin'] = 'https://shelfie-8bdc6.web.app:4368348125';
      final response = await _client.get(
        '/',
      );
      _logger.i(response.data);
    } catch (e) {
      _logger.e('testApiCall $e');
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
