import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/fantasy_theme.dart';
import 'campaign_builder_atmosphere.dart';

bool prefersReducedMotion(BuildContext context) {
  return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
}

const Curve _premiumSharedAxisForwardCurve = Cubic(0.18, 1.0, 0.32, 1.0);
const Curve _premiumSharedAxisReverseCurve = Cubic(0.4, 0.0, 1.0, 1.0);
const Curve _premiumSharedAxisSecondaryCurve = Interval(
  0.0,
  0.78,
  curve: Cubic(0.3, 0.0, 0.22, 1.0),
);
const Curve _premiumSharedAxisSecondaryReverseCurve = Interval(
  0.0,
  0.68,
  curve: Cubic(0.3, 0.0, 0.22, 1.0),
);

/// Public alias of the premium deceleration curve used by sheet content.
const Curve premiumDecelerationCurve = _premiumSharedAxisForwardCurve;

Widget buildCampaignSharedAxisTransition({
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required SharedAxisTransitionType transitionType,
  required Widget child,
}) {
  return SharedAxisTransition(
    animation: CurvedAnimation(
      parent: animation,
      curve: _premiumSharedAxisForwardCurve,
      reverseCurve: _premiumSharedAxisReverseCurve,
    ),
    secondaryAnimation: CurvedAnimation(
      parent: secondaryAnimation,
      curve: _premiumSharedAxisSecondaryCurve,
      reverseCurve: _premiumSharedAxisSecondaryReverseCurve,
    ),
    transitionType: transitionType,
    fillColor: Colors.transparent,
    child: child,
  );
}

class AnimatedRuneFilterChip extends StatefulWidget {
  const AnimatedRuneFilterChip({
    super.key,
    required this.atmosphere,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.premiumCrownColor,
    this.onLockedTap,
  });

  final CampaignAtmosphereData atmosphere;
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  /// When non-null the chip is marked as premium: shows a crown badge and
  /// uses this color for the unselected label text.
  final Color? premiumCrownColor;

  /// When non-null the chip is locked: tapping calls this instead of
  /// [onSelected], typically to show a premium unlock prompt.
  final VoidCallback? onLockedTap;

  @override
  State<AnimatedRuneFilterChip> createState() => _AnimatedRuneFilterChipState();
}

class _AnimatedRuneFilterChipState extends State<AnimatedRuneFilterChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: widget.atmosphere.chipFlashDuration,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedRuneFilterChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.atmosphere.chipFlashDuration !=
        widget.atmosphere.chipFlashDuration) {
      _flashController.duration = widget.atmosphere.chipFlashDuration;
    }
    if (!oldWidget.selected &&
        widget.selected &&
        !prefersReducedMotion(context)) {
      _flashController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = prefersReducedMotion(context);
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary.withValues(alpha: 0.84);
    final backgroundColor =
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.6);
    final borderColor = widget.selected
        ? colorScheme.primary.withValues(alpha: 0.68)
        : colorScheme.outline.withValues(alpha: 0.45);
    final isPremium = widget.premiumCrownColor != null;

    final chip = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onLockedTap ?? () => widget.onSelected(!widget.selected),
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: reducedMotion
              ? const Duration(milliseconds: 120)
              : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: widget.selected ? selectedColor : backgroundColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor),
          ),
          child: AnimatedBuilder(
            animation: _flashController,
            builder: (context, child) {
              return CustomPaint(
                foregroundPainter: reducedMotion
                    ? null
                    : _RuneChipFlashPainter(
                        progress: _flashController.value,
                        atmosphere: widget.atmosphere,
                      ),
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: widget.selected
                          ? FantasyPalette.parchment
                          : (widget.premiumCrownColor ?? colorScheme.onSurface),
                    ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!isPremium) return chip;

    // Wrap in a Stack so the crown badge can overflow the chip's border.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        chip,
        Positioned(
          top: -1,
          right: -2,
          child: FaIcon(
            FontAwesomeIcons.crown,
            size: 13,
            color: widget.premiumCrownColor,
          ),
        ),
      ],
    );
  }
}

class SegmentedValuePillItem {
  const SegmentedValuePillItem({
    required this.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.locked = false,
  });

  final Key key;
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;
}

