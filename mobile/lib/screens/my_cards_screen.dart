import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/discount_programs.dart';
import '../l10n/app_localizations.dart';
import '../providers/discount_cards_provider.dart';
import '../theme/app_theme.dart';
import '../utils/haptics.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_surface.dart';

class MyCardsScreen extends ConsumerWidget {
  const MyCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(discountCardsProvider);

    final banks = kDiscountPrograms.where((p) => p.type == DiscountProgramType.bank).toList();
    final aggregators = kDiscountPrograms.where((p) => p.type == DiscountProgramType.aggregator).toList();
    final wallets = kDiscountPrograms.where((p) => p.type == DiscountProgramType.wallet).toList();
    final loyalty = kDiscountPrograms.where((p) => p.type == DiscountProgramType.loyalty).toList();

    return AppBackground(
      variant: AppBackgroundVariant.profile,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => Navigator.pop(context)),
          title: Text(l10n.myCardsTitle),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 120),
          children: [
            GlassSurface(
              child: Text(l10n.myCardsSubtitle, style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: AppSpacing.md),
            _Section(title: l10n.myCardsAggregators, programs: aggregators, selected: selected, ref: ref),
            _Section(title: l10n.myCardsBanks, programs: banks, selected: selected, ref: ref),
            _Section(title: l10n.myCardsWallets, programs: wallets, selected: selected, ref: ref),
            _Section(title: l10n.myCardsLoyalty, programs: loyalty, selected: selected, ref: ref),
            const SizedBox(height: AppSpacing.md),
            GlassSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.myCardsPartnerNote, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text(l10n.myCardsNoPublicApi, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => _open('https://golootlo.pk/deals-and-discounts'),
                        child: const Text('Golootlo'),
                      ),
                      OutlinedButton(
                        onPressed: () => _open('https://apps.apple.com/pk/app/peekaboo-guru/id1114129707'),
                        child: const Text('Peekaboo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.programs, required this.selected, required this.ref});

  final String title;
  final List<DiscountProgram> programs;
  final Set<String> selected;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: programs.map((p) {
                final on = selected.contains(p.id);
                return FilterChip(
                  label: Text(p.name),
                  selected: on,
                  onSelected: (_) {
                    AppHaptics.selection();
                    ref.read(discountCardsProvider.notifier).toggle(p.id);
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
