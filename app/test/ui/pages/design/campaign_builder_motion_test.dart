import 'package:campaign_creator_flutter/src/ui/pages/design/campaign_builder_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'InteractiveHorizontalSectionPager caches visible children during drag',
    (tester) async {
      final buildCounts = <int, int>{0: 0, 1: 0, 2: 0};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                height: 240,
                child: InteractiveHorizontalSectionPager(
                  currentIndex: 0,
                  itemCount: 3,
                  duration: const Duration(milliseconds: 240),
                  itemBuilder: (context, index) {
                    buildCounts[index] = (buildCounts[index] ?? 0) + 1;
                    return ColoredBox(
                      key: ValueKey<String>('pager-page-$index'),
                      color: Colors.primaries[index],
                      child: Center(child: Text('Page $index')),
                    );
                  },
                  onIndexChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(buildCounts[0], 1);
      expect(buildCounts[1], 0);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey<String>('pager-page-0'))),
      );
      await gesture.moveBy(const Offset(-48, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(-48, 0));
      await tester.pump();

      expect(
          find.byKey(const ValueKey<String>('pager-page-1')), findsOneWidget);
      expect(buildCounts[0], 1);
      expect(buildCounts[1], 1);

      await gesture.moveBy(const Offset(-24, 0));
      await tester.pump();

      expect(buildCounts[0], 1);
      expect(buildCounts[1], 1);

      await gesture.up();
      await tester.pumpAndSettle();

      expect(buildCounts[0], 1);
      expect(buildCounts[1], 1);
    },
  );

  testWidgets(
    'InteractiveHorizontalSectionPager ignores diagonal drags in android vertical-priority mode',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                height: 240,
                child: InteractiveHorizontalSectionPager(
                  currentIndex: 0,
                  itemCount: 3,
                  duration: const Duration(milliseconds: 240),
                  horizontalGestureMode:
                      HorizontalGestureMode.androidVerticalPriority,
                  itemBuilder: (context, index) {
                    return ColoredBox(
                      key: ValueKey<String>('pager-page-$index'),
                      color: Colors.primaries[index],
                      child: Center(child: Text('Page $index')),
                    );
                  },
                  onIndexChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey<String>('pager-page-0'))),
      );
      await gesture.moveBy(const Offset(-42, 96));
      await tester.pump();
      await gesture.moveBy(const Offset(-42, 96));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('pager-page-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('pager-page-1')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'InteractiveHorizontalSectionPager still accepts clear horizontal drags in android vertical-priority mode',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                height: 240,
                child: InteractiveHorizontalSectionPager(
                  currentIndex: 0,
                  itemCount: 3,
                  duration: const Duration(milliseconds: 240),
                  horizontalGestureMode:
                      HorizontalGestureMode.androidVerticalPriority,
                  itemBuilder: (context, index) {
                    return ColoredBox(
                      key: ValueKey<String>('pager-page-$index'),
                      color: Colors.primaries[index],
                      child: Center(child: Text('Page $index')),
                    );
                  },
                  onIndexChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const ValueKey<String>('pager-page-0'))),
      );
      await gesture.moveBy(const Offset(-72, 12));
      await tester.pump();
      await gesture.moveBy(const Offset(-72, 12));
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('pager-page-1')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'InteractiveHorizontalSectionPager refreshes cached children after parent rebuilds',
    (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: _PagerCacheInvalidationHost()));
      await tester.pump();

      expect(find.text('Page 0 v1'), findsOneWidget);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Page 0 v1')),
      );
      await gesture.moveBy(const Offset(-96, 0));
      await tester.pump();

      expect(find.text('Page 1 v1'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bump version'));
      await tester.pumpAndSettle();

      expect(find.text('Page 0 v2'), findsOneWidget);

      final secondGesture = await tester.startGesture(
        tester.getCenter(find.text('Page 0 v2')),
      );
      await secondGesture.moveBy(const Offset(-96, 0));
      await tester.pump();

      expect(find.text('Page 1 v2'), findsOneWidget);
    },
  );

  testWidgets(
    'InteractiveHorizontalSectionPager keeps off-screen cached children across unrelated parent rebuilds',
    (tester) async {
      final hostKey = GlobalKey<_PagerOffstageCacheRetentionHostState>();
      await tester.pumpWidget(
          MaterialApp(home: _PagerOffstageCacheRetentionHost(key: hostKey)));
      await tester.pump();

      expect(find.text('Page 0 built 1x'), findsOneWidget);
      expect(hostKey.currentState!._buildCounts[1], 0);

      final firstGesture = await tester.startGesture(
        tester.getCenter(find.text('Page 0 built 1x')),
      );
      await firstGesture.moveBy(const Offset(-96, 0));
      await tester.pump();
      expect(hostKey.currentState!._buildCounts[1], 1);
      await firstGesture.up();
      await tester.pumpAndSettle();

      final pageOneBuildCountAfterFirstReveal =
          hostKey.currentState!._buildCounts[1];

      await tester.tap(find.text('Rebuild parent'));
      await tester.pumpAndSettle();
      expect(
        hostKey.currentState!._buildCounts[1],
        pageOneBuildCountAfterFirstReveal,
      );

      final secondGesture = await tester.startGesture(
        tester.getCenter(find.byType(InteractiveHorizontalSectionPager)),
      );
      await secondGesture.moveBy(const Offset(-96, 0));
      await tester.pump();

      expect(
        hostKey.currentState!._buildCounts[1],
        pageOneBuildCountAfterFirstReveal,
      );
    },
  );
}

