import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../theme/app_theme.dart';
import '../utils/geo.dart';
import '../router/navigation.dart';
import '../widgets/eatery_card.dart';
import '../widgets/section_header.dart';

class NearbyEateriesSection extends ConsumerWidget {
  const NearbyEateriesSection({super.key, required this.eatery});

  final Eatery eatery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (eatery.lat == null || eatery.lng == null) return const SizedBox.shrink();

    final all = ref.watch(allEateriesProvider).asData?.value ?? [];
    final nearby = nearbySorted<Eatery>(
      lat: eatery.lat!,
      lng: eatery.lng!,
      items: all.where((e) => e.id != eatery.id && e.status != 'closed').toList(),
      itemLat: (e) => e.lat,
      itemLng: (e) => e.lng,
      maxKm: 4,
    ).take(5).toList();

    if (nearby.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l10n.nearbyTitle, subtitle: l10n.nearbySubtitle),
        ...nearby.map((e) => EateryCard(eatery: e, onTap: () => openEatery(context, e.id))),
      ],
    );
  }
}
