import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final bashiniProvider = Provider<BashiniASRApi>((ref) => BashiniASRApi());

class BashiniASRApi {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'https://meity-auth.ulcacontrib.org/ulca/apis/asr/v1/model',
    ),
  );

  final Logger _logger = Logger();

  Future<String> bashiniASR(String modelId, String audioBase64, String languageCode) async {
    try {
      final response = await _client.post(
        '/compute',
        data: {"modelId": modelId, "task": "asr", "audioContent": audioBase64, "source": languageCode, "userId": null},
      );
      _logger.i('Bashini Response ${response.data['data']['source']}');
      return response.data['data']['source'];
    } catch (e) {
      _logger.e('getBashiniModel $e');
      return '';
    }
  }
}
