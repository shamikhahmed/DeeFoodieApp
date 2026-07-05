import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Ruled notebook paper — lines + left margin.
class NotebookRuledPainter extends CustomPainter {
  NotebookRuledPainter({this.lineSpacing = 28, this.showMargin = true});

  final double lineSpacing;
  final bool showMargin;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.inkBrown.withValues(alpha: 0.07)
      ..strokeWidth = 1;

    for (var y = lineSpacing; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    if (showMargin) {
      final marginPaint = Paint()
        ..color = AppColors.rust.withValues(alpha: 0.28)
        ..strokeWidth = 1.2;
      canvas.drawLine(const Offset(52, 0), Offset(52, size.height), marginPaint);
    }
  }

  @override
  bool shouldRepaint(covariant NotebookRuledPainter old) => false;
}

class JournalPaper extends StatelessWidget {
  const JournalPaper({super.key, required this.child, this.showMargin = true});

  final Widget child;
  final bool showMargin;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF6EFE3),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFAF4EA),
                  AppColors.paper,
                  const Color(0xFFEDE4D4),
                ],
              ),
            ),
          ),
          CustomPaint(painter: NotebookRuledPainter(showMargin: showMargin)),
          child,
        ],
      ),
    );
  }
}

class JournalPageCard extends StatelessWidget {
  const JournalPageCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF6),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.inkBrown.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkBrown.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: child,
    );
  }
}

class JournalYearDivider extends StatelessWidget {
  const JournalYearDivider({super.key, required this.year});

  final String year;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.fraunces(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.coffeeBrown,
      fontStyle: FontStyle.italic,
    );
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.coffeeBrown.withValues(alpha: 0.25))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(year, style: style),
          ),
          Expanded(child: Divider(color: AppColors.coffeeBrown.withValues(alpha: 0.25))),
        ],
      ),
    );
  }
}

class JournalStatsStrip extends StatelessWidget {
  const JournalStatsStrip({
    super.key,
    required this.visitCount,
    required this.places,
    required this.areas,
  });

  final int visitCount;
  final int places;
  final int areas;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.caveat(fontSize: 18, color: AppColors.inkBrown, height: 1.2);
    return JournalPageCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        '$visitCount visits · $places places · $areas areas explored',
        style: style,
      ),
    );
  }
}

class JournalMoodChip extends StatelessWidget {
  const JournalMoodChip({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFF9F0) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.rust : AppColors.inkBrown.withValues(alpha: 0.2),
                width: selected ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.caveat(
              fontSize: 17,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.coffeeBrown : AppColors.inkBrown.withValues(alpha: 0.75),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle journalHandStyle(BuildContext context, {double size = 16, FontWeight weight = FontWeight.w500}) {
  return GoogleFonts.fraunces(
    fontSize: size,
    fontWeight: weight,
    color: AppColors.inkBrown,
    height: 1.35,
  );
}

TextStyle journalInkStyle(BuildContext context, {double size = 15}) {
  return GoogleFonts.caveat(
    fontSize: size,
    color: AppColors.inkBrown.withValues(alpha: 0.92),
    height: 1.4,
  );
}
