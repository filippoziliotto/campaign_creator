class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://YOUR_PRODUCTION_BACKEND_URL',
  );

  // TODO: replace with real Play Store URL after publishing
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.fzlabs.campaignforge';

  // TODO: replace idPLACEHOLDER with real Apple App Store ID after publishing
  static const String appStoreUrl =
      'https://apps.apple.com/app/campaign-forge/idPLACEHOLDER';
}
