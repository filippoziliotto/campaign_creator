import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StageRouteScaffold extends StatelessWidget {
  const StageRouteScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _StageScrollContainer(child: child);
  }
}

class _StageScrollContainer extends StatefulWidget {
  const _StageScrollContainer({required this.child});

  final Widget child;

  @override
  State<_StageScrollContainer> createState() => _StageScrollContainerState();
}

class _StageScrollContainerState extends State<_StageScrollContainer> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      controller: _scrollController,
      thumbVisibility: isTouchPlatform ? false : true,
      child: SingleChildScrollView(
        controller: _scrollController,
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
