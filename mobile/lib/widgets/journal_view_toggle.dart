import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class JournalViewToggle extends StatelessWidget {
  const JournalViewToggle({
    super.key,
    required this.isBook,
    required this.onBook,
    required this.onTimeline,
  });

  final bool isBook;
  final VoidCallback onBook;
  final VoidCallback onTimeline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inkBrown.withValues(alpha: 0.16)),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            label: 'Book',
            icon: Icons.auto_stories_outlined,
            selected: isBook,
            onTap: () {
              if (!isBook) {
                HapticFeedback.selectionClick();
                onBook();
              }
            },
          ),
          _Segment(
            label: 'Timeline',
            icon: Icons.view_timeline_outlined,
            selected: !isBook,
            onTap: () {
              if (isBook) {
                HapticFeedback.selectionClick();
                onTimeline();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.coffeeBrown.withValues(alpha: 0.18) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: selected ? AppColors.coffeeBrown : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.caveat(
                  fontSize: 17,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.coffeeBrown : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookPageControls extends StatelessWidget {
  const BookPageControls({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.canPrevious,
    required this.canNext,
    this.pageLabel,
  });

  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canPrevious;
  final bool canNext;
  final String? pageLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundNav(icon: Icons.chevron_left, enabled: canPrevious, onTap: onPrevious),
        const SizedBox(width: 12),
        if (pageLabel != null)
          Text(pageLabel!, style: GoogleFonts.caveat(fontSize: 16, color: AppColors.textMuted)),
        const SizedBox(width: 12),
        _RoundNav(icon: Icons.chevron_right, enabled: canNext, onTap: onNext),
      ],
    );
  }
}

class _RoundNav extends StatelessWidget {
  const _RoundNav({required this.icon, required this.enabled, required this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? const Color(0xFFFFFDF8) : AppColors.paper.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onTap();
              }
            : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: enabled ? AppColors.coffeeBrown : AppColors.textSubtle),
        ),
      ),
    );
  }
}
