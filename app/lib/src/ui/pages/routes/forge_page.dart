import 'package:flutter/material.dart';

import 'stage_route_scaffold.dart';

class ForgeRoutePage extends StatelessWidget {
  const ForgeRoutePage({
    super.key,
    this.hero,
    required this.sectionRibbon,
    this.sectionHelper,
    required this.activeSection,
    required this.controlPanel,
    this.errorBanner,
    this.scrollController,
  });

  final Widget? hero;
  final Widget sectionRibbon;
  final Widget? sectionHelper;
  final Widget activeSection;
  final Widget controlPanel;
  final Widget? errorBanner;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final hasMainSplit = MediaQuery.of(context).size.width >= 1240;
    const compactControlPanelScrollClearance = 88.0;
    final compactForgeBody = SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero != null) hero!,
          if (errorBanner != null) ...[
            if (hero != null) const SizedBox(height: 16),
            errorBanner!,
          ],
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: sectionRibbon,
          ),
          if (sectionHelper != null) ...[
            const SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: sectionHelper!,
            ),
          ],
          const SizedBox(height: 1),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    primary: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: compactControlPanelScrollClearance,
                      ),
                      child: activeSection,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: controlPanel,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return StageRouteScaffold(
      useIntrinsicScroll: hasMainSplit,
      scrollController: scrollController,
      child: hasMainSplit
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hero != null) hero!,
                if (errorBanner != null) ...[
                  if (hero != null) const SizedBox(height: 16),
                  errorBanner!,
                ],
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  child: sectionRibbon,
                ),
                if (sectionHelper != null) ...[
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: sectionHelper!,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 10, child: activeSection),
                    const SizedBox(width: 16),
                    Expanded(flex: 6, child: controlPanel),
                  ],
                ),
              ],
            )
          : compactForgeBody,
    );
  }
}
