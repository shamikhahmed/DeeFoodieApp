import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/discount_programs.dart';
import '../l10n/app_localizations.dart';
import '../providers/discount_cards_provider.dart';
import '../providers/taste_profile_provider.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_surface.dart';

class TasteProfileScreen extends ConsumerStatefulWidget {
  const TasteProfileScreen({super.key});

  @override
  ConsumerState<TasteProfileScreen> createState() => _TasteProfileScreenState();
}

class _TasteProfileScreenState extends ConsumerState<TasteProfileScreen> {
  static const _genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
  static const _spice = ['Mild', 'Medium', 'Spicy', 'Extra spicy'];
  static const _sweets = ['Love sweets', 'Sometimes', 'Rarely', 'Never'];
  static const _budgets = ['Budget', 'Mid-range', 'Splurge', 'No limit'];
  static const _cuisines = ['Desi', 'Chinese', 'BBQ', 'Biryani', 'Continental', 'Dessert', 'Street Food', 'Seafood', 'Breakfast'];
  static const _avoids = ['Very oily', 'Too sweet', 'Too spicy', 'No AC needed', 'Quiet only'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(tasteProfileProvider);

    return AppBackground(
      variant: AppBackgroundVariant.profile,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
          title: Text(l10n.tasteProfileTitle),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 120),
          children: [
            _chipSection(l10n.tasteGender, _genders, profile.gender, (v) => _patch((p) => p.copyWith(gender: v))),
            _chipSection(l10n.tasteSpice, _spice, profile.spiceLevel, (v) => _patch((p) => p.copyWith(spiceLevel: v))),
            _chipSection(l10n.tasteSweets, _sweets, profile.sweetsPreference, (v) => _patch((p) => p.copyWith(sweetsPreference: v))),
            _chipSection(l10n.tasteBudget, _budgets, profile.budgetRange, (v) => _patch((p) => p.copyWith(budgetRange: v))),
            _multiSection(l10n.tasteCuisines, _cuisines, profile.favoriteCuisines),
            _multiSection(l10n.tasteAvoids, _avoids, profile.avoids, isAvoids: true),
          ],
        ),
      ),
    );
  }

  Future<void> _patch(TasteProfile Function(TasteProfile) fn) async {
    AppHaptics.selection();
    await ref.read(tasteProfileProvider.notifier).patch(fn);
  }

  Widget _chipSection(String title, List<String> options, String selected, ValueChanged<String> onSelect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((o) {
                return ChoiceChip(
                  label: Text(o),
                  selected: selected == o,
                  onSelected: (_) => onSelect(o),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _multiSection(String title, List<String> options, List<String> selected, {bool isAvoids = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((o) {
                final on = selected.contains(o);
                return FilterChip(
                  label: Text(o),
                  selected: on,
                  onSelected: (s) async {
                    AppHaptics.selection();
                    await ref.read(tasteProfileProvider.notifier).patch((p) {
                      final list = List<String>.from(isAvoids ? p.avoids : p.favoriteCuisines);
                      if (s) {
                        list.add(o);
                      } else {
                        list.remove(o);
                      }
                      return isAvoids ? p.copyWith(avoids: list) : p.copyWith(favoriteCuisines: list);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
