import 'package:flutter/material.dart';
import 'journal_paper.dart';

/// Ruled notebook shell for main tab screens.
class TabScreenScaffold extends StatelessWidget {
  const TabScreenScaffold({super.key, required this.child, this.showMargin = true});

  final Widget child;
  final bool showMargin;

  @override
  Widget build(BuildContext context) {
    return JournalPaper(showMargin: showMargin, child: child);
  }
}
