import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_prefs_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

import 'providers/sync_queue_provider.dart';

class SyncBootstrap extends ConsumerStatefulWidget {
  const SyncBootstrap({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<SyncBootstrap> createState() => _SyncBootstrapState();
}

class _SyncBootstrapState extends ConsumerState<SyncBootstrap> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(syncQueueProvider.notifier).processQueue());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class DeeFoodieApp extends ConsumerStatefulWidget {
  const DeeFoodieApp({super.key});

  @override
  ConsumerState<DeeFoodieApp> createState() => _DeeFoodieAppState();
}

class _DeeFoodieAppState extends ConsumerState<DeeFoodieApp> {
  GoRouter? _router;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    onboardingDoneListenable.value = await OnboardingPrefs.isCompleted();
    setState(() {
      _router = createRouter();
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _router == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final locale = ref.watch(localeProvider);

    return SyncBootstrap(
      child: MaterialApp.router(
        key: ValueKey(locale?.languageCode ?? 'system'),
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        darkTheme: buildDarkAppTheme(),
        themeMode: ThemeMode.light,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const ProviderScope(child: DeeFoodieApp()));
}
