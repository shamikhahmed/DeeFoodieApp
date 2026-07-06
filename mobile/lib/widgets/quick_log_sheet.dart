import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/journal_form.dart';
import '../widgets/journal_paper.dart';
import '../widgets/rating_stars.dart';

class QuickLogSheet extends ConsumerStatefulWidget {
  const QuickLogSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickLogSheet(),
    );
  }

  @override
  ConsumerState<QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<QuickLogSheet> {
  String? _eateryId;
  double _rating = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eateries = ref.watch(allEateriesProvider).asData?.value ?? [];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: JournalPaper(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.quickLogTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _eateryId ?? (eateries.isNotEmpty ? eateries.first.id : null),
                decoration: journalInputDecoration(hint: l10n.addVisitEatery),
                items: eateries.take(50).map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                onChanged: (v) => setState(() => _eateryId = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  RatingStars(rating: _rating),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 8,
                      onChanged: (v) => setState(() => _rating = v),
                      activeColor: AppColors.coffeeBrown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: eateries.isEmpty
                    ? null
                    : () {
                        AppHaptics.medium();
                        final id = _eateryId ?? eateries.first.id;
                        Navigator.pop(context);
                        context.push('/add-visit?eateryId=$id&rating=$_rating');
                      },
                style: FilledButton.styleFrom(backgroundColor: AppColors.coffeeBrown, foregroundColor: AppColors.paper),
                child: Text(l10n.quickLogContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
