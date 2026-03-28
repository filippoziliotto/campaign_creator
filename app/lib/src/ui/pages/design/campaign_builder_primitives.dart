import 'package:campaign_creator_flutter/src/l10n_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/fantasy_theme.dart';
import 'campaign_builder_atmosphere.dart';
import 'campaign_builder_motion.dart';

enum FrameDensity { compact, featured }

enum PanelEmphasis { primary, secondary, tertiary }

class CampaignStagePage extends Page<void> {
  const CampaignStagePage({
    required this.child,
    required this.atmosphere,
    this.transitionDurationOverride,
    super.key,
    super.name,
  });

  final Widget child;
  final CampaignAtmosphereData atmosphere;
  final Duration? transitionDurationOverride;

  @override
  Route<void> createRoute(BuildContext context) {
    return _CampaignStageRoute(page: this);
  }
}

class _CampaignStageRoute extends PageRoute<void> {
  _CampaignStageRoute({required CampaignStagePage page})
      : super(settings: page);

  CampaignStagePage get _page => settings as CampaignStagePage;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration =>
      _page.transitionDurationOverride ??
      _page.atmosphere.routeTransitionDuration;

  @override
  Duration get reverseTransitionDuration =>
      _page.atmosphere.reverseRouteTransitionDuration;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _page.child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return buildCampaignSharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      transitionType: _page.atmosphere.routeTransitionType,
      child: child,
    );
  }
}

class HeroFrame extends StatelessWidget {
  const HeroFrame({
    super.key,
    required this.atmosphere,
    required this.eyebrow,
    required this.title,
    this.titleStyle,
    this.subtitle,
    required this.badges,
    required this.trailing,
    this.footer,
  });

  final CampaignAtmosphereData atmosphere;
  final String eyebrow;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final List<Widget> badges;
  final Widget trailing;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final palette = context.fantasy;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: atmosphere.primary.withValues(alpha: 0.48),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: atmosphere.glow.withValues(alpha: 0.18),
            blurRadius: 38,
            offset: const Offset(0, 20),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.lerp(palette.canvasAlt, atmosphere.cardTint, 0.22)!,
            Color.lerp(palette.card, atmosphere.cardTint, 0.32)!,
            Color.lerp(palette.cardSoft, atmosphere.primary, 0.18)!,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (compact)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCopy(
                        eyebrow: eyebrow,
                        title: title,
                        titleStyle: titleStyle,
                        subtitle: subtitle,
                        badges: badges,
                      ),
                      const SizedBox(height: 18),
                      trailing,
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _HeroCopy(
                          eyebrow: eyebrow,
                          title: title,
                          titleStyle: titleStyle,
                          subtitle: subtitle,
                          badges: badges,
                        ),
                      ),
                      const SizedBox(width: 18),
                      trailing,
                    ],
                  ),
                if (footer != null) ...[
                  const SizedBox(height: 22),
                  footer!,
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.eyebrow,
    required this.title,
    this.titleStyle,
    this.subtitle,
    required this.badges,
  });

  final String eyebrow;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final List<Widget> badges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Text(
          title,
          style: titleStyle ?? Theme.of(context).textTheme.displayLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge),
        ],
        if (badges.isNotEmpty) ...[
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: badges,
          ),
        ],
      ],
    );
  }
}

class CampaignModeCard extends StatelessWidget {
  const CampaignModeCard({
    super.key,
    required this.atmosphere,
    required this.title,
    required this.description,
    required this.emblemAsset,
    required this.fallbackIcon,
    required this.colors,
    required this.artAsset,
    required this.selected,
    required this.onTap,
  });

  final CampaignAtmosphereData atmosphere;
  final String title;
  final String description;
  final String emblemAsset;
  final IconData fallbackIcon;
  final List<Color> colors;
  final String artAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.fantasy;
    final theme = Theme.of(context);
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final isTouch = const {TargetPlatform.android, TargetPlatform.iOS}
        .contains(defaultTargetPlatform);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final cardHeight = viewportWidth < 640 ? 208.0 : 192.0;
    final framePadding = 2.5;
    final outerBorderRadius = BorderRadius.circular(24);
    final innerBorderRadius = BorderRadius.circular(24 - framePadding);