enum SegmentedValueSelectorLayout {
  wrap,
  horizontalScroll,
  segmentedButton,
  segmentedButtonScrollable,
}

class AnimatedRuneSegmentedValueSelector extends StatelessWidget {
  const AnimatedRuneSegmentedValueSelector({
    super.key,
    required this.atmosphere,
    required this.items,
    this.lockedColor,
    this.layout = SegmentedValueSelectorLayout.wrap,
    this.controlKey,
  });

  final CampaignAtmosphereData atmosphere;
  final List<SegmentedValuePillItem> items;
  final Color? lockedColor;
  final SegmentedValueSelectorLayout layout;
  final Key? controlKey;

  @override
  Widget build(BuildContext context) {
    if (layout == SegmentedValueSelectorLayout.segmentedButtonScrollable) {
      return SingleChildScrollView(
        key: controlKey,
        scrollDirection: Axis.horizontal,
        child: _buildSegmentedButton(context),
      );
    }

    if (layout == SegmentedValueSelectorLayout.horizontalScroll) {
      return SingleChildScrollView(
        key: controlKey,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final item in items) ...[
              _AnimatedRuneSegmentedValuePill(
                key: item.key,
                atmosphere: atmosphere,
                label: item.label,
                selected: item.selected,
                locked: item.locked,
                lockedColor: lockedColor,
                onTap: item.onTap,
              ),
              if (item != items.last) const SizedBox(width: 8),
            ],
          ],
        ),
      );
    }

    if (layout == SegmentedValueSelectorLayout.segmentedButton) {
      return _buildSegmentedButton(context, key: controlKey);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => _AnimatedRuneSegmentedValuePill(
              key: item.key,
              atmosphere: atmosphere,
              label: item.label,
              selected: item.selected,
              locked: item.locked,
              lockedColor: lockedColor,
              onTap: item.onTap,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSegmentedButton(BuildContext context, {Key? key}) {
    final selectedIndex = items.indexWhere((item) => item.selected);
    final selected = selectedIndex >= 0 ? <int>{selectedIndex} : <int>{};

    return SegmentedButton<int>(
      key: key,
      showSelectedIcon: false,
      segments: List<ButtonSegment<int>>.generate(
        items.length,
        (index) {
          final item = items[index];
          return ButtonSegment<int>(
            value: index,
            label: Text(
              item.label,
              key: item.key,
              style: TextStyle(
                color: item.locked
                    ? (lockedColor ??
                        Theme.of(context).colorScheme.tertiary
                            .withValues(alpha: 0.92))
                    : null,
              ),
            ),
          );
        },
      ),
      selected: selected,
      style: ButtonStyle(
        visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      onSelectionChanged: (selection) {
        if (selection.isEmpty) {
          return;
        }
        items[selection.first].onTap();
      },
    );
  }
}

class _AnimatedRuneSegmentedValuePill extends StatefulWidget {
  const _AnimatedRuneSegmentedValuePill({
    super.key,
    required this.atmosphere,
    required this.label,
    required this.selected,
    required this.locked,
    required this.onTap,
    this.lockedColor,
  });

  final CampaignAtmosphereData atmosphere;
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;
  final Color? lockedColor;

  @override
  State<_AnimatedRuneSegmentedValuePill> createState() =>
      _AnimatedRuneSegmentedValuePillState();
}

class _AnimatedRuneSegmentedValuePillState
    extends State<_AnimatedRuneSegmentedValuePill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: widget.atmosphere.chipFlashDuration,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedRuneSegmentedValuePill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.atmosphere.chipFlashDuration !=
        widget.atmosphere.chipFlashDuration) {
      _flashController.duration = widget.atmosphere.chipFlashDuration;
    }
    if (!oldWidget.selected &&
        widget.selected &&
        !prefersReducedMotion(context)) {
      _flashController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = prefersReducedMotion(context);
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary.withValues(alpha: 0.86);
    final backgroundColor =
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.62);
    final lockedColor =
        widget.lockedColor ?? colorScheme.tertiary.withValues(alpha: 0.92);
    final borderColor = widget.selected
        ? colorScheme.primary.withValues(alpha: 0.72)
        : widget.locked
            ? lockedColor.withValues(alpha: 0.72)
            : colorScheme.outline.withValues(alpha: 0.45);
    final textColor = widget.selected
        ? FantasyPalette.parchment
        : widget.locked
            ? lockedColor
            : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: reducedMotion
              ? const Duration(milliseconds: 120)
              : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minWidth: 40),
          decoration: BoxDecoration(
            color: widget.selected ? selectedColor : backgroundColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor),
          ),
          child: AnimatedBuilder(
            animation: _flashController,
            builder: (context, child) {
              return CustomPaint(
                foregroundPainter: reducedMotion
                    ? null
                    : _RuneChipFlashPainter(
                        progress: _flashController.value,
                        atmosphere: widget.atmosphere,
                      ),
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgePrimaryActionButton extends StatefulWidget {
  const ForgePrimaryActionButton({
    super.key,
    required this.atmosphere,
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.shouldPulse,
    required this.onPressed,
  });

  final CampaignAtmosphereData atmosphere;
  final String label;
  final IconData icon;
  final bool isLoading;
  final bool shouldPulse;
  final VoidCallback? onPressed;

  @override
  State<ForgePrimaryActionButton> createState() =>
      _ForgePrimaryActionButtonState();
}

class _ForgePrimaryActionButtonState extends State<ForgePrimaryActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.atmosphere.ctaPulseDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant ForgePrimaryActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.atmosphere.ctaPulseDuration !=
        widget.atmosphere.ctaPulseDuration) {
      _pulseController.duration = widget.atmosphere.ctaPulseDuration;
    }
    _syncPulse();
  }

  void _syncPulse() {
    final shouldAnimate = widget.shouldPulse &&
        widget.onPressed != null &&
        !widget.isLoading &&
        !prefersReducedMotion(context);

    if (shouldAnimate) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
      return;
    }

    if (_pulseController.isAnimating || _pulseController.value != 0) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = prefersReducedMotion(context);
    final canPulse =
        widget.shouldPulse && widget.onPressed != null && !widget.isLoading;
    final baseGlowAlpha = canPulse ? 0.16 : 0.08;

    final button = FilledButton.icon(
      onPressed: widget.isLoading ? null : widget.onPressed,
      icon: widget.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(widget.icon),
      label: Text(widget.label),
    );

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = reducedMotion
            ? 0.0
            : Curves.easeInOut.transform(_pulseController.value);
        final scale = 1 + (canPulse ? pulseValue * 0.018 : 0.0);
        final glowAlpha = baseGlowAlpha + (canPulse ? pulseValue * 0.12 : 0.0);
        final blurRadius = 16 + (canPulse ? pulseValue * 14 : 0.0);

        return Transform.scale(
          scale: scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: widget.atmosphere.glow.withValues(alpha: glowAlpha),
                  blurRadius: blurRadius,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: button,
    );
  }
}

