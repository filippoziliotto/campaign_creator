import 'package:flutter/material.dart';

import '../../../theme/fantasy_theme.dart';
import 'campaign_builder_atmosphere.dart';

bool prefersReducedMotion(BuildContext context) {
  return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
}

class AnimatedRuneFilterChip extends StatefulWidget {
  const AnimatedRuneFilterChip({
    super.key,
    required this.atmosphere,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final CampaignAtmosphereData atmosphere;
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

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
    if (oldWidget.atmosphere.chipFlashDuration != widget.atmosphere.chipFlashDuration) {
      _flashController.duration = widget.atmosphere.chipFlashDuration;
    }
    if (!oldWidget.selected && widget.selected && !prefersReducedMotion(context)) {
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onSelected(!widget.selected),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.selected
                          ? FantasyPalette.parchment
                          : colorScheme.onSurface,
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
  State<ForgePrimaryActionButton> createState() => _ForgePrimaryActionButtonState();
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
    if (oldWidget.atmosphere.ctaPulseDuration != widget.atmosphere.ctaPulseDuration) {
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
    final canPulse = widget.shouldPulse && widget.onPressed != null && !widget.isLoading;
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
        final pulseValue =
            reducedMotion ? 0.0 : Curves.easeInOut.transform(_pulseController.value);
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