    return _CardInteractionLayer(
      atmosphere: atmosphere,
      title: title,
      description: description,
      emblemAsset: emblemAsset,
      fallbackIcon: fallbackIcon,
      colors: colors,
      artAsset: artAsset,
      selected: selected,
      onTap: onTap,
      reducedMotion: reducedMotion,
      isTouch: isTouch,
      cardHeight: cardHeight,
      framePadding: framePadding,
      outerBorderRadius: outerBorderRadius,
      innerBorderRadius: innerBorderRadius,
      titleStyle: theme.textTheme.titleLarge?.copyWith(
        color: palette.onArtwork,
      ),
      descriptionStyle: theme.textTheme.bodySmall?.copyWith(
        color: palette.onArtworkMuted.withValues(alpha: 0.84),
      ),
      ctaTextStyle: theme.textTheme.labelLarge,
      motionDuration: reducedMotion
          ? const Duration(milliseconds: 120)
          : const Duration(milliseconds: 220),
      selectedScale: reducedMotion ? 1.0 : (selected ? 1.02 : 1.0),
    );
  }
}

class _CardInteractionLayer extends StatefulWidget {
  const _CardInteractionLayer({
    required this.atmosphere,
    required this.title,
    required this.description,
    required this.emblemAsset,
    required this.fallbackIcon,
    required this.colors,
    required this.artAsset,
    required this.selected,
    required this.onTap,
    required this.reducedMotion,
    required this.isTouch,
    required this.cardHeight,
    required this.framePadding,
    required this.outerBorderRadius,
    required this.innerBorderRadius,
    required this.titleStyle,
    required this.descriptionStyle,
    required this.ctaTextStyle,
    required this.motionDuration,
    required this.selectedScale,
  });

  final CampaignAtmosphereData atmosphere;
  final String title;
  final String description;
  final String emblemAsset;
  final IconData fallbackIcon;
  final List<Color> colors;
  final String artAsset;
  final bool selected;
  final VoidCallback onTap;
  final bool reducedMotion;
  final bool isTouch;
  final double cardHeight;
  final double framePadding;
  final BorderRadius outerBorderRadius;
  final BorderRadius innerBorderRadius;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final TextStyle? ctaTextStyle;
  final Duration motionDuration;
  final double selectedScale;

  @override
  State<_CardInteractionLayer> createState() => _CardInteractionLayerState();
}

class _CardInteractionLayerState extends State<_CardInteractionLayer> {
  bool _hovered = false;
  bool _pressed = false;
  Offset _hoverVector = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final descriptionMaxLines = 3;
    final showCallToAction = widget.selected || _hovered;
    final targetProgress = (widget.reducedMotion || widget.isTouch)
        ? 0.0
        : (_pressed ? 0.5 : (_hovered ? 1.0 : 0.0));

