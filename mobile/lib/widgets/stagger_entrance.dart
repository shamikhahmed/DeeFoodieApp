import 'package:flutter/material.dart';

class StaggerEntrance extends StatelessWidget {
  const StaggerEntrance({
    super.key,
    required this.index,
    required this.child,
    this.baseDelayMs = 40,
  });

  final int index;
  final Widget child;
  final int baseDelayMs;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + index * baseDelayMs),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 20 * (1 - t)), child: child),
      ),
      child: child,
    );
  }
}
