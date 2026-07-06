import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/eatery.dart';
import '../theme/app_theme.dart';
import '../utils/eatery_cover.dart';
import '../utils/eatery_display.dart';
import 'glass_surface.dart';
import 'shimmer_box.dart';

class EateryCard extends StatelessWidget {
  const EateryCard({
    super.key,
    required this.eatery,
    this.index = 0,
    this.compact = false,
    this.onTap,
    this.showDealBadge = false,
  });

  final Eatery eatery;
  final int index;
  final bool compact;
  final VoidCallback? onTap;
  final bool showDealBadge;

  @override
  Widget build(BuildContext context) {
    final child = compact ? _buildCompact(context) : _buildFull(context);

    return Semantics(
      button: onTap != null,
      label: '${eatery.name}${eatery.areaName != null ? ', ${eatery.areaName}' : ''}${eatery.avgRating != null ? ', ${eatery.avgRating!.toStringAsFixed(1)} stars' : ''}',
      child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + (index.clamp(0, 10) * 40)),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 14 * (1 - t)), child: child),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  onTap!();
                },
          mouseCursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
          borderRadius: BorderRadius.circular(compact ? 18 : 20),
          child: child,
        ),
      ),
    ),
    );
  }

  Widget _buildFull(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
      child: GlassSurface(
        padding: const EdgeInsets.all(AppSpacing.sm + 4),
        child: Row(
          children: [
            _EateryThumbnail(eatery: eatery, size: 56),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(child: _EateryMeta(eatery: eatery, compact: false, showDealBadge: showDealBadge)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return SizedBox(
      width: 168,
      child: GlassSurface(
        padding: const EdgeInsets.all(AppSpacing.sm + 4),
        borderRadius: 18,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _EateryThumbnail(eatery: eatery, fill: true),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: _EateryMeta(eatery: eatery, compact: true, showDealBadge: showDealBadge),
            ),
          ],
        ),
      ),
    );
  }
}

class _EateryThumbnail extends StatelessWidget {
  const _EateryThumbnail({
    required this.eatery,
    this.size = 56,
    this.fill = false,
  });

  final Eatery eatery;
  final double size;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final image = eateryHasNetworkCover(eatery)
        ? CachedNetworkImage(
            imageUrl: eatery.coverPhotoUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) => _PlaceholderThumb(asset: eateryCoverAsset(eatery)),
            errorWidget: (_, __, ___) => _PlaceholderThumb(asset: eateryCoverAsset(eatery)),
          )
        : _PlaceholderThumb(asset: eateryCoverAsset(eatery));

    if (fill) return SizedBox.expand(child: image);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(width: size, height: size, child: image),
    );
  }
}

class _PlaceholderThumb extends StatelessWidget {
  const _PlaceholderThumb({this.asset});

  final String? asset;

  @override
  Widget build(BuildContext context) {
    if (asset != null) {
      return Image.asset(asset!, fit: BoxFit.cover);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.coffeeBrown.withValues(alpha: 0.12),
            AppColors.darkGreen.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.restaurant_rounded, color: AppColors.coffeeBrown, size: 22),
      ),
    );
  }
}

class _EateryMeta extends StatelessWidget {
  const _EateryMeta({required this.eatery, required this.compact, this.showDealBadge = false});

  final Eatery eatery;
  final bool compact;
  final bool showDealBadge;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (eatery.areaName != null) eatery.areaName,
      ...eatery.venueTypes.take(compact ? 1 : 2),
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (showDealBadge) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.darkGreen.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'My deal',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.darkGreen, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (eatery.areaName != null && !compact) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.rust.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              eatery.areaName!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.rust,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          eatery.name,
          maxLines: compact ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: compact
              ? Theme.of(context).textTheme.titleSmall
              : Theme.of(context).textTheme.titleMedium,
        ),
        if (compact && subtitle.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ] else if (!compact && subtitle.isNotEmpty && eatery.areaName == null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ] else if (!compact && eatery.venueTypes.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            eatery.venueTypes.take(2).join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
        if (eatery.badges.isNotEmpty) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.coffeeBrown.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              eatery.badges.first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.coffeeBrown,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
        if (compact) const Spacer(),
        Row(
          children: [
            if (hasDisplayRating(eatery)) ...[
              const Icon(Icons.star_rounded, color: AppColors.rust, size: 14),
              const SizedBox(width: 2),
              Text(
                displayRating(eatery).toStringAsFixed(1),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.inkBrown, fontWeight: FontWeight.w600),
              ),
            ],
            if (eatery.visitCount > 0) ...[
              if (hasDisplayRating(eatery)) const SizedBox(width: 6),
              Text(
                '(${eatery.visitCount})',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
        if (mustTryItem(eatery) case final mt?) ...[
          const SizedBox(height: 3),
          Text(
            mt.price > 0 ? '${mt.name} · ${formatRs(mt.price)}' : mt.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.inkBrown, fontWeight: FontWeight.w700),
          ),
        ],
      ],
    );
  }
}

class EateryCardSkeleton extends StatelessWidget {
  const EateryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
      child: GlassSurface(
        child: Row(
          children: [
            const ShimmerBox(width: 56, height: 56, borderRadius: 14),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: double.infinity, height: 16, borderRadius: 6),
                  SizedBox(height: 8),
                  ShimmerBox(width: 140, height: 12, borderRadius: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