class _PagerCacheInvalidationHost extends StatefulWidget {
  const _PagerCacheInvalidationHost();

  @override
  State<_PagerCacheInvalidationHost> createState() =>
      _PagerCacheInvalidationHostState();
}

class _PagerCacheInvalidationHostState
    extends State<_PagerCacheInvalidationHost> {
  int _version = 1;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _version += 1;
                _currentIndex = 0;
              });
            },
            child: const Text('Bump version'),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 320,
                height: 240,
                child: InteractiveHorizontalSectionPager(
                  currentIndex: _currentIndex,
                  itemCount: 3,
                  duration: const Duration(milliseconds: 240),
                  itemCacheKeys: List<Object?>.filled(3, _version),
                  itemBuilder: (context, index) {
                    return ColoredBox(
                      color: Colors.primaries[index],
                      child: Center(
                        child: Text('Page $index v$_version'),
                      ),
                    );
                  },
                  onIndexChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PagerOffstageCacheRetentionHost extends StatefulWidget {
  const _PagerOffstageCacheRetentionHost({super.key});

  @override
  State<_PagerOffstageCacheRetentionHost> createState() =>
      _PagerOffstageCacheRetentionHostState();
}

class _PagerOffstageCacheRetentionHostState
    extends State<_PagerOffstageCacheRetentionHost> {
  int _currentIndex = 0;
  int _irrelevantCounter = 0;
  final Map<int, int> _buildCounts = <int, int>{0: 0, 1: 0, 2: 0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                child: const Text('Go to page 0'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _irrelevantCounter += 1;
                  });
                },
                child: const Text('Rebuild parent'),
              ),
            ],
          ),
          Text('Counter $_irrelevantCounter'),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 320,
                height: 240,
                child: InteractiveHorizontalSectionPager(
                  currentIndex: _currentIndex,
                  itemCount: 3,
                  duration: const Duration(milliseconds: 240),
                  itemCacheKeys: const <Object?>[0, 1, 2],
                  itemBuilder: (context, index) {
                    _buildCounts[index] = (_buildCounts[index] ?? 0) + 1;
                    return ColoredBox(
                      color: Colors.primaries[index],
                      child: Center(
                        child:
                            Text('Page $index built ${_buildCounts[index]}x'),
                      ),
                    );
                  },
                  onIndexChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
