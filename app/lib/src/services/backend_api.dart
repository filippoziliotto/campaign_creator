import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/campaign_models.dart';

class BackendApi {
  BackendApi({required String baseUrl, http.Client? client})
      : _baseUrl = baseUrl.replaceAll(RegExp(r'/+$'), ''),
        _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;

  Future<CampaignOptions> getOptions() async {
    final response = await _client.get(_uri('/options'));
    if (response.statusCode != 200) {
      throw BackendApiException.fromResponse(response);
    }

    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body is! Map<String, dynamic>) {
      throw const BackendApiException('Invalid options payload format.');
    }

    return CampaignOptions.fromJson(body);
  }

  Future<String> generatePrompt(CampaignGenerateRequest request) async {
    final response = await _client.post(
      _uri('/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw BackendApiException.fromResponse(response);
    }

    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body is! Map<String, dynamic>) {
      throw const BackendApiException('Invalid generate payload format.');
    }

    final prompt = body['prompt']?.toString() ?? '';
    if (prompt.trim().isEmpty) {
      throw const BackendApiException('Prompt payload is empty.');
    }

    return prompt;
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');
}

class BackendApiException implements Exception {
  const BackendApiException(this.message);

  final String message;

  factory BackendApiException.fromResponse(http.Response response) {
    final fallback = 'HTTP ${response.statusCode}';
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail']?.toString();
        if (detail != null && detail.trim().isNotEmpty) {
          return BackendApiException('$fallback - $detail');
        }
      }
    } catch (_) {
      // Keep fallback.
    }
    return BackendApiException(fallback);
  }

  @override
  String toString() => message;
}
