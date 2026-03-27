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

Widget buildCampaignPanelSlideTransition({
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
}) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    )),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.0, 0.0),
      ).animate(CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeInCubic,
      )),
      child: child,
    ),
  );
}

typedef IndexedChildWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
);

class InteractiveHorizontalSectionPager extends StatefulWidget {
  const InteractiveHorizontalSectionPager({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    required this.itemBuilder,
    required this.onIndexChanged,
    required this.duration,
    this.commitThresholdFraction = 0.22,
    this.commitVelocityPagesPerSecond = 1.0,
    this.onSwipePastStart,
    this.onSwipePastEnd,
  });

  final int currentIndex;
  final int itemCount;
  final IndexedChildWidgetBuilder itemBuilder;
  final ValueChanged<int> onIndexChanged;
  final Duration duration;
  final double commitThresholdFraction;
  final double commitVelocityPagesPerSecond;
  final VoidCallback? onSwipePastStart;
  final VoidCallback? onSwipePastEnd;

  @override
  State<InteractiveHorizontalSectionPager> createState() =>
      _InteractiveHorizontalSectionPagerState();
}

class _InteractiveHorizontalSectionPagerState
    extends State<InteractiveHorizontalSectionPager>
    with SingleTickerProviderStateMixin {
  final GlobalKey _viewportKey = GlobalKey();
  final Map<int, Widget> _childCache = <int, Widget>{};
  late final AnimationController _settleController;
  Animation<double>? _pageAnimation;
  late double _page;
  double _viewportWidth = 1;
  bool _isDragging = false;
  int? _pendingIndex;
  VoidCallback? _pendingEdgeAction;
  Offset? _pointerDownPosition;
  Duration? _pointerDownTime;

  @override
  void initState() {
    super.initState();
    _page = widget.currentIndex.toDouble();
    _settleController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
      ..addListener(_handleSettleTick)
      ..addStatusListener(_handleSettleStatusChanged);
  }

  @override
  void didUpdateWidget(covariant InteractiveHorizontalSectionPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _settleController.duration = widget.duration;
    }
    if (oldWidget.itemBuilder != widget.itemBuilder ||
        oldWidget.itemCount != widget.itemCount) {
      _childCache.clear();
      final maxPage =
          (widget.itemCount - 1).clamp(0, widget.itemCount).toDouble();
      _page = _page.clamp(0.0, maxPage);
    }

    final targetPage = widget.currentIndex.toDouble();
    if (!_isDragging &&
        _pendingIndex == null &&
        (_page - targetPage).abs() > 0.001) {
      _animateToPage(targetPage);
    }
  }

  @override
  void dispose() {
    _settleController
      ..removeListener(_handleSettleTick)
      ..removeStatusListener(_handleSettleStatusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSettleTick() {
    final animation = _pageAnimation;
    if (animation == null) {
      return;
    }
    setState(() {
      _page = animation.value;
    });
  }

  void _handleSettleStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }

    final pendingIndex = _pendingIndex;
    final pendingEdgeAction = _pendingEdgeAction;
    _pendingIndex = null;
    _pendingEdgeAction = null;

    if (pendingIndex != null && pendingIndex != widget.currentIndex) {
      widget.onIndexChanged(pendingIndex);
      return;
    }

    pendingEdgeAction?.call();
  }

  void _animateToPage(
    double targetPage, {
    int? commitIndex,
    VoidCallback? edgeAction,
  }) {
    if (prefersReducedMotion(context)) {
      setState(() {
        _page = targetPage;
      });
      if (commitIndex != null && commitIndex != widget.currentIndex) {
        widget.onIndexChanged(commitIndex);
      } else {
        edgeAction?.call();
      }
      return;
    }

    _pendingIndex = commitIndex;
    _pendingEdgeAction = edgeAction;
    _pageAnimation = Tween<double>(
      begin: _page,
      end: targetPage,
    ).animate(
      CurvedAnimation(
        parent: _settleController,
        curve: Curves.easeOutCubic,
      ),
    );

    _settleController
      ..stop()
      ..reset()
      ..forward();
  }

  void _handleHorizontalDragStart(DragStartDetails details) {
    _isDragging = true;
    _pendingIndex = null;
    _pendingEdgeAction = null;
    _settleController.stop();
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (_viewportWidth <= 0) {
      return;
    }

    final primaryDelta = details.primaryDelta ?? 0;
    final nextPage = _page - (primaryDelta / _viewportWidth);
    final maxPage = (widget.itemCount - 1).toDouble();

    setState(() {
      _page = nextPage.clamp(0.0, maxPage);
    });
  }

  void _handleHorizontalDragCancel() {
    _isDragging = false;
    _animateToPage(widget.currentIndex.toDouble());
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    _isDragging = false;
    final currentIndex = widget.currentIndex;
    final currentPage = currentIndex.toDouble();
    final pageDelta = _page - currentPage;
    final velocityPagesPerSecond = _viewportWidth <= 0
        ? 0.0
        : -(details.velocity.pixelsPerSecond.dx / _viewportWidth);

    int? targetIndex;
    VoidCallback? edgeAction;

    if (velocityPagesPerSecond.abs() >= widget.commitVelocityPagesPerSecond) {
      if (velocityPagesPerSecond > 0 && currentIndex < widget.itemCount - 1) {
        targetIndex = currentIndex + 1;
      } else if (velocityPagesPerSecond < 0 && currentIndex > 0) {
        targetIndex = currentIndex - 1;
      } else if (velocityPagesPerSecond < 0 && currentIndex == 0) {
        edgeAction = widget.onSwipePastStart;
      } else if (velocityPagesPerSecond > 0 &&
          currentIndex == widget.itemCount - 1) {
        edgeAction = widget.onSwipePastEnd;
      }
    } else if (pageDelta.abs() >= widget.commitThresholdFraction) {
      if (pageDelta > 0 && currentIndex < widget.itemCount - 1) {
        targetIndex = currentIndex + 1;
      } else if (pageDelta < 0 && currentIndex > 0) {
        targetIndex = currentIndex - 1;
      }
    }

    if (targetIndex != null) {
      _animateToPage(
        targetIndex.toDouble(),
        commitIndex: targetIndex,
      );
      return;
    }

    _animateToPage(
      currentPage,
      edgeAction: edgeAction,
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    _pointerDownPosition = event.position;
    _pointerDownTime = event.timeStamp;
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _pointerDownPosition = null;
    _pointerDownTime = null;
  }

  void _handlePointerUp(PointerUpEvent event) {
    final startPosition = _pointerDownPosition;
    final startTime = _pointerDownTime;
    _pointerDownPosition = null;
    _pointerDownTime = null;

    if (_isDragging || startPosition == null || startTime == null) {
      return;
    }

    final elapsed = event.timeStamp - startTime;
    if (elapsed.inMilliseconds <= 0) {
      return;
    }

    final delta = event.position - startPosition;
    final absDx = delta.dx.abs();
    final absDy = delta.dy.abs();
    if (absDx < 90 || absDx <= absDy * 1.2) {
      return;
    }

    final velocityX = delta.dx / elapsed.inMilliseconds * 1000;
    if (velocityX.abs() < 550) {
      return;
    }

    final currentIndex = widget.currentIndex;
    if (delta.dx < 0 && currentIndex < widget.itemCount - 1) {
      _animateToPage(
        (currentIndex + 1).toDouble(),
        commitIndex: currentIndex + 1,
      );
      return;
    }

    if (delta.dx > 0 && currentIndex > 0) {
      _animateToPage(
        (currentIndex - 1).toDouble(),
        commitIndex: currentIndex - 1,
      );
      return;
    }

    if (delta.dx > 0 && currentIndex == 0) {
      _animateToPage(
        currentIndex.toDouble(),
        edgeAction: widget.onSwipePastStart,
      );
      return;
    }

    if (delta.dx < 0 && currentIndex == widget.itemCount - 1) {
      _animateToPage(
        currentIndex.toDouble(),
        edgeAction: widget.onSwipePastEnd,
      );
    }
  }

  Iterable<int> _visibleIndices() sync* {
    final leading = _page.floor().clamp(0, widget.itemCount - 1);
    final trailing = _page.ceil().clamp(0, widget.itemCount - 1);
    yield leading;
    if (trailing != leading) {
      yield trailing;
    }
  }

  Widget _cachedChild(BuildContext context, int index) {
    return _childCache.putIfAbsent(
      index,
      () => RepaintBoundary(
        child: widget.itemBuilder(context, index),
      ),
    );
  }

  double _resolveViewportWidth(BuildContext context, double fallbackWidth) {
    final renderObject = _viewportKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final width = renderObject.size.width;
      if (width > 0) {
        return width;
      }
    }

    if (fallbackWidth.isFinite && fallbackWidth > 0) {
      return fallbackWidth;
    }

    final mediaWidth = MediaQuery.sizeOf(context).width;
    return mediaWidth > 0 ? mediaWidth : 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportWidth = _resolveViewportWidth(context, constraints.maxWidth);
        final visibleIndices = _visibleIndices().toList(growable: false);

        return Listener(
          onPointerDown: _handlePointerDown,
          onPointerUp: _handlePointerUp,
          onPointerCancel: _handlePointerCancel,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: _handleHorizontalDragStart,
            onHorizontalDragUpdate: _handleHorizontalDragUpdate,
            onHorizontalDragEnd: _handleHorizontalDragEnd,
            onHorizontalDragCancel: _handleHorizontalDragCancel,
            child: SizedBox(
              key: _viewportKey,
              child: ClipRect(
                child: Stack(
                  children: [
                    for (final index in visibleIndices)
                      Transform.translate(
                        offset: Offset((index - _page) * _viewportWidth, 0),
                        child: _cachedChild(context, index),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
                        Theme.of(context)
                            .colorScheme
                            .tertiary
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
