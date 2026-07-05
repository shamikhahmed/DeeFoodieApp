import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/discount_programs.dart';
import '../l10n/app_localizations.dart';
import '../providers/discount_cards_provider.dart';
import '../theme/app_theme.dart';
import '../utils/discount_match.dart';
import '../widgets/glass_surface.dart';

class DiscountDealsSection extends ConsumerWidget {
  const DiscountDealsSection({super.key, required this.eateryName});

  final String eateryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cards = ref.watch(discountCardsProvider);
    final deals = dealsForUserAtEatery(cards, eateryName);
    if (deals.isEmpty) return const SizedBox.shrink();

    return GlassSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, color: AppColors.rust, size: 22),
              const SizedBox(width: 8),
              Text(l10n.discountsTitle, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...deals.map((d) {
            final programs = d.programIds.map(programById).whereType<DiscountProgram>().toList();
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.offerText, style: Theme.of(context).textTheme.bodyLarge),
                  if (d.validDays != null)
                    Text(d.validDays!, style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: programs.map((p) => ActionChip(
                          label: Text(p.name),
                          onPressed: p.deepLink == null
                              ? null
                              : () async {
                                  final uri = Uri.parse(p.deepLink!);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                },
                        )).toList(),
                  ),
                ],
              ),
            );
          }),
          Text(l10n.discountsVerifyHint, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
