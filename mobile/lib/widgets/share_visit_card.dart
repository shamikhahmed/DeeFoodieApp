import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/visit.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import '../utils/visit_date_format.dart';

class ShareVisitCard extends StatelessWidget {
  const ShareVisitCard({super.key, required this.visit});

  final Visit visit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.coffeeBrown.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: AppColors.inkBrown.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('DeeFoodieApp', style: GoogleFonts.caveat(fontSize: 18, color: AppColors.coffeeBrown)),
          const SizedBox(height: 8),
          visitDateHeader(visit.date, time: visit.time, scale: 0.9),
          const SizedBox(height: 8),
          Text(visit.eateryName, style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.inkBrown)),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.rust, size: 20),
              Text(' ${visit.rating.toStringAsFixed(1)}', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ],
          ),
          if (visit.reviewText != null && visit.reviewText!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(visit.reviewText!, maxLines: 4, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 14, height: 1.4)),
          ],
          if (visit.totalBill != null) ...[
            const SizedBox(height: 8),
            Text(formatRs(visit.totalBill!), style: GoogleFonts.inter(color: AppColors.coffeeBrown, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}
