import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../router/navigation.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import '../widgets/journal_paper.dart';
import '../widgets/primary_button.dart';
import '../widgets/rating_stars.dart';
import '../providers/profile_prefs_provider.dart';
import '../utils/visit_owner.dart';
import '../widgets/share_visit_sheet.dart';
import '../widgets/visit_photo_image.dart';

class VisitDetailScreen extends ConsumerWidget {
  const VisitDetailScreen({super.key, required this.visitId});

  final String visitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visitAsync = ref.watch(visitDetailProvider(visitId));

    return visitAsync.when(
      data: (visit) {
        if (visit == null) {
          return JournalPaper(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => context.pop()),
              ),
              body: Center(child: Text(l10n.visitNotFound, style: journalHandStyle(context))),
            ),
          );
        }
        final profile = ref.watch(userProfileProvider);
        final canEdit = canEditVisit(visit, profile);
        final date = _formatDate(visit.date);

        return JournalPaper(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                visit.eateryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.fraunces(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: AppColors.inkBrown),
              ),
              leading: IconButton(icon: const Icon(CupertinoIcons.back, color: AppColors.coffeeBrown), onPressed: () => context.pop()),
              actions: [
                if (canEdit)
                  IconButton(
                    icon: const Icon(CupertinoIcons.pencil, color: AppColors.coffeeBrown),
                    onPressed: () => context.push('/edit-visit/${visit.id}'),
                  ),
                IconButton(
                  icon: const Icon(CupertinoIcons.square_arrow_up, color: AppColors.coffeeBrown),
                  onPressed: () => ShareVisitSheet.show(context, visit),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 0, AppSpacing.screenPadding, AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(date, style: GoogleFonts.caveat(fontSize: 18, color: AppColors.rust, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(visit.eateryName, style: GoogleFonts.fraunces(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.coffeeBrown)),
                  if (visit.userName != null) ...[
                    const SizedBox(height: 4),
                    Text('${l10n.visitBy} ${visit.userName}', style: journalInkStyle(context, size: 17)),
                  ],
                  if (visit.companions != null) ...[
                    const SizedBox(height: 2),
                    Text('${l10n.visitCompanions}: ${visit.companions}', style: journalInkStyle(context, size: 16)),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      RatingStars(rating: visit.rating, size: 22),
                      const SizedBox(width: 8),
                      Text(visit.rating.toStringAsFixed(1), style: GoogleFonts.fraunces(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.inkBrown)),
                    ],
                  ),
                  if (visit.moodTags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(visit.moodTags.join(' · '), style: GoogleFonts.caveat(fontSize: 17, color: AppColors.darkGreen)),
                  ],
                  if (visit.allPhotoUrls.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    for (final url in visit.allPhotoUrls)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: VisitPhotoImage(url: url, height: 220),
                        ),
                      ),
                  ],
                  if (visit.reviewText != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _sectionLabel(l10n.visitReview),
                    JournalPageCard(
                      child: Text(visit.reviewText!, style: GoogleFonts.caveat(fontSize: 20, height: 1.5, color: AppColors.inkBrown)),
                    ),
                  ],
                  if (visit.memoryNote != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _sectionLabel(l10n.visitMemory),
                    JournalPageCard(
                      child: Text(visit.memoryNote!, style: GoogleFonts.caveat(fontSize: 18, height: 1.45, color: AppColors.inkBrown.withValues(alpha: 0.9), fontStyle: FontStyle.italic)),
                    ),
                  ],
                  if (visit.favoriteItem != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${l10n.eateryMustTry}: ${visit.favoriteItem}',
                      style: GoogleFonts.caveat(fontSize: 18, color: AppColors.coffeeBrown, fontWeight: FontWeight.w600),
                    ),
                  ],
                  if (visit.items.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _sectionLabel(l10n.visitItems),
                    JournalPageCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (var i = 0; i < visit.items.length; i++) ...[
                            if (i > 0) Divider(height: 1, indent: 20, endIndent: 16, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(child: Text(visit.items[i].name, style: GoogleFonts.caveat(fontSize: 18, color: AppColors.inkBrown))),
                                  Text(visit.items[i].type, style: GoogleFonts.caveat(fontSize: 15, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (visit.totalBill != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${l10n.visitBill}: ${formatRs(visit.totalBill!)}',
                      style: GoogleFonts.caveat(fontSize: 20, color: AppColors.rust, fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: visit.eateryName,
                    icon: CupertinoIcons.location,
                    onPressed: () => openEatery(context, visit.eateryId),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => JournalPaper(
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
        ),
      ),
      error: (_, _) => JournalPaper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Text(l10n.errorExplore, style: journalHandStyle(context))),
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: GoogleFonts.fraunces(fontSize: 16, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: AppColors.coffeeBrown),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
    } catch (_) {
      return iso;
    }
  }
}
