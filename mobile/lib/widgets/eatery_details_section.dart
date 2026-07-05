import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/eatery.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';
import 'section_header.dart';

class EateryDetailsSection extends StatelessWidget {
  const EateryDetailsSection({super.key, required this.eatery});

  final Eatery eatery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = <Widget>[];

    if (eatery.famousFor != null) {
      rows.add(_row(Icons.star_outline_rounded, l10n.eateryFamousFor, eatery.famousFor!));
    }
    if (eatery.address != null) {
      rows.add(_row(Icons.location_on_outlined, l10n.addEateryAddress, eatery.address!));
    }
    if (eatery.phone != null) {
      rows.add(_row(Icons.phone_outlined, l10n.eateryPhone, eatery.phone!, onTap: () => _launch('tel:${eatery.phone}')));
    }
    if (eatery.openingHours != null) {
      rows.add(_row(Icons.schedule_outlined, l10n.eateryHours, eatery.openingHours!));
    }
    if (eatery.googleRating != null) {
      final count = eatery.googleReviewCount;
      final label = count == null
          ? '${eatery.googleRating!.toStringAsFixed(1)} ★ Google'
          : l10n.eateryGoogleRating(eatery.googleRating!, count);
      rows.add(_row(Icons.public_outlined, l10n.eateryExternalReviews, label));
    }

    if (rows.isEmpty && eatery.branches.isEmpty && eatery.externalReviews.isEmpty && eatery.promotions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rows.isNotEmpty) ...[
          SectionHeader(title: l10n.eateryDetails),
          GlassSurface(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md, color: AppColors.inkBrown.withValues(alpha: 0.1)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2), child: rows[i]),
                ],
              ],
            ),
          ),
        ],
        if (eatery.branches.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: l10n.eateryBranches),
          ...eatery.branches.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassSurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.name, style: Theme.of(context).textTheme.titleSmall),
                    Text('${b.area} · ${b.address}', style: Theme.of(context).textTheme.bodySmall),
                    if (b.phone != null) Text(b.phone!, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (eatery.externalReviews.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: l10n.eateryExternalReviews),
          ...eatery.externalReviews.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassSurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${r.source.toUpperCase()}${r.rating == null ? '' : ' · ${r.rating!.toStringAsFixed(1)} ★'}', style: Theme.of(context).textTheme.labelLarge),
                    if (r.snippet != null) Text(r.snippet!, style: Theme.of(context).textTheme.bodyMedium),
                    if (r.url != null)
                      TextButton(
                        onPressed: () => _launch(r.url!),
                        child: Text(l10n.eateryViewReview),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (eatery.promotions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(title: l10n.eateryPromotions),
          ...eatery.promotions.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassSurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, style: Theme.of(context).textTheme.titleSmall),
                    Text(p.description, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
          Text(l10n.discountsVerifyHint, style: Theme.of(context).textTheme.labelSmall),
        ],
        if (eatery.website != null || eatery.instagramUrl != null) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            children: [
              if (eatery.website != null)
                ActionChip(label: Text(l10n.eateryWebsite), onPressed: () => _launch(eatery.website!)),
              if (eatery.instagramUrl != null)
                ActionChip(label: Text(l10n.eateryInstagram), onPressed: () => _launch(eatery.instagramUrl!)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _row(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.coffeeBrown),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.coffeeBrown, fontWeight: FontWeight.w600)),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