    Widget cardBody = GestureDetector(
      onTapDown: (_) {
        if (!widget.reducedMotion) {
          setState(() {
            _pressed = true;
          });
        }
      },
      onTapUp: (_) {
        if (!widget.reducedMotion) {
          setState(() {
            _pressed = false;
          });
        }
      },
      onTapCancel: () {
        if (!widget.reducedMotion) {
          setState(() {
            _pressed = false;
          });
        }
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: targetProgress),
        duration: widget.motionDuration,
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          final lift = widget.atmosphere.cardHoverLift * value;
          final tiltX =
              -_hoverVector.dy * widget.atmosphere.cardHoverTilt * value;
          final tiltY =
              _hoverVector.dx * widget.atmosphere.cardHoverTilt * value;
          final scale = 1 - (_pressed ? 0.016 * value : 0.0);

          return Transform.translate(
            offset: Offset(0, -lift),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(tiltX)
                ..rotateY(tiltY),
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            ),
          );
        },
        child: AnimatedScale(
          scale: widget.selectedScale,
          duration: widget.motionDuration,
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: widget.motionDuration,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(widget.framePadding),
            decoration: BoxDecoration(
              borderRadius: widget.outerBorderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  widget.atmosphere.highlight.withValues(
                    alpha: widget.selected ? 0.95 : (_hovered ? 0.7 : 0.55),
                  ),
                  widget.atmosphere.primary.withValues(
                    alpha: widget.selected ? 1.0 : (_hovered ? 0.88 : 0.8),
                  ),
                  widget.atmosphere.secondary.withValues(
                    alpha: widget.selected ? 0.85 : (_hovered ? 0.62 : 0.5),
                  ),
                  widget.atmosphere.highlight.withValues(
                    alpha: widget.selected ? 0.7 : (_hovered ? 0.44 : 0.35),
                  ),
                ],
                stops: const <double>[0.0, 0.35, 0.65, 1.0],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: widget.atmosphere.glow.withValues(
                    alpha: widget.selected ? 0.28 : (_hovered ? 0.1 : 0.05),
                  ),
                  blurRadius: widget.selected ? 30 : (_hovered ? 16 : 10),
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: widget.innerBorderRadius,
              child: AnimatedContainer(
                duration: widget.motionDuration,
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: widget.innerBorderRadius,
                ),
                child: ClipRRect(
                  borderRadius: widget.innerBorderRadius,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _CampaignCardArtwork(
                          artAsset: widget.artAsset,
                          fallbackColor: widget.colors.last.withValues(
                            alpha: 0.9,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                widget.colors.first.withValues(alpha: 0.22),
                                widget.colors.last.withValues(alpha: 0.42),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.black.withValues(alpha: 0.12),
                                Colors.black.withValues(alpha: 0.30),
                                Colors.black.withValues(
                                  alpha: widget.selected ? 0.74 : 0.86,
                                ),
                              ],
                              stops: const <double>[0.0, 0.46, 1.0],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: widget.cardHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _CampaignCardMedallion(
                                    atmosphere: widget.atmosphere,
                                    colors: widget.colors,
                                    emblemAsset: widget.emblemAsset,
                                    fallbackIcon: widget.fallbackIcon,
                                    selected: widget.selected,
                                    hovered: _hovered,
                                    pressed: _pressed,
                                    duration: widget.motionDuration,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                widget.title,
                                style: widget.titleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.description,
                                style: widget.descriptionStyle,
                                maxLines:
                                    showCallToAction ? 1 : descriptionMaxLines,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (showCallToAction) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      context.l10n.entryOpenForge,
                                      style: widget.ctaTextStyle,
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: widget.atmosphere.highlight,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.isTouch) return cardBody;

    return MouseRegion(
      onEnter: (_) {
        if (!widget.reducedMotion) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
          _hoverVector = Offset.zero;
        });
      },
      onHover: (event) {
        if (widget.reducedMotion) return;
        final size = context.size;
        if (size == null || size.width == 0 || size.height == 0) return;
        final dx = ((event.localPosition.dx / size.width) * 2) - 1;
        final dy = ((event.localPosition.dy / size.height) * 2) - 1;
        setState(() {
          _hoverVector = Offset(
            dx.clamp(-1.0, 1.0).toDouble(),
            dy.clamp(-1.0, 1.0).toDouble(),
          );
        });
      },
      child: cardBody,
    );
  }
}

class _CampaignCardMedallion extends StatelessWidget {
  const _CampaignCardMedallion({
    required this.atmosphere,
    required this.colors,
    required this.emblemAsset,
    required this.fallbackIcon,
    required this.selected,
    required this.hovered,
    required this.pressed,
    required this.duration,
  });

  final CampaignAtmosphereData atmosphere;
  final List<Color> colors;
  final String emblemAsset;
  final IconData fallbackIcon;
  final bool selected;
  final bool hovered;
  final bool pressed;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final emphasis = selected ? 1.0 : (hovered ? 0.55 : 0.0);
    final emblemColor = Color.lerp(
      context.fantasy.onArtwork,
      atmosphere.highlight,
      0.34 + (emphasis * 0.44),
    )!;

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      width: 32,
      height: 32,
      child: Transform.scale(
        scale: pressed ? 0.96 : 1.0,
        child: SvgPicture.asset(
          emblemAsset,
          key: const ValueKey<String>('campaign-mode-card-emblem'),
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            emblemColor,
            BlendMode.srcIn,
          ),
          placeholderBuilder: (context) => _CampaignCardFallbackIcon(
            icon: fallbackIcon,
            color: emblemColor.withValues(alpha: 0.7),
          ),
          errorBuilder: (context, error, stackTrace) =>
              _CampaignCardFallbackIcon(
            icon: fallbackIcon,
            color: emblemColor,
          ),
        ),
      ),
    );
  }
}

