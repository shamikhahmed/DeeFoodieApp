import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/wave3_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_screen_shell.dart';
import '../widgets/glass_surface.dart';

class TheOrderScreen extends ConsumerWidget {
  const TheOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stats = ref.watch(theOrderProvider);

    return JournalScreenShell(
      title: l10n.theOrderTitle,
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.coffeeBrown)),
        error: (_, _) => Center(child: Text(l10n.errorExplore)),
        data: (list) {
          if (list.isEmpty) {
            return Center(child: Text(l10n.theOrderEmpty, textAlign: TextAlign.center));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final s = list[i];
              return GlassSurface(
                child: Row(
                  children: [
                    Text('${i + 1}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.coffeeBrown)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: Text(s.name, style: Theme.of(context).textTheme.titleMedium)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(l10n.theOrderCount(s.count), style: Theme.of(context).textTheme.labelLarge),
                        if (s.avgRating > 0)
                          Text('★ ${s.avgRating.toStringAsFixed(1)}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.rust)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
