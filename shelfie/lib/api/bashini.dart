import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final bashiniProvider = Provider<BashiniApi>((ref) => BashiniApi());

class BashiniApi {
  final _client = Dio(
    BaseOptions(
      baseUrl: 'https://meity-auth.ulcacontrib.org/ulca/apis/asr/v1/model',
    ),
  );

  final Logger _logger = Logger();

  void getBashiniModel(String modelId, String audioBase64, String languageCode) async {
    try {
      final response = await _client.post('/compute', data: {
        "modelId": modelId,
        "task": "asr",
        "audioContent": audioBase64,
        "source": languageCode,
        "userId": null
      });
      _logger.i('getBashiniModel ${response.data}');
    } catch (e) {
      _logger.e('getBashiniModel $e');
    }
  }
}