class _CampaignCardFallbackIcon extends StatelessWidget {
  const _CampaignCardFallbackIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      key: const ValueKey<String>('campaign-mode-card-fallback-icon'),
      color: color,
      size: 20,
    );
  }
}

class _CampaignCardArtwork extends StatelessWidget {
  const _CampaignCardArtwork({
    required this.artAsset,
    required this.fallbackColor,
  });

  final String artAsset;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    final normalizedPath = artAsset.toLowerCase();

    if (normalizedPath.endsWith('.svg')) {
      return SvgPicture.asset(
        artAsset,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        placeholderBuilder: (context) => ColoredBox(color: fallbackColor),
      );
    }

    return Image.asset(
      artAsset,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (context, error, stackTrace) {
        return ColoredBox(color: fallbackColor);
      },
    );
  }
}

class StagePill extends StatelessWidget {
  const StagePill({
    super.key,
    required this.index,
    required this.label,
    required this.active,
    required this.enabled,
    required this.completed,
    required this.onTap,
  });

  final int index;
  final String label;
  final bool active;
  final bool enabled;
  final bool completed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indexFillColor = active
        ? colorScheme.primary
        : completed
            ? colorScheme.secondary.withValues(alpha: 0.55)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final indexTextColor = active
        ? colorScheme.onPrimary
        : completed
            ? colorScheme.onSecondary
            : colorScheme.onSurfaceVariant;
    final borderColor = active
        ? colorScheme.primary
        : completed
            ? colorScheme.secondary.withValues(alpha: 0.40)
            : colorScheme.outline.withValues(alpha: 0.13);

