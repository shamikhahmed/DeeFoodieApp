import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/karachi_dictionary.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/journal_screen_shell.dart';
import '../widgets/content_sheet.dart';

class KarachiDictionaryScreen extends StatelessWidget {
  const KarachiDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return JournalScreenShell(
      title: l10n.dictionaryTitle,
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: karachiDictionary.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, i) {
          final e = karachiDictionary[i];
          return ContentSheet(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.term, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.coffeeBrown)),
                const SizedBox(height: 6),
                Text(e.meaning, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45)),
                if (e.example != null) ...[
                  const SizedBox(height: 6),
                  Text(e.example!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
