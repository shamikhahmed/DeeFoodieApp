import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/map_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/eatery_profile_screen.dart';
import '../screens/visit_detail_screen.dart';
import '../screens/add_visit_screen.dart';
import '../screens/areas_screen.dart';
import '../screens/area_detail_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/dishes_screen.dart';
import '../screens/food_passport_screen.dart';
import '../screens/trails_screen.dart';
import '../screens/year_in_food_screen.dart';
import '../screens/seasonal_screen.dart';
import '../screens/edit_visit_screen.dart';
import '../screens/add_eatery_screen.dart';
import '../screens/collections_screen.dart';
import '../screens/the_order_screen.dart';
import '../screens/miss_it_screen.dart';
import '../screens/karachi_dictionary_screen.dart';
import '../screens/my_cards_screen.dart';
import '../screens/taste_profile_screen.dart';
import '../widgets/glass_nav_bar.dart';
import '../l10n/app_localizations.dart';
import '../utils/web_path.dart';
import '../theme/app_theme.dart';

/// Live onboarding gate — redirect reads this, not a frozen bool at router create.
final onboardingDoneListenable = ValueNotifier<bool>(false);

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorExplore = GlobalKey<NavigatorState>(debugLabel: 'explore');
final _shellNavigatorMap = GlobalKey<NavigatorState>(debugLabel: 'map');
final _shellNavigatorJournal = GlobalKey<NavigatorState>(debugLabel: 'journal');
final _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'profile');

String _bootLocation() {
  if (!onboardingDoneListenable.value) return '/onboarding';
  return '/';
}

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: onboardingDoneListenable,
    initialLocation: _bootLocation(),
    redirect: (context, state) {
      final path = normalizeAppPath(state.uri.path);

      if (!onboardingDoneListenable.value && path != '/onboarding') {
        return '/onboarding';
      }
      if (onboardingDoneListenable.value && path == '/onboarding') {
        return '/';
      }
      if (state.uri.path != path) {
        return path;
      }
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.inkBrown),
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(onboardingDoneListenable.value ? '/' : '/onboarding'),
                child: Text(onboardingDoneListenable.value ? 'Go home' : 'Onboarding'),
              ),
            ],
          ),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/eatery/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => EateryProfileScreen(eateryId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/visit/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => VisitDetailScreen(visitId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/add-visit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) {
          final eateryId = state.uri.queryParameters['eateryId'];
          return AddVisitScreen(preselectedEateryId: eateryId);
        },
      ),
      GoRoute(
        path: '/areas',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AreasScreen(),
      ),
      GoRoute(
        path: '/area/:name',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => AreaDetailScreen(areaName: Uri.decodeComponent(state.pathParameters['name']!)),
      ),
      GoRoute(
        path: '/favorites',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/dishes',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const DishesScreen(),
      ),
      GoRoute(
        path: '/passport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const FoodPassportScreen(),
      ),
      GoRoute(
        path: '/trails',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const TrailsScreen(),
      ),
      GoRoute(
        path: '/wrapped',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const YearInFoodScreen(),
      ),
      GoRoute(
        path: '/edit-visit/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => EditVisitScreen(visitId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/add-eatery',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const AddEateryScreen(),
      ),
      GoRoute(
        path: '/collections',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const CollectionsScreen(),
      ),
      GoRoute(
        path: '/collections/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => CollectionDetailScreen(collectionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/order',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const TheOrderScreen(),
      ),
      GoRoute(
        path: '/miss-it',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const MissItScreen(),
      ),
      GoRoute(
        path: '/dictionary',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const KarachiDictionaryScreen(),
      ),
      GoRoute(
        path: '/my-cards',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const MyCardsScreen(),
      ),
      GoRoute(
        path: '/taste-profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const TasteProfileScreen(),
      ),
      GoRoute(
        path: '/seasonal/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => SeasonalScreen(collectionId: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: [
              GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorExplore,
            routes: [
              GoRoute(path: '/explore', builder: (_, __) => const ExploreScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMap,
            routes: [
              GoRoute(path: '/map', builder: (_, __) => const MapScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorJournal,
            routes: [
              GoRoute(path: '/journal', builder: (_, __) => const JournalScreen()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: [
              GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
            ],
          ),
        ],
      ),
    ],
  );
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBody: false,
      backgroundColor: Colors.transparent,
      body: navigationShell,
      bottomNavigationBar: GlassNavBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: l10n.navExplore,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l10n.navMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.navJournal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}

void goToTab(BuildContext context, int index) {
  final shell = StatefulNavigationShell.maybeOf(context);
  shell?.goBranch(index, initialLocation: index == shell.currentIndex);
}