    final backgroundColor = active
        ? colorScheme.primary.withValues(alpha: 0.12)
        : colorScheme.surface.withValues(
            alpha: enabled ? 0.22 : 0.12,
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: indexFillColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: indexTextColor,
                    ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    height: 1.1,
                    color: enabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class StagePillRibbon extends StatelessWidget {
  const StagePillRibbon({
    super.key,
    required this.children,
    this.spacing = 8,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < children.length; index++) ...[
                  if (index > 0) SizedBox(width: spacing),
                  children[index],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimatedReveal extends StatelessWidget {
  const AnimatedReveal({
    super.key,
    required this.child,
    required this.delay,
    this.duration = const Duration(milliseconds: 700),
    this.distance = 24,
  });

  final Widget child;
  final double delay;
  final Duration duration;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final start = delay < 0 ? 0.0 : (delay > 0.9 ? 0.9 : delay);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * distance),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

class SectionFrame extends StatelessWidget {
  const SectionFrame({
    super.key,
    required this.title,
    required this.child,
    this.eyebrow,
    this.subtitle,
    this.icon,
    this.titleTextStyle,
    this.density = FrameDensity.compact,
    this.emphasis = PanelEmphasis.primary,
    this.showDivider = false,
  });

  final String? eyebrow;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final TextStyle? titleTextStyle;
  final Widget child;
  final FrameDensity density;
  final PanelEmphasis emphasis;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final featured = density == FrameDensity.featured;
    final prominent = emphasis == PanelEmphasis.primary;
    final padding = featured ? 22.0 : 18.0;
    final iconBoxSize = switch (emphasis) {
      PanelEmphasis.primary => featured ? 48.0 : 38.0,
      PanelEmphasis.secondary => featured ? 44.0 : 36.0,
      PanelEmphasis.tertiary => featured ? 40.0 : 34.0,
    };
    final headerSpacing = featured ? 16.0 : 12.0;
    final sectionTitleStyle = switch (emphasis) {
      PanelEmphasis.primary => featured
          ? Theme.of(context).textTheme.titleLarge
          : Theme.of(context).textTheme.titleMedium,
      PanelEmphasis.secondary => Theme.of(context).textTheme.titleMedium,
      PanelEmphasis.tertiary => Theme.of(context).textTheme.titleMedium,
    };
    final hasHeaderMeta = eyebrow != null || subtitle != null || icon != null;
    final frameColorAlpha = switch (emphasis) {
      PanelEmphasis.primary => featured ? 0.78 : 0.66,
      PanelEmphasis.secondary => featured ? 0.68 : 0.58,
      PanelEmphasis.tertiary => featured ? 0.56 : 0.48,
    };
    final borderAlpha = switch (emphasis) {
      PanelEmphasis.primary => featured ? 0.28 : 0.18,
      PanelEmphasis.secondary => featured ? 0.18 : 0.14,
      PanelEmphasis.tertiary => featured ? 0.10 : 0.08,
    };
    final iconFillAlpha = switch (emphasis) {
      PanelEmphasis.primary => featured ? 0.14 : 0.10,
      PanelEmphasis.secondary => 0.08,
      PanelEmphasis.tertiary => 0.05,
    };
    final iconBorderAlpha = switch (emphasis) {
      PanelEmphasis.primary => 0.18,
      PanelEmphasis.secondary => 0.12,
      PanelEmphasis.tertiary => 0.08,
    };
    final resolvedShowDivider = showDivider && prominent;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(featured ? 24 : 22),
        color: colorScheme.surface.withValues(alpha: frameColorAlpha),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: borderAlpha),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasHeaderMeta) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    Container(
                      width: iconBoxSize,
                      height: iconBoxSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(featured ? 14 : 12),
                        color: colorScheme.primary.withValues(
                          alpha: iconFillAlpha,
                        ),
                        border: Border.all(
                          color: colorScheme.primary.withValues(
                            alpha: iconBorderAlpha,
                          ),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: switch (emphasis) {
                          PanelEmphasis.primary => featured ? 22.0 : 18.0,
                          PanelEmphasis.secondary => featured ? 20.0 : 17.0,
                          PanelEmphasis.tertiary => featured ? 18.0 : 16.0,
                        },
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (eyebrow != null) ...[
                          Text(
                            eyebrow!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(title, style: titleTextStyle ?? sectionTitleStyle),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ] else
              Text(title, style: titleTextStyle ?? sectionTitleStyle),
            if (resolvedShowDivider) ...[
              SizedBox(height: headerSpacing),
              const RuneDivider(),
            ],
            SizedBox(height: resolvedShowDivider ? headerSpacing : 12),
            child,
          ],
        ),
      ),
    );
  }
}

class ControlRoomPanel extends StatelessWidget {
  const ControlRoomPanel({
    super.key,
    required this.title,
    required this.child,
    this.label,
    this.subtitle,
    this.icon,
    this.trailing,
    this.density = FrameDensity.compact,
    this.emphasis = PanelEmphasis.secondary,
    this.showDivider = false,
  });

