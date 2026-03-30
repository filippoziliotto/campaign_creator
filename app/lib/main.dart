import 'dart:async';

import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/monetization/app_consent_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appConsentManager.gatherConsent();
  await appConsentManager.initializeAdsIfAllowed();
  runApp(const CampaignCreatorApp());
}
