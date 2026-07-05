import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_prefs_provider.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../widgets/tab_screen_scaffold.dart';
import '../providers/active_user_provider.dart';
import '../providers/profile_prefs_provider.dart';
import '../utils/haptics.dart';
import '../widgets/glass_surface.dart';
import '../widgets/profile_avatar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _replayOnboarding() async {
    await OnboardingPrefs.reset();
    ref.invalidate(onboardingAnswersProvider);
    onboardingDoneListenable.value = false;
    if (!mounted) return;
    context.go('/onboarding');
  }

  Future<void> _refreshApiStatus() async {
    ref.invalidate(apiOnlineProvider);
    await ref.read(apiOnlineProvider.future);
  }

  void _showAvatarSheet() {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.read(userProfileProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.photo_on_rectangle),
                title: Text(l10n.profilePhotoPick),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref.read(userProfileProvider.notifier).pickPhoto();
                },
              ),
              if (profile.photoUrl != null)
                ListTile(
                  leading: const Icon(CupertinoIcons.trash, color: AppColors.rust),
                  title: Text(l10n.profilePhotoRemove, style: const TextStyle(color: AppColors.rust)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref.read(userProfileProvider.notifier).removePhoto();
                  },
                ),
            ],
          ),
        ),
      ),
    );
    AppHaptics.light();
  }

  Future<void> _editDisplayName() async {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.read(userProfileProvider);
    final controller = TextEditingController(text: profile.displayName);

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileNameEdit),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: l10n.profileNameHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(l10n.save)),
        ],
      ),
    );
    controller.dispose();
    if (name != null) {
      await ref.read(userProfileProvider.notifier).setDisplayName(name);
      AppHaptics.selection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eateriesAsync = ref.watch(allEateriesProvider);
    final visitsAsync = ref.watch(visitsProvider);
    final areasAsync = ref.watch(areasProvider);
    final apiOnline = ref.watch(apiOnlineProvider).asData?.value ?? false;
    final activeUser = ref.watch(activeUserProvider);
    final locale = ref.watch(localeProvider);
    final profile = ref.watch(userProfileProvider);

    final visitCount = visitsAsync.maybeWhen(data: (v) => v.length, orElse: () => 0);
    final eateryCount = eateriesAsync.maybeWhen(data: (e) => e.length, orElse: () => 0);
    final score = visitsAsync.maybeWhen(
      data: (visits) => eateriesAsync.maybeWhen(
        data: (eateries) => areasAsync.maybeWhen(
          data: (areas) => computeKarachiScorePct(visits, eateries, areas.length),
          orElse: () => 0,
        ),
        orElse: () => 0,
      ),
      orElse: () => 0,
    );

    return TabScreenScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.lg,
            AppSpacing.screenPadding,
            120,
          ),
          children: [
            GlassSurface(
              child: Row(
                children: [
                  ProfileAvatar(
                    photoUrl: profile.photoUrl,
                    radius: 36,
                    showEditBadge: true,
                    onTap: _showAvatarSheet,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _editDisplayName,
                          child: Text(profile.displayName, style: Theme.of(context).textTheme.titleLarge),
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.profileMemberSince, style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 2),
                        Text(l10n.profilePhotoHint, style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: _StatTile(label: l10n.profileVisits, value: '$visitCount')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _StatTile(label: l10n.profileEateries, value: '$eateryCount')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _StatTile(label: l10n.profileScore, value: '$score%')),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Text(l10n.profileArchive, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            GlassSurface(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: CupertinoIcons.map_pin_ellipse,
                    title: l10n.homeLinkAreas,
                    value: '',
                    onTap: () => context.push('/areas'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.heart,
                    title: l10n.homeLinkFavorites,
                    value: '',
                    onTap: () => context.push('/favorites'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.bookmark,
                    title: l10n.homeLinkWishlist,
                    value: '',
                    onTap: () => context.push('/wishlist'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.search,
                    title: l10n.homeLinkDishes,
                    value: '',
                    onTap: () => context.push('/dishes'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.checkmark_seal,
                    title: l10n.passportTitle,
                    value: '$score%',
                    onTap: () => context.push('/passport'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.flag,
                    title: l10n.trailsTitle,
                    value: '',
                    onTap: () => context.push('/trails'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.gift,
                    title: l10n.homeLinkWrapped,
                    value: '',
                    onTap: () => context.push('/wrapped'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.moon_stars,
                    title: l10n.homeLinkSeasonal,
                    value: '',
                    onTap: () => context.push('/seasonal/ramadan-iftar'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.rectangle_stack,
                    title: l10n.collectionsTitle,
                    value: '',
                    onTap: () => context.push('/collections'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.cart,
                    title: l10n.homeLinkOrder,
                    value: '',
                    onTap: () => context.push('/order'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.heart_slash,
                    title: l10n.homeLinkMissIt,
                    value: '',
                    onTap: () => context.push('/miss-it'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.book,
                    title: l10n.homeLinkDictionary,
                    value: '',
                    onTap: () => context.push('/dictionary'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.plus_rectangle,
                    title: l10n.homeLinkAddEatery,
                    value: '',
                    onTap: () => context.push('/add-eatery'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.creditcard,
                    title: l10n.myCardsTitle,
                    value: '',
                    onTap: () => context.push('/my-cards'),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.heart_circle,
                    title: l10n.tasteProfileTitle,
                    value: '',
                    onTap: () => context.push('/taste-profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Text(l10n.profileSettings, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            GlassSurface(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsRow(
                    icon: CupertinoIcons.person_2,
                    title: 'Archive user',
                    value: activeUser == ActiveArchiveUser.you ? 'You' : 'Friend',
                    onTap: () {
                      ref.read(activeUserProvider.notifier).toggle();
                      AppHaptics.selection();
                    },
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.globe,
                    title: l10n.profileLanguage,
                    value: locale?.languageCode == 'ur' ? 'Roman Urdu' : 'English',
                    onTap: () => ref.read(localeProvider.notifier).toggleEnUr(),
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.wifi,
                    title: 'API',
                    value: apiOnline ? l10n.apiConnected : l10n.apiOffline,
                    onTap: _refreshApiStatus,
                  ),
                  Divider(height: 1, indent: 52, color: AppColors.inkBrown.withValues(alpha: 0.08)),
                  _SettingsRow(
                    icon: CupertinoIcons.arrow_counterclockwise,
                    title: l10n.onboardingTitle,
                    value: '',
                    onTap: _replayOnboarding,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
        child: Row(
          children: [
            Icon(icon, color: AppColors.coffeeBrown, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyLarge)),
            if (value.isNotEmpty)
              Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(width: 4),
            Icon(CupertinoIcons.chevron_right, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