  final String? label;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;
  final FrameDensity density;
  final PanelEmphasis emphasis;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final featured = density == FrameDensity.featured;
    final prominent = emphasis == PanelEmphasis.primary;
    final padding = featured ? 18.0 : 16.0;
    final showHeaderMeta =
        label != null || subtitle != null || icon != null || trailing != null;
    final borderAlpha = switch (emphasis) {
      PanelEmphasis.primary => featured ? 0.28 : 0.22,
      PanelEmphasis.secondary => featured ? 0.24 : 0.18,
      PanelEmphasis.tertiary => featured ? 0.12 : 0.10,
    };
    final fillAlpha = switch (emphasis) {
      PanelEmphasis.primary => featured ? 0.56 : 0.40,
      PanelEmphasis.secondary => featured ? 0.44 : 0.32,
      PanelEmphasis.tertiary => featured ? 0.28 : 0.20,
    };
    final iconFillAlpha = switch (emphasis) {
      PanelEmphasis.primary => 0.14,
      PanelEmphasis.secondary => 0.12,
      PanelEmphasis.tertiary => 0.06,
    };
    final resolvedShowDivider = showDivider && prominent;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(featured ? 22 : 20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: borderAlpha),
        ),
        color: colorScheme.surfaceContainerHighest.withValues(
          alpha: fillAlpha,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeaderMeta) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[
                    Container(
                      width: featured ? 40 : 34,
                      height: featured ? 40 : 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: colorScheme.primary
                            .withValues(alpha: iconFillAlpha),
                      ),
                      child: Icon(
                        icon,
                        color: colorScheme.primary,
                        size: switch (emphasis) {
                          PanelEmphasis.primary => 18.0,
                          PanelEmphasis.secondary => 18.0,
                          PanelEmphasis.tertiary => 16.0,
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (label != null) ...[
                          Text(
                            label!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          title,
                          style: switch (emphasis) {
                            PanelEmphasis.primary => featured
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context).textTheme.titleSmall,
                            PanelEmphasis.secondary => featured
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context).textTheme.titleSmall,
                            PanelEmphasis.tertiary =>
                              Theme.of(context).textTheme.titleSmall,
                          },
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing!,
                  ],
                ],
              ),
              if (resolvedShowDivider) ...[
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.16),
                ),
              ],
              const SizedBox(height: 14),
            ] else
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}

