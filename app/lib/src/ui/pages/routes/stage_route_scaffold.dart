import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StageRouteScaffold extends StatelessWidget {
  const StageRouteScaffold({
    super.key,
    required this.child,
    this.scrollController,
  });

  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return _StageScrollContainer(
      scrollController: scrollController,
      child: child,
    );
  }
}

class _StageScrollContainer extends StatefulWidget {
  const _StageScrollContainer({required this.child, this.scrollController});

  final Widget child;
  final ScrollController? scrollController;

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
    final isTouchPlatform = const {
      TargetPlatform.android,
      TargetPlatform.iOS,
    }.contains(defaultTargetPlatform);

    return Scrollbar(
      controller: _effectiveController,
      thumbVisibility: isTouchPlatform ? false : true,
      child: SingleChildScrollView(
        controller: _effectiveController,
        primary: false,
        padding: EdgeInsets.fromLTRB(
          compact ? 16 : 20,
          0,
          compact ? 16 : 20,
          compact ? 24 : 32,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1380),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
