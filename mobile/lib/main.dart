import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_prefs_provider.dart';
import 'router/app_router.dart';
import 'screens/web_beta_gate_screen.dart';
import 'services/auth_token_store.dart';
import 'services/map_cache_service.dart';
import 'services/map_prefetch_service.dart';
import 'services/web_beta_gate.dart';
import 'theme/app_scroll_behavior.dart';
import 'theme/app_theme.dart';
import 'utils/url_strategy_stub.dart'
    if (dart.library.html) 'utils/url_strategy_web.dart';
import 'utils/app_ready_stub.dart'
    if (dart.library.html) 'utils/app_ready_web.dart';

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
  /// DFD-V3-1: Flutter web stays locked until a beta bearer is present.
  bool _webBetaUnlocked = !kIsWeb;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (kIsWeb) {
      final token = await AuthTokenStore().read();
      _webBetaUnlocked = WebBetaGate.isValidToken(token);
    }
    onboardingDoneListenable.value = await OnboardingPrefs.isCompleted();
    setState(() {
      _router = createRouter();
      _ready = true;
    });
    // C-20: after first ready frame, expose window.__APP_READY__ on web.
    WidgetsBinding.instance.addPostFrameCallback((_) => markAppReady());
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

    if (kIsWeb && !_webBetaUnlocked) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        darkTheme: buildDarkAppTheme(),
        themeMode: ThemeMode.dark,
        home: WebBetaGateScreen(
          onUnlocked: () {
            setState(() => _webBetaUnlocked = true);
            ref.invalidate(authTokenProvider);
          },
        ),
      );
    }

    final locale = ref.watch(localeProvider);

    return SyncBootstrap(
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        darkTheme: buildDarkAppTheme(),
        themeMode: ThemeMode.light,
        scrollBehavior: const AppScrollBehavior(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    configureUrlStrategy();
  } else {
    await MapCacheService.instance.init();
    unawaited(MapPrefetchService.instance.startIfNeeded());
  }
  runApp(const ProviderScope(child: DeeFoodieApp()));
}
