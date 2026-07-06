import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/sync_queue_store.dart';
import '../l10n/app_localizations.dart';
import '../providers/sync_queue_provider.dart';
import '../theme/app_theme.dart';
import 'glass_surface.dart';

final syncQueuePendingProvider = FutureProvider<int>((ref) async {
  ref.watch(syncQueueProvider);
  return (await SyncQueueStore.load()).length;
});

class SyncQueueBanner extends ConsumerWidget {
  const SyncQueueBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(syncQueuePendingProvider);
    return pending.when(
      data: (count) {
        if (count == 0) return const SizedBox.shrink();
        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: GlassSurface(
            borderRadius: 12,
            tintOpacity: 0.9,
            child: Row(
              children: [
                const Icon(Icons.cloud_upload_outlined, color: AppColors.coffeeBrown, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.syncQueuePending(count), style: Theme.of(context).textTheme.bodySmall)),
                TextButton(
                  onPressed: () => ref.read(syncQueueProvider.notifier).processQueue(),
                  child: Text(l10n.tryAgain),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
