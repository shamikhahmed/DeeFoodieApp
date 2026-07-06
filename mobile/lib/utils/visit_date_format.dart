import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class VisitDateParts {
  const VisitDateParts({required this.month, required this.dayLine, this.weekday});

  final String month;
  final String dayLine;
  final String? weekday;
}

VisitDateParts parseVisitDateParts(String iso) {
  try {
    final d = DateTime.parse(iso);
    return VisitDateParts(
      month: DateFormat('MMM').format(d).toUpperCase(),
      dayLine: DateFormat('d · yyyy').format(d),
      weekday: DateFormat('EEEE').format(d),
    );
  } catch (_) {
    return VisitDateParts(month: '', dayLine: iso);
  }
}

String formatVisitTime(String? time) {
  if (time == null || time.isEmpty) return '';
  try {
    final parts = time.split(':');
    if (parts.length >= 2) {
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      return DateFormat('h:mm a').format(DateTime(2000, 1, 1, h, m));
    }
  } catch (_) {}
  return time;
}

Widget visitDateHeader(String iso, {double scale = 1, String? time}) {
  final parts = parseVisitDateParts(iso);
  final timeLabel = formatVisitTime(time);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (parts.weekday != null)
        Text(
          parts.weekday!,
          style: GoogleFonts.caveat(
            fontSize: 14 * scale,
            color: AppColors.coffeeBrown,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            parts.month,
            style: GoogleFonts.caveat(
              fontSize: 22 * scale,
              color: AppColors.rust,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              parts.dayLine,
              style: GoogleFonts.fraunces(
                fontSize: 18 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.inkBrown,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      if (timeLabel.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(top: 4 * scale),
          child: Text(
            timeLabel,
            style: GoogleFonts.inter(
              fontSize: 12 * scale,
              fontWeight: FontWeight.w500,
              color: AppColors.inkBrown.withValues(alpha: 0.72),
            ),
          ),
        ),
    ],
  );
}

String memoryPhotoLabel(String tag) => switch (tag) {
      'friends' => 'Friends',
      'family' => 'Family',
      'group' => 'Group',
      _ => 'Memory',
    };
