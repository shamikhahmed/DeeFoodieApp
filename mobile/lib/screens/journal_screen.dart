import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/share_visit_sheet.dart';
import '../utils/journal_pdf.dart';
import '../widgets/sticker_empty_state.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/food_visuals.dart';
import '../widgets/rating_stars.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../providers/user_archive_prefs_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/visit.dart';
import '../router/navigation.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_display.dart';
import '../widgets/journal_paper.dart';
import '../widgets/journal_book_view.dart';
import '../providers/journal_view_provider.dart';
import '../widgets/journal_view_toggle.dart';
import '../utils/haptics.dart';
import '../widgets/demo_mode_banner.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visitsAsync = ref.watch(filteredVisitsProvider);
    final stats = ref.watch(personalStatsProvider);
    final viewMode = ref.watch(journalViewModeProvider);

    return JournalPaper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.lg,
                  AppSpacing.screenPadding,
                  AppSpacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.menu_book_rounded, size: 36, color: AppColors.coffeeBrown.withValues(alpha: 0.85)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.navJournal,
                            style: GoogleFonts.fraunces(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkBrown,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(l10n.journalSubtitle, style: journalInkStyle(context, size: 17)),
                          visitsAsync.maybeWhen(
                            data: (v) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                l10n.journalVisitCount(v.length),
                                style: GoogleFonts.caveat(fontSize: 16, color: AppColors.textSecondary),
                              ),
                            ),
                            orElse: () => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: AppColors.coffeeBrown),
                      tooltip: 'Journal options',
                      onSelected: (value) async {
                        if (value == 'toggle') {
                          AppHaptics.selection();
                          ref.read(journalViewModeProvider.notifier).toggle();
                        } else if (value == 'pdf') {
                          final visits = visitsAsync.asData?.value;
                          if (visits == null || visits.isEmpty) return;
                          AppHaptics.light();
                          await exportJournalPdf(title: l10n.navJournal, visits: visits);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(
                                viewMode == JournalViewMode.timeline ? Icons.auto_stories_outlined : Icons.view_timeline_outlined,
                                size: 20,
                                color: AppColors.coffeeBrown,
                              ),
                              const SizedBox(width: 10),
                              Text(viewMode == JournalViewMode.timeline ? l10n.journalViewBook : l10n.journalViewTimeline),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'pdf',
                          enabled: visitsAsync.maybeWhen(data: (v) => v.isNotEmpty, orElse: () => false),
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf_outlined, size: 20, color: AppColors.coffeeBrown),
                              const SizedBox(width: 10),
                              Text(l10n.journalExportPdf),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: visitsAsync.maybeWhen(
                  data: (v) => JournalStatsStrip(
                    visitCount: stats.visitCount,
                    places: stats.uniqueEateries,
                    areas: stats.areasVisited,
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: Center(
                  child: JournalViewToggle(
                    isBook: viewMode == JournalViewMode.book,
                    onBook: () => ref.read(journalViewModeProvider.notifier).set(JournalViewMode.book),
                    onTimeline: () => ref.read(journalViewModeProvider.notifier).set(JournalViewMode.timeline),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: DemoModeBanner(compact: true),
              ),
              const SizedBox(height: AppSpacing.sm),
              const _JournalMoodFilterRow(),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: visitsAsync.when(
                  data: (visits) {
                    final sorted = sortVisitsByDate(visits);
                    if (sorted.isEmpty) {
                      return StickerEmptyState(
                        message: '${l10n.journalEmptyTitle}\n\n${l10n.journalEmptyBody}',
                        photoUrl: accentPhoto('journalEmpty'),
                        actionLabel: l10n.addVisit,
                        onAction: () => context.push('/add-visit'),
                      );
                    }
                    final grouped = _groupByYear(sorted);
                    if (viewMode == JournalViewMode.book) {
                      return JournalBookView(
                        visits: sorted,
                        onShare: (v) => ShareVisitSheet.show(context, v),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.coffeeBrown,
                      onRefresh: () async => ref.invalidate(visitsProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          AppSpacing.sm,
                          AppSpacing.screenPadding,
                          140,
                        ),
                        itemCount: grouped.length,
                        itemBuilder: (context, i) {
                          final entry = grouped[i];
                          if (entry is _YearHeader) {
                            return JournalYearDivider(year: entry.year);
                          }
                          final v = (entry as _VisitEntry).visit;
                          return _JournalTimelineCard(
                            visit: v,
                            onTap: () => openVisit(context, v.id),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
                  error: (_, _) => StickerEmptyState(
                    message: l10n.errorExplore,
                    photoUrl: accentPhoto('journalEmpty'),
                    actionLabel: l10n.tryAgain,
                    onAction: () => ref.invalidate(visitsProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<Object> _groupByYear(List<Visit> visits) {
    final out = <Object>[];
    String? lastYear;
    for (final v in visits) {
      final year = _yearOf(v.date);
      if (year != lastYear) {
        out.add(_YearHeader(year));
        lastYear = year;
      }
      out.add(_VisitEntry(v));
    }
    return out;
  }

  static String _yearOf(String iso) {
    try {
      return DateTime.parse(iso).year.toString();
    } catch (_) {
      return iso.length >= 4 ? iso.substring(0, 4) : iso;
    }
  }
}

class _YearHeader {
  const _YearHeader(this.year);
  final String year;
}

class _VisitEntry {
  const _VisitEntry(this.visit);
  final Visit visit;
}

class _JournalMoodFilterRow extends ConsumerWidget {
  const _JournalMoodFilterRow();

  static const _moods = ['Friends', 'Family', 'Date', 'Alone', 'Late Night', 'Celebration'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(journalMoodFilterProvider);
    final notifier = ref.read(journalMoodFilterProvider.notifier);

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          children: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: JournalMoodChip(
                label: l10n.journalFilterAll,
                selected: selected == null,
                onTap: () => notifier.setFilter(null),
              ),
            ),
            for (final mood in _moods)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: JournalMoodChip(
                  label: mood,
                  selected: selected == mood,
                  onTap: () => notifier.setFilter(selected == mood ? null : mood),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JournalTimelineCard extends StatelessWidget {
  const _JournalTimelineCard({required this.visit, required this.onTap});

  final Visit visit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (month, day) = _formatDateParts(visit.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Column(
              children: [
                Text(
                  month,
                  style: GoogleFonts.caveat(fontSize: 14, color: AppColors.rust, fontWeight: FontWeight.w700),
                ),
                Text(day, style: GoogleFonts.fraunces(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.inkBrown)),
                Container(
                  width: 2,
                  height: 40,
                  margin: const EdgeInsets.only(top: 4),
                  color: AppColors.rust.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap();
                },
                borderRadius: BorderRadius.circular(4),
                child: JournalPageCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(visit.eateryName, style: GoogleFonts.fraunces(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.coffeeBrown)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          RatingStars(rating: visit.rating, size: 16),
                          const SizedBox(width: 6),
                          if (visit.userName != null)
                            Text(visit.userName!, style: GoogleFonts.caveat(fontSize: 15, color: AppColors.textSecondary)),
                        ],
                      ),
                      if (visit.favoriteItem != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${l10n.eateryMustTry}: ${visit.favoriteItem}',
                          style: GoogleFonts.caveat(fontSize: 16, color: AppColors.darkGreen, fontWeight: FontWeight.w600),
                        ),
                      ],
                      if (visit.moodTags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          visit.moodTags.take(3).join(' · '),
                          style: GoogleFonts.caveat(fontSize: 15, color: AppColors.textMuted),
                        ),
                      ],
                      if (visit.reviewText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          visit.reviewText!,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: journalInkStyle(context, size: 17),
                        ),
                      ],
                      if (visit.totalBill != null) ...[
                        const SizedBox(height: 6),
                        Text('${l10n.visitBill}: ${formatRs(visit.totalBill!)}', style: GoogleFonts.caveat(fontSize: 15, color: AppColors.rust)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  (String, String) _formatDateParts(String iso) {
    try {
      final d = DateTime.parse(iso);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return (months[d.month - 1], '${d.day}');
    } catch (_) {
      return ('', iso);
    }
  }
}
