import 'package:flutter/material.dart';

import 'stage_route_scaffold.dart';

class ForgeRoutePage extends StatelessWidget {
  const ForgeRoutePage({
    super.key,
    this.hero,
    required this.sectionRibbon,
    required this.activeSection,
    required this.controlPanel,
    this.errorBanner,
    this.scrollController,
  });

  final Widget? hero;
  final Widget sectionRibbon;
  final Widget activeSection;
  final Widget controlPanel;
  final Widget? errorBanner;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final hasMainSplit = MediaQuery.of(context).size.width >= 1240;

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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: sectionRibbon,
          ),
          const SizedBox(height: 12),
          if (hasMainSplit)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 10, child: activeSection),
                const SizedBox(width: 16),
                Expanded(flex: 6, child: controlPanel),
              ],
            )
          else
            Column(
              children: [
                activeSection,
                const SizedBox(height: 16),
                controlPanel,
              ],
            ),
        ],
      ),
    );
  }
}
