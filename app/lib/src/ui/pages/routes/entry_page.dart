import 'package:flutter/material.dart';

import 'stage_route_scaffold.dart';

class EntryRoutePage extends StatelessWidget {
  const EntryRoutePage({
    super.key,
    this.hero,
    required this.campaignModeGrid,
    this.errorBanner,
    this.resumePanel,
    this.scrollController,
  });

  final Widget? hero;
  final Widget campaignModeGrid;
  final Widget? errorBanner;
  final Widget? resumePanel;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return StageRouteScaffold(
      scrollController: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero != null) hero!,
          if (errorBanner != null) ...[
            if (hero != null) const SizedBox(height: 16),
            errorBanner!,
          ],
          const SizedBox(height: 14),
          campaignModeGrid,
          if (resumePanel != null) ...[
            const SizedBox(height: 20),
            resumePanel!,
          ],
        ],
      ),
    );
  }
}
