import '../models/campaign_models.dart';

abstract class CampaignService {
  Future<CampaignOptions> getOptions({String lang = 'it'});
  Future<String> generatePrompt(CampaignGenerateRequest request);
}
