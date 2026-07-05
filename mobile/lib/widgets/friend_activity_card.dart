import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../api/providers.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_prefs_provider.dart';
import '../widgets/friend_activity_card.dart';
import '../widgets/glass_surface.dart';
import '../widgets/profile_avatar.dart';

/// Pair archive — friend's latest visit with avatar.
class FriendActivityCard extends ConsumerWidget {
  const FriendActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visits = ref.watch(visitsProvider);
    final friend = ref.watch(friendProfileProvider);
    final me = ref.watch(userProfileProvider);

    return visits.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        final friendVisits = list.where((v) => v.userName != me.displayName && v.userName != 'You').toList();
        if (friendVisits.isEmpty) return const SizedBox.shrink();

        friendVisits.sort((a, b) => b.date.compareTo(a.date));
        final latest = friendVisits.first;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/visit/${latest.id}'),
              child: GlassSurface(
                borderRadius: 16,
                child: ListTile(
                  leading: ProfileAvatar(photoUrl: friend.photoUrl, radius: 22),
                  title: Text(l10n.friendActivityTitle),
                  subtitle: Text('${friend.displayName} · ${latest.eateryName}'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
