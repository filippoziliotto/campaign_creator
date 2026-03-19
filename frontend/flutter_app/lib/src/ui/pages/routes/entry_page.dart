import 'package:flutter/material.dart';

import 'stage_route_scaffold.dart';

class EntryRoutePage extends StatelessWidget {
  const EntryRoutePage({
    super.key,
    this.hero,
    required this.campaignModeGrid,
    this.errorBanner,
    this.resumePanel,
  });

  final Widget? hero;
  final Widget campaignModeGrid;
  final Widget? errorBanner;
  final Widget? resumePanel;

  @override
  Widget build(BuildContext context) {
    return StageRouteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero != null) hero!,
          if (errorBanner != null) ...[
            if (hero != null) const SizedBox(height: 18),
            errorBanner!,
          ],
          const SizedBox(height: 18),
          campaignModeGrid,
          if (resumePanel != null) ...[
            const SizedBox(height: 18),
            resumePanel!,
          ],
        ],
      ),
    );
  }
}
