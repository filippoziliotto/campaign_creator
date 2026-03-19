import 'dart:convert';

import 'package:campaign_creator_flutter/src/models/campaign_models.dart';
import 'package:campaign_creator_flutter/src/services/backend_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('BackendApi.getOptions', () {
    test('loads and parses options from the backend', () async {
      late Uri requestedUri;
      final api = BackendApi(
        baseUrl: 'http://localhost:8000/',
        client: MockClient((request) async {
          requestedUri = request.url;
          return http.Response(
            jsonEncode({
              'settings': ['Ravenloft'],
              'campaign_types': ['One-Shot'],
              'themes': ['Horror'],
              'tones': ['Cupo'],
              'styles': ['Lineare'],
              'party_archetypes': ['Occultista'],
              'twists': ['Il mostro siete voi'],
              'presets': {},
              'setting_descriptions': {'Ravenloft': 'Nebbie e castelli.'},
              'preset_descriptions': {},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final options = await api.getOptions();

      expect(requestedUri.toString(), 'http://localhost:8000/options');
      expect(options.settings, ['Ravenloft']);
      expect(options.settingDescriptions['Ravenloft'], 'Nebbie e castelli.');
    });

    test('surfaces backend detail for non-200 responses', () async {
      final api = BackendApi(
        baseUrl: 'http://localhost:8000',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'detail': 'options.yaml mancante'}),
            500,
            headers: {'content-type': 'application/json'},
          ),
        ),
      );

      expect(
        api.getOptions(),
        throwsA(
          isA<BackendApiException>().having(
            (error) => error.message,
            'message',
            'HTTP 500 - options.yaml mancante',
          ),
        ),
      );
    });

    test('rejects invalid payload shapes', () async {
      final api = BackendApi(
        baseUrl: 'http://localhost:8000',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode(['not', 'a', 'map']),
            200,
            headers: {'content-type': 'application/json'},
          ),
        ),
      );

      expect(
        api.getOptions(),
        throwsA(
          isA<BackendApiException>().having(
            (error) => error.message,
            'message',
            'Invalid options payload format.',
          ),
        ),
      );
    });
  });

  group('BackendApi.generatePrompt', () {
    test('posts request payload and returns the generated prompt', () async {
      late Map<String, dynamic> requestBody;
      late String contentType;
      final api = BackendApi(
        baseUrl: 'http://localhost:8000/',
        client: MockClient((request) async {
          contentType = request.headers['Content-Type'] ?? '';
          requestBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'prompt': 'Titolo\nDettaglio della campagna'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final prompt = await api.generatePrompt(
        CampaignGenerateRequest(
          setting: 'Planescape',
          campaignType: 'Mini-campagna',
          themePreferences: ['Mistero'],
          tonePreferences: ['Visionario'],
          stylePreferences: ['Sandbox'],
          partyLevel: 7,
          partySize: 5,
          partyArchetypes: ['Face'],
          twist: 'Le porte mentono',
          narrativeHooks: 'Recuperare una chiave planare.',
          characterNotes: '',
          constraints: '',
          factions: 'Societa delle Sensazioni',
          npcFocus: '',
          encounterFocus: '',
          safetyNotes: '',
          includeNpcs: true,
          includeEncounters: true,
        ),
      );

      expect(contentType, 'application/json');
      expect(requestBody['setting'], 'Planescape');
      expect(requestBody['campaign_type'], 'Mini-campagna');
      expect(requestBody['party_level'], 7);
      expect(prompt, 'Titolo\nDettaglio della campagna');
    });

    test('rejects empty prompt payloads', () async {
      final api = BackendApi(
        baseUrl: 'http://localhost:8000',
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'prompt': '   '}),
            200,
            headers: {'content-type': 'application/json'},
          ),
        ),
      );

      expect(
        api.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Greyhawk',
            campaignType: 'One-Shot',
            themePreferences: const [],
            tonePreferences: const [],
            stylePreferences: const [],
            partyLevel: 1,
            partySize: 4,
            partyArchetypes: const [],
            twist: '',
            narrativeHooks: '',
            characterNotes: '',
            constraints: '',
            factions: '',
            npcFocus: '',
            encounterFocus: '',
            safetyNotes: '',
            includeNpcs: true,
            includeEncounters: true,
          ),
        ),
        throwsA(
          isA<BackendApiException>().having(
            (error) => error.message,
            'message',
            'Prompt payload is empty.',
          ),
        ),
      );
    });

    test('falls back to plain HTTP status when detail is absent', () async {
      final api = BackendApi(
        baseUrl: 'http://localhost:8000',
        client: MockClient(
          (_) async => http.Response('server down', 503),
        ),
      );

      expect(
        api.generatePrompt(
          CampaignGenerateRequest(
            setting: 'Greyhawk',
            campaignType: 'One-Shot',
            themePreferences: const [],
            tonePreferences: const [],
            stylePreferences: const [],
            partyLevel: 1,
            partySize: 4,
            partyArchetypes: const [],
            twist: '',
            narrativeHooks: '',
            characterNotes: '',
            constraints: '',
            factions: '',
            npcFocus: '',
            encounterFocus: '',
            safetyNotes: '',
            includeNpcs: true,
            includeEncounters: true,
          ),
        ),
        throwsA(
          isA<BackendApiException>().having(
            (error) => error.message,
            'message',
            'HTTP 503',
          ),
        ),
      );
    });
  });
}
