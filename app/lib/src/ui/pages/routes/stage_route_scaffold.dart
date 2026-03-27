import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StageRouteScaffold extends StatelessWidget {
  const StageRouteScaffold({
    super.key,
    required this.child,
    this.scrollController,
    this.useIntrinsicScroll = true,
  });

  final Widget child;
  final ScrollController? scrollController;
  final bool useIntrinsicScroll;

  @override
  Widget build(BuildContext context) {
    return _StageScrollContainer(
      scrollController: scrollController,
      useIntrinsicScroll: useIntrinsicScroll,
      child: child,
    );
  }
}

class _StageScrollContainer extends StatefulWidget {
  const _StageScrollContainer({
    required this.child,
    required this.useIntrinsicScroll,
    this.scrollController,
  });

  final Widget child;
  final ScrollController? scrollController;
  final bool useIntrinsicScroll;

  @override
  State<_StageScrollContainer> createState() => _StageScrollContainerState();
}

class _StageScrollContainerState extends State<_StageScrollContainer> {
  late final ScrollController _ownController;

  ScrollController get _effectiveController =>
      widget.scrollController ?? _ownController;

  @override
  void initState() {
    super.initState();
    _ownController = ScrollController();
  }

  @override
  void dispose() {
    _ownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 760;
    final bottomPadding =
        !widget.useIntrinsicScroll && compact ? 12.0 : (compact ? 24.0 : 32.0);
    final isTouchPlatform = const {
      TargetPlatform.android,
      TargetPlatform.iOS,
    }.contains(defaultTargetPlatform);
    final stageChild = Padding(
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 20,
        0,
        compact ? 16 : 20,
        bottomPadding,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1380),
          child: widget.child,
        ),
      ),
    );

    if (!widget.useIntrinsicScroll) {
      return stageChild;
    }

    return Scrollbar(
      controller: _effectiveController,
      thumbVisibility: isTouchPlatform ? false : true,
      child: SingleChildScrollView(
        controller: _effectiveController,
        primary: false,
        child: stageChild,
      ),
    );
  }
}
