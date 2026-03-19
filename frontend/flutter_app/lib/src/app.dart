import 'package:flutter/material.dart';

import 'theme/fantasy_theme.dart';
import 'ui/pages/shell/campaign_builder_page.dart';

class CampaignCreatorApp extends StatelessWidget {
  const CampaignCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creatore Campagne D&D',
      debugShowCheckedModeBanner: false,
      theme: buildFantasyTheme(),
      home: const CampaignBuilderPage(),
    );
  }
}
