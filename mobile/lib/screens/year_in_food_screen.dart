import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/year_in_food_provider.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/app_background.dart';
import '../widgets/content_sheet.dart';
import '../utils/eatery_display.dart';
import '../widgets/glass_surface.dart';

class YearInFoodScreen extends ConsumerWidget {
  const YearInFoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final data = ref.watch(yearInFoodProvider);

    return AppBackground(
      variant: AppBackgroundVariant.journal,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(l10n.yearInFoodTitle),
        ),
        body: data.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (wrapped) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassSurface(
                  borderRadius: 24,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          '${wrapped.year}',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.coffeeBrown,
                              ),
                        ),
                        Text(
                          l10n.yearInFoodSubtitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _StatRow(
                  label: l10n.yearInFoodVisits,
                  value: '${wrapped.visitCount}',
                  icon: Icons.menu_book_outlined,
                ),
                _StatRow(
                  label: l10n.yearInFoodPlaces,
                  value: '${wrapped.uniquePlaces}',
                  icon: Icons.storefront_outlined,
                ),
                if (wrapped.totalSpent > 0)
                  _StatRow(
                    label: l10n.yearInFoodSpent,
                    value: formatRs(wrapped.totalSpent),
                    icon: Icons.payments_outlined,
                  ),
                _StatRow(
                  label: l10n.yearInFoodTopArea,
                  value: wrapped.topArea,
                  icon: Icons.location_on_outlined,
                ),
                _StatRow(
                  label: l10n.yearInFoodTopDish,
                  value: wrapped.topDish,
                  icon: Icons.restaurant_outlined,
                ),
                const SizedBox(height: 16),
                ContentSheet(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.yearInFoodStory,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ...wrapped.narrative.map(
                        (line) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 18)),
                              Expanded(
                                child: Text(
                                  line,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (wrapped.bestVisit != null) ...[
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: () {
                            AppHaptics.light();
                            context.push('/visit/${wrapped.bestVisit!.id}');
                          },
                          icon: const Icon(Icons.star_outline),
                          label: Text(l10n.yearInFoodBestVisit),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassSurface(
        borderRadius: 16,
        child: ListTile(
          leading: Icon(icon, color: AppColors.coffeeBrown),
          title: Text(label),
          trailing: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