class TelemetryMetricTile extends StatelessWidget {
  const TelemetryMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colorScheme.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.primary.withValues(alpha: 0.14),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
                if (detail != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    detail!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignalStatusRow extends StatelessWidget {
  const SignalStatusRow({
    super.key,
    required this.label,
    required this.detail,
    required this.ready,
    this.icon = Icons.adjust_rounded,
  });

  final String label;
  final String detail;
  final bool ready;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = ready ? colorScheme.secondary : colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: accent.withValues(alpha: ready ? 0.1 : 0.08),
        border: Border.all(
          color: accent.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.16),
            ),
            child: Icon(
              ready ? Icons.check_rounded : icon,
              color: accent,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: accent.withValues(alpha: 0.14),
            ),
            child: Text(
              ready ? context.l10n.statusReady : context.l10n.statusNeedsPolish,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: accent,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryBadge extends StatelessWidget {
  const SummaryBadge({
    super.key,
    required this.label,
    this.maxWidth,
    this.textColor,
  });

  final String label;
  final double? maxWidth;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor ?? colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}

class LoreCallout extends StatelessWidget {
  const LoreCallout({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colorScheme.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusSeal extends StatelessWidget {
  const StatusSeal({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.32),
        ),
        color: colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class ToggleTile extends StatelessWidget {
  const ToggleTile({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colorScheme.primary.withValues(alpha: 0.07),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.38),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class RuneDivider extends StatelessWidget {
  const RuneDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '✦',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

class ForgeActionStrip extends StatelessWidget {
  const ForgeActionStrip({
    super.key,
    required this.atmosphere,
    required this.readinessHint,
    required this.isPrimaryEnabled,
    required this.isGenerating,
    required this.primaryLabel,
    this.primaryCompactLabel,
    required this.primaryIcon,
    required this.onRetreat,
    required this.onAdvance,
    required this.parchmentReady,
    required this.hasUnsavedChanges,
    required this.onOpenParchment,
    this.savedDraftLabel,
  });

  final CampaignAtmosphereData atmosphere;
  final String readinessHint;
  final bool isPrimaryEnabled;
  final bool isGenerating;
  final String primaryLabel;
  final String? primaryCompactLabel;
  final IconData primaryIcon;
  final VoidCallback onRetreat;
  final VoidCallback? onAdvance;
  final bool parchmentReady;
  final bool hasUnsavedChanges;
  final VoidCallback onOpenParchment;
  final String? savedDraftLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final metaTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          height: 1.0,
        );
    final showParchmentRow = parchmentReady || hasUnsavedChanges;
    final parchmentStatusIcon = parchmentReady && !hasUnsavedChanges
        ? Icons.check_circle_outline
        : Icons.refresh_rounded;
    final parchmentStatusColor = parchmentReady && !hasUnsavedChanges
        ? colorScheme.secondary
        : colorScheme.primary;
    final parchmentStatusText = parchmentReady
        ? (hasUnsavedChanges
            ? context.l10n.forgeParchmentDirty
            : context.l10n.forgeParchmentReady)
        : context.l10n.forgeParchmentIncomplete;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 560;
                final primaryButton = ForgePrimaryActionButton(
                  atmosphere: atmosphere,
                  label: primaryLabel,
                  compactLabel: primaryCompactLabel,
                  icon: primaryIcon,
                  isLoading: isGenerating,
                  shouldPulse: isPrimaryEnabled,
                  onPressed:
                      (isGenerating || !isPrimaryEnabled) ? null : onAdvance,
                );
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [primaryButton],
                  );
                }
                return Align(
                  alignment: Alignment.centerRight,
                  child: primaryButton,
                );
              },
            ),
            if (showParchmentRow) ...[
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(parchmentStatusIcon,
                      size: 16, color: parchmentStatusColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          parchmentStatusText,
                          textAlign: TextAlign.center,
                          style: metaTextStyle?.copyWith(
                            color: parchmentStatusColor,
                          ),
                        ),
                        if (savedDraftLabel != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            savedDraftLabel!,
                            textAlign: TextAlign.center,
                            style: metaTextStyle?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (parchmentReady) ...[
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: onOpenParchment,
                      icon: const Icon(Icons.visibility_rounded, size: 16),
                      label: Text(context.l10n.commonOpen),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FantasyBackdrop extends StatelessWidget {
  const FantasyBackdrop({
    super.key,
    required this.atmosphere,
    this.stageVignette = false,
  });

  final CampaignAtmosphereData atmosphere;
  final bool stageVignette;

  @override
  Widget build(BuildContext context) {
    final palette = context.fantasy;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.lerp(palette.canvas, atmosphere.cardTint, 0.2)!,
                    Color.lerp(palette.canvasAlt, atmosphere.cardTint, 0.32)!,
                    Color.lerp(
                      palette.canvas,
                      Colors.black,
                      isDark ? 0.1 : 0.04,
                    )!,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -40,
            child: _GlowOrb(
              size: 240,
              colors: <Color>[
                atmosphere.glow.withValues(alpha: 0.28),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            left: -90,
            top: 180,
            child: _GlowOrb(
              size: 280,
              colors: <Color>[
                atmosphere.secondary.withValues(alpha: 0.22),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            right: 80,
            bottom: -60,
            child: _GlowOrb(
              size: 220,
              colors: <Color>[
                atmosphere.primary.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _BackdropPatternPainter(atmosphere: atmosphere),
            ),
          ),
          if (stageVignette)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withValues(alpha: 0.26),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.06),
                    ],
                    stops: const <double>[0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

class _BackdropPatternPainter extends CustomPainter {
  const _BackdropPatternPainter({required this.atmosphere});

  final CampaignAtmosphereData atmosphere;

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..color = atmosphere.primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final linePaint = Paint()
      ..color = atmosphere.highlight.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    switch (atmosphere.backdropVariant) {
      case CampaignBackdropVariant.emberRush:
        _paintEmberRush(canvas, size, ringPaint, linePaint);
        break;
      case CampaignBackdropVariant.wayfinderAtlas:
        _paintWayfinderAtlas(canvas, size, ringPaint, linePaint);
        break;
      case CampaignBackdropVariant.sagaAtlas:
        _paintSagaAtlas(canvas, size, ringPaint, linePaint);
        break;
      case CampaignBackdropVariant.torchVault:
        _paintTorchVault(canvas, size, ringPaint, linePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPatternPainter oldDelegate) {
    return oldDelegate.atmosphere.id != atmosphere.id ||
        oldDelegate.atmosphere.primary != atmosphere.primary ||
        oldDelegate.atmosphere.secondary != atmosphere.secondary ||
        oldDelegate.atmosphere.highlight != atmosphere.highlight ||
        oldDelegate.atmosphere.cardTint != atmosphere.cardTint ||
        oldDelegate.atmosphere.backdropVariant != atmosphere.backdropVariant;
  }

  void _paintEmberRush(
    Canvas canvas,
    Size size,
    Paint ringPaint,
    Paint linePaint,
  ) {
    final center = Offset(size.width * 0.82, size.height * 0.2);
    canvas.drawCircle(center, 132, ringPaint);
    canvas.drawCircle(center, 94, ringPaint);

    for (var i = 0; i < 8; i += 1) {
      final startY = size.height * 0.12 + (i * 118);
      canvas.drawLine(
        Offset(28, startY),
        Offset(size.width * 0.86, startY + 26),
        linePaint,
      );
    }

    final emberPaint = Paint()
      ..color = atmosphere.primary.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 14; i += 1) {
      final x = size.width * 0.08 + (i * 96);
      final y = size.height * 0.14 + ((i % 4) * 148);
      canvas.drawCircle(Offset(x, y), 4 + (i % 3).toDouble(), emberPaint);
    }
  }

  void _paintWayfinderAtlas(
    Canvas canvas,
    Size size,
    Paint ringPaint,
    Paint linePaint,
  ) {
    final compass = Offset(size.width * 0.82, size.height * 0.26);
    canvas.drawCircle(compass, 128, ringPaint);
    canvas.drawCircle(compass, 90, ringPaint);
    canvas.drawLine(
      Offset(compass.dx - 100, compass.dy),
      Offset(compass.dx + 100, compass.dy),
      linePaint,
    );
    canvas.drawLine(
      Offset(compass.dx, compass.dy - 100),
      Offset(compass.dx, compass.dy + 100),
      linePaint,
    );

    for (var i = 0; i < 7; i += 1) {
      final y = size.height * 0.16 + (i * 104);
      canvas.drawLine(
        Offset(40, y),
        Offset(size.width - 40, y + 10),
        linePaint,
      );
    }

    for (var i = 0; i < 6; i += 1) {
      final x = size.width * 0.12 + (i * 190);
      canvas.drawLine(
        Offset(x, size.height * 0.12),
        Offset(x + 24, size.height * 0.82),
        linePaint,
      );
    }
  }

  void _paintSagaAtlas(
    Canvas canvas,
    Size size,
    Paint ringPaint,
    Paint linePaint,
  ) {
    final center = Offset(size.width * 0.82, size.height * 0.22);
    canvas.drawCircle(center, 146, ringPaint);
    canvas.drawCircle(center, 116, ringPaint);
    canvas.drawCircle(center, 76, ringPaint);

    final pathPaint = Paint()
      ..color = atmosphere.secondary.withValues(alpha: 0.11)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.74)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.62,
        size.width * 0.34,
        size.height * 0.86,
        size.width * 0.5,
        size.height * 0.66,
      )
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.5,
        size.width * 0.78,
        size.height * 0.58,
        size.width * 0.92,
        size.height * 0.42,
      );
    canvas.drawPath(path, pathPaint);

    for (var i = 0; i < 6; i += 1) {
      final y = size.height * 0.2 + (i * 120);
      canvas.drawLine(
        Offset(40, y),
        Offset(size.width - 40, y + 12),
        linePaint,
      );
    }
  }

  void _paintTorchVault(
    Canvas canvas,
    Size size,
    Paint ringPaint,
    Paint linePaint,
  ) {
    final archPaint = Paint()
      ..color = atmosphere.linework.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    for (var i = 0; i < 4; i += 1) {
      final inset = 36.0 + (i * 30);
      final rect = Rect.fromLTWH(
        inset,
        size.height * 0.18 + (i * 22),
        size.width - (inset * 2),
        size.height * 0.66 - (i * 18),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(28)),
        archPaint,
      );
    }

    final torchGlow = Paint()
      ..color = atmosphere.primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.22, size.height * 0.34), 54, torchGlow);
    canvas.drawCircle(
        Offset(size.width * 0.78, size.height * 0.34), 54, torchGlow);

    for (var i = 0; i < 7; i += 1) {
      final y = size.height * 0.22 + (i * 92);
      canvas.drawLine(
        Offset(70, y),
        Offset(size.width - 70, y),
        linePaint,
      );
    }

    final center = Offset(size.width * 0.82, size.height * 0.22);
    canvas.drawCircle(center, 108, ringPaint);
  }
}
