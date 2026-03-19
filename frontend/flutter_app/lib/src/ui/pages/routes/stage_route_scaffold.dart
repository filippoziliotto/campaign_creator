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
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        primary: false,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
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