class _RuneChipFlashPainter extends CustomPainter {
  const _RuneChipFlashPainter({
    required this.progress,
    required this.atmosphere,
  });

  final double progress;
  final CampaignAtmosphereData atmosphere;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) {
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final bloomPaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          atmosphere.highlight.withValues(alpha: 0.28 * (1 - progress)),
          atmosphere.primary.withValues(alpha: 0.18 * (1 - progress)),
          Colors.transparent,
        ],
        stops: const <double>[0.0, 0.38, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.longestSide));

    final clip = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(999),
    );
    canvas.drawRRect(clip, bloomPaint);

    final runePaint = Paint()
      ..color = atmosphere.highlight.withValues(alpha: 0.36 * (1 - progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final runeScale = 6 + (progress * 6);
    final offsets = <Offset>[
      Offset(size.width * 0.22, size.height * 0.35),
      Offset(size.width * 0.48, size.height * 0.22),
      Offset(size.width * 0.72, size.height * 0.36),
      Offset(size.width * 0.56, size.height * 0.68),
    ];

    for (final offset in offsets) {
      final path = Path()
        ..moveTo(offset.dx, offset.dy - runeScale)
        ..lineTo(offset.dx + runeScale * 0.75, offset.dy)
        ..lineTo(offset.dx, offset.dy + runeScale)
        ..lineTo(offset.dx - runeScale * 0.75, offset.dy)
        ..close();
      canvas.drawPath(path, runePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RuneChipFlashPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.atmosphere.id != atmosphere.id;
  }
}
