import 'package:flutter/material.dart';

import '../design/campaign_builder_atmosphere.dart';
import '../parchment/campaign_builder_parchment.dart';
import 'stage_route_scaffold.dart';

class ParchmentRoutePage extends StatelessWidget {
  const ParchmentRoutePage({
    super.key,
    required this.atmosphere,
    required this.hero,
    required this.sidebar,
    this.sheet,
    this.errorBanner,
  });

  final CampaignAtmosphereData atmosphere;
  final Widget hero;
  final Widget? sheet;
  final Widget sidebar;
  final Widget? errorBanner;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1120;

    return StageRouteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hero,
          if (errorBanner != null) ...[
            const SizedBox(height: 18),
            errorBanner!,
          ],
          const SizedBox(height: 18),
          if (sheet != null && isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 11,
                  child: ParchmentUnfoldReveal(
                    atmosphere: atmosphere,
                    child: sheet!,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(flex: 7, child: sidebar),
              ],
            )
          else if (sheet != null)
            Column(
              children: [
                ParchmentUnfoldReveal(
                  atmosphere: atmosphere,
                  child: sheet!,
                ),
                const SizedBox(height: 18),
                sidebar,
              ],
            )
          else
            sidebar,
        ],
      ),
    );
  }
}
