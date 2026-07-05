import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/wave3_providers.dart';
import '../router/navigation.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_screen_shell.dart';
import '../widgets/content_sheet.dart';
import '../widgets/eatery_card.dart';
import '../widgets/sticker_empty_state.dart';
import '../constants/food_visuals.dart';

class MissItScreen extends ConsumerWidget {
  const MissItScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final closed = ref.watch(closedEateriesProvider);

    return JournalScreenShell(
      title: l10n.missItTitle,
      subtitle: l10n.missItSubtitle,
      body: closed.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
        error: (_, _) => Center(child: Text(l10n.errorExplore)),
        data: (list) {
          if (list.isEmpty) {
            return StickerEmptyState(
              message: l10n.missItEmpty,
              photoUrl: accentPhoto('journalEmpty'),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              ContentSheet(
                child: Text(l10n.missItSubtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
              ),
              const SizedBox(height: AppSpacing.md),
              ...list.map(
                (e) => EateryCard(eatery: e, onTap: () => openEatery(context, e.id)),
              ),
            ],
          );
        },
      ),
    );
  }
}
