import '../models/campaign_models.dart';

abstract class CampaignService {
  Future<CampaignOptions> getOptions({String localeCode = 'it'});
  Future<String> generatePrompt(CampaignGenerateRequest request);
}
