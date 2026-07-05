import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/food_visuals.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_prefs_provider.dart';
import '../providers/taste_profile_provider.dart';
import '../providers/discount_cards_provider.dart';
import '../constants/discount_programs.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_surface.dart';
import '../widgets/onboarding_photo.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  String _gender = '';
  String _spice = '';
  String _sweets = '';
  String _budget = '';
  final _cuisinesSelected = <String>{};
  final _cardPrograms = <String>{};

  static const _pageCount = 5;
  static const _genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
  static const _spiceLevels = ['Mild', 'Medium', 'Spicy', 'Extra spicy'];
  static const _sweetsPrefs = ['Love sweets', 'Sometimes', 'Rarely', 'Never'];
  static const _budgets = ['Budget', 'Mid-range', 'Splurge', 'No limit'];
  static const _cuisineOptions = ['Desi', 'Chinese', 'BBQ', 'Biryani', 'Continental', 'Dessert', 'Street Food', 'Seafood'];
  static const _popularCards = ['golootlo', 'peekaboo', 'hbl_debit', 'hbl_credit', 'meezan_debit', 'ubl_debit', 'paypak', 'jazzcash'];

  Future<void> _finish() async {
    HapticFeedback.mediumImpact();
    await OnboardingPrefs.save(
      intent: 'archive',
      favoriteArea: '',
      mood: '',
      craving: '',
    );
    await ref.read(tasteProfileProvider.notifier).save(TasteProfile(
          gender: _gender,
          spiceLevel: _spice,
          sweetsPreference: _sweets,
          favoriteCuisines: _cuisinesSelected.toList(),
          budgetRange: _budget,
        ));
    await ref.read(discountCardsProvider.notifier).setAll(_cardPrograms);
    ref.invalidate(onboardingAnswersProvider);
    if (mounted) context.go('/');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    switch (_page) {
      case 0:
        return true;
      case 1:
        return _spice.isNotEmpty && _sweets.isNotEmpty;
      case 2:
        return true;
      case 3:
        return _cuisinesSelected.isNotEmpty;
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _next() {
    if (_page < _pageCount - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        variant: AppBackgroundVariant.home,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Text(l10n.appName, style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    if (_page == 0) TextButton(onPressed: _finish, child: Text(l10n.onboardingSkip)),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (p) => setState(() => _page = p),
                  children: [
                    _WelcomePage(
                      title: l10n.onboardingWelcomeTitle,
                      subtitle: l10n.onboardingWelcomeKarachi,
                      languageLabel: l10n.profileLanguage,
                      isUrdu: locale?.languageCode == 'ur',
                      onLanguageTap: () => ref.read(localeProvider.notifier).toggleEnUr(),
                    ),
                    _ChipOnboardPage(
                      title: l10n.onboardingTasteTitle,
                      subtitle: l10n.onboardingTasteSubtitle,
                      sections: [
                        _ChipSection(l10n.tasteSpice, _spiceLevels, _spice, (v) => setState(() => _spice = v)),
                        _ChipSection(l10n.tasteSweets, _sweetsPrefs, _sweets, (v) => setState(() => _sweets = v)),
                        _ChipSection(l10n.tasteBudget, _budgets, _budget, (v) => setState(() => _budget = v)),
                      ],
                    ),
                    _ChipOnboardPage(
                      title: l10n.onboardingGenderTitle,
                      subtitle: l10n.onboardingGenderSubtitle,
                      sections: [
                        _ChipSection(l10n.tasteGender, _genders, _gender, (v) => setState(() => _gender = v)),
                      ],
                    ),
                    _MultiChipOnboardPage(
                      title: l10n.onboardingCuisinesTitle,
                      subtitle: l10n.onboardingCuisinesSubtitle,
                      options: _cuisineOptions,
                      selected: _cuisinesSelected,
                      onToggle: (v) => setState(() => _cuisinesSelected.contains(v) ? _cuisinesSelected.remove(v) : _cuisinesSelected.add(v)),
                    ),
                    _MultiChipOnboardPage(
                      title: l10n.onboardingCardsTitle,
                      subtitle: l10n.onboardingCardsSubtitle,
                      options: _popularCards.map((id) => programById(id)?.name ?? id).toList(),
                      selected: _cardPrograms.map((id) => programById(id)?.name ?? id).toSet(),
                      onToggle: (label) {
                        final id = _popularCards.firstWhere(
                          (i) => (programById(i)?.name ?? i) == label,
                          orElse: () => '',
                        );
                        if (id.isEmpty) return;
                        setState(() => _cardPrograms.contains(id) ? _cardPrograms.remove(id) : _cardPrograms.add(id));
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: List.generate(_pageCount, (i) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < _pageCount - 1 ? 6 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _page ? AppColors.coffeeBrown : AppColors.coffeeBrown.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: PrimaryButton(
                  label: _page == _pageCount - 1 ? l10n.onboardingStart : l10n.onboardingNext,
                  onPressed: _canContinue ? _next : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipSection {
  const _ChipSection(this.title, this.options, this.selected, this.onSelect);
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
}

class _ChipOnboardPage extends StatelessWidget {
  const _ChipOnboardPage({required this.title, required this.subtitle, required this.sections});
  final String title;
  final String subtitle;
  final List<_ChipSection> sections;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          ...sections.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: GlassSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title, style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: s.options.map((o) => ChoiceChip(
                              label: Text(o),
                              selected: s.selected == o,
                              onSelected: (_) {
                                HapticFeedback.selectionClick();
                                s.onSelect(o);
                              },
                            )).toList(),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _MultiChipOnboardPage extends StatelessWidget {
  const _MultiChipOnboardPage({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final String title;
  final String subtitle;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          GlassSurface(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((o) => FilterChip(
                    label: Text(o),
                    selected: selected.contains(o),
                    onSelected: (_) {
                      HapticFeedback.selectionClick();
                      onToggle(o);
                    },
                  )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({
    required this.title,
    required this.subtitle,
    required this.languageLabel,
    required this.isUrdu,
    required this.onLanguageTap,
  });

  final String title;
  final String subtitle;
  final String languageLabel;
  final bool isUrdu;
  final VoidCallback onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 260,
              child: OnboardingPhoto(url: onboardingHeroPhoto, height: 108, borderRadius: 18),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
          const SizedBox(height: AppSpacing.lg),
          GlassSurface(
            child: Row(
              children: [
                const Icon(CupertinoIcons.globe, color: AppColors.coffeeBrown),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(languageLabel, style: Theme.of(context).textTheme.bodyLarge)),
                _LanguagePill(label: isUrdu ? 'Roman Urdu' : 'English', onTap: onLanguageTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  const _LanguagePill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.coffeeBrown.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
    );
  }
}
