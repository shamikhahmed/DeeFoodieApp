import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/onboarding_options.dart';
import '../utils/onboarding_labels.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_prefs_provider.dart';
import '../providers/taste_profile_provider.dart';
import '../providers/discount_cards_provider.dart';
import '../constants/discount_programs.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_surface.dart';
import '../widgets/primary_button.dart';
import '../widgets/karachi_background_image.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  String _intent = '';
  String _area = '';
  String _craving = '';
  String _mood = '';
  String _gender = '';
  String _spice = '';
  String _sweets = '';
  String _budget = '';
  final _cuisinesSelected = <String>{};
  final _chainsSelected = <String>{};
  final _cardPrograms = <String>{};

  static const _pageCount = 7;
  static const _genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
  static const _spiceLevels = ['Mild', 'Medium', 'Spicy', 'Extra spicy'];
  static const _sweetsPrefs = ['Love sweets', 'Sometimes', 'Rarely', 'Never'];
  static const _budgets = ['Budget', 'Mid-range', 'Splurge', 'No limit'];
  static const _popularCards = [
    'golootlo',
    'peekaboo',
    'hbl_debit',
    'hbl_credit',
    'meezan_debit',
    'ubl_debit',
    'paypak',
    'jazzcash',
  ];

  bool _finishing = false;

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    try {
      HapticFeedback.mediumImpact();
      await OnboardingPrefs.save(
        intent: _intent,
        favoriteArea: _area,
        mood: _mood,
        craving: _craving,
      );
      await ref.read(tasteProfileProvider.notifier).save(TasteProfile(
            gender: _gender,
            spiceLevel: _spice,
            sweetsPreference: _sweets,
            favoriteCuisines: _cuisinesSelected.toList(),
            budgetRange: _budget,
            favoriteChains: _chainsSelected.toList(),
          ));
      await ref.read(discountCardsProvider.notifier).setAll(_cardPrograms);
      ref.invalidate(onboardingAnswersProvider);
      onboardingDoneListenable.value = true;
      if (mounted) context.go('/');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save — check storage and try again')),
        );
      }
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
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
        return _intent.isNotEmpty && _area.isNotEmpty;
      case 2:
        return _craving.isNotEmpty;
      case 3:
        return _spice.isNotEmpty && _sweets.isNotEmpty;
      case 4:
        return _cuisinesSelected.isNotEmpty;
      case 5:
        return true;
      case 6:
        return true;
      default:
        return false;
    }
  }

  String? _blockHint(AppLocalizations l10n) {
    if (_canContinue) return null;
    return switch (_page) {
      1 => _intent.isEmpty ? l10n.onboardingQ1Hint : l10n.onboardingQ2Hint,
      2 => l10n.onboardingCravingSubtitle,
      3 => l10n.onboardingTasteSubtitle,
      4 => l10n.onboardingCuisinesSubtitle,
      _ => null,
    };
  }

  Future<void> _next() async {
    if (!_canContinue) return;
    if (_page < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      await _finish();
    }
  }

  void _back() {
    if (_page == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final blockHint = _blockHint(l10n);

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
                    if (_page > 0)
                      IconButton(
                        onPressed: _back,
                        icon: const Icon(CupertinoIcons.chevron_back, color: AppColors.coffeeBrown),
                        tooltip: l10n.onboardingNext,
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: Text(
                        l10n.appName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.inkBrown,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: _page == 0
                          ? TextButton(
                              onPressed: _finish,
                              child: Text(l10n.onboardingSkip),
                            )
                          : null,
                    ),
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
                      title: l10n.onboardingQ1,
                      subtitle: l10n.onboardingQ1Hint,
                      sections: [
                        _ChipSection(l10n.onboardingQ1, onboardingIntentOptions, _intent, (v) => setState(() => _intent = v)),
                        _ChipSection(l10n.onboardingQ2, onboardingPopularAreas, _area, (v) => setState(() => _area = v)),
                      ],
                    ),
                    _ChipOnboardPage(
                      title: l10n.onboardingCravingTitle,
                      subtitle: l10n.onboardingCravingSubtitle,
                      sections: [
                        _ChipSection(l10n.onboardingPickOne, onboardingCravingOptions, _craving, (v) => setState(() => _craving = v)),
                        _ChipSection('${l10n.onboardingQ3} (optional)', onboardingMoodOptions, _mood, (v) => setState(() => _mood = v)),
                      ],
                    ),
                    _ChipOnboardPage(
                      title: l10n.onboardingTasteTitle,
                      subtitle: l10n.onboardingTasteSubtitle,
                      sections: [
                        _ChipSection(l10n.tasteSpice, _spiceLevels, _spice, (v) => setState(() => _spice = v)),
                        _ChipSection(l10n.tasteSweets, _sweetsPrefs, _sweets, (v) => setState(() => _sweets = v)),
                        _ChipSection('${l10n.tasteBudget} (optional)', _budgets, _budget, (v) => setState(() => _budget = v)),
                      ],
                    ),
                    _ChipOnboardPage(
                      title: l10n.onboardingCuisinesTitle,
                      subtitle: l10n.onboardingCuisinesSubtitle,
                      sections: [
                        _MultiChipSection(
                          l10n.tasteCuisines,
                          onboardingCuisineOptions,
                          _cuisinesSelected,
                          (v) => setState(() => _cuisinesSelected.contains(v) ? _cuisinesSelected.remove(v) : _cuisinesSelected.add(v)),
                        ),
                        _ChipSection('${l10n.tasteGender} (optional)', _genders, _gender, (v) => setState(() => _gender = v)),
                      ],
                    ),
                    _MultiChipOnboardPage(
                      title: l10n.onboardingChainsTitle,
                      subtitle: l10n.onboardingChainsSubtitle,
                      options: onboardingChainOptions,
                      selected: _chainsSelected,
                      onToggle: (v) => setState(() => _chainsSelected.contains(v) ? _chainsSelected.remove(v) : _chainsSelected.add(v)),
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
              if (blockHint != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                  child: Text(
                    blockHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.coffeeBrown),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: PrimaryButton(
                  label: _finishing
                      ? '...'
                      : (_page == _pageCount - 1 ? l10n.onboardingStart : l10n.onboardingNext),
                  onPressed: (_canContinue && !_finishing) ? _next : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle? _onboardTitleStyle(BuildContext context) =>
    Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.inkBrown, fontWeight: FontWeight.w700);

TextStyle? _onboardBodyStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.inkBrown.withValues(alpha: 0.88));

TextStyle? _onboardSectionStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.inkBrown, fontWeight: FontWeight.w600);

class _ChipSection {
  const _ChipSection(this.title, this.options, this.selected, this.onSelect);
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;
}

class _MultiChipSection {
  const _MultiChipSection(this.title, this.options, this.selected, this.onToggle);
  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
}

class _ChipOnboardPage extends StatelessWidget {
  const _ChipOnboardPage({
    required this.title,
    required this.subtitle,
    required this.sections,
  });

  final String title;
  final String subtitle;
  final List<Object> sections;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _onboardTitleStyle(context)),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: _onboardBodyStyle(context)),
          const SizedBox(height: AppSpacing.lg),
          ...sections.map((s) {
            if (s is _ChipSection) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: GlassSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title, style: _onboardSectionStyle(context)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: s.options.map((o) => ChoiceChip(
                              label: Text(onboardingChipLabel(context, o)),
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
              );
            }
            final m = s as _MultiChipSection;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: GlassSurface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.title, style: _onboardSectionStyle(context)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: m.options.map((o) => FilterChip(
                            label: Text(onboardingChipLabel(context, o)),
                            selected: m.selected.contains(o),
                            onSelected: (_) {
                              HapticFeedback.selectionClick();
                              m.onToggle(o);
                            },
                          )).toList(),
                    ),
                  ],
                ),
              ),
            );
          }),
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
          Text(title, style: _onboardTitleStyle(context)),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: _onboardBodyStyle(context)),
          const SizedBox(height: AppSpacing.lg),
          GlassSurface(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((o) => FilterChip(
                    label: Text(onboardingChipLabel(context, o)),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: KarachiBackgroundImage(
                assetPath: onboardingHeroAsset,
                width: 260,
                height: 108,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.inkBrown,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inkBrown.withValues(alpha: 0.88),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassSurface(
            child: Row(
              children: [
                const Icon(CupertinoIcons.globe, color: AppColors.coffeeBrown),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    languageLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.inkBrown,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
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
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.coffeeBrown,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
