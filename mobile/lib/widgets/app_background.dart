import 'package:flutter/material.dart';
import 'journal_paper.dart';

enum AppBackgroundVariant {
  home('assets/backgrounds/karachi_clifton_sunset.jpg', 0.48, 0.64, showSkyline: true),
  explore('assets/backgrounds/karachi_food_street.jpg', 0.46, 0.62, showSkyline: false),
  map('assets/backgrounds/karachi_seafront_evening.jpg', 0.52, 0.68, showSkyline: false),
  profile('assets/backgrounds/karachi_coast_aerial.jpg', 0.50, 0.66, showSkyline: false),
  foodStreet('assets/backgrounds/karachi_food_street.jpg', 0.44, 0.60, showSkyline: false),
  journal('assets/backgrounds/paper_texture.jpg', 0.22, 0.38, showSkyline: false);

  const AppBackgroundVariant(
    this.asset,
    this.scrimTop,
    this.scrimBottom, {
    this.showSkyline = false,
  });

  final String asset;
  final double scrimTop;
  final double scrimBottom;
  final bool showSkyline;
}

enum PaperBackgroundVariant {
  journal('assets/backgrounds/paper_texture.jpg');

  const PaperBackgroundVariant(this.asset);
  final String asset;
}

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.variant,
    required this.child,
    this.scrollController,
  });

  final AppBackgroundVariant variant;
  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return JournalPaper(
      showMargin: variant != AppBackgroundVariant.map,
      child: child,
    );
  }
}

class PaperBackground extends StatelessWidget {
  const PaperBackground({
    super.key,
    this.variant = PaperBackgroundVariant.journal,
    required this.child,
  });

  final PaperBackgroundVariant variant;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return JournalPaper(child: child);
  }
}
