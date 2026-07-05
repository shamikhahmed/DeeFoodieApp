// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DeeFoodieApp';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navMap => 'Map';

  @override
  String get navJournal => 'Journal';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeGreeting => 'Your Karachi archive';

  @override
  String get homeKarachiScore => 'Karachi Score';

  @override
  String get homeRecentVisits => 'Recent Visits';

  @override
  String get homeContinueJournal => 'Continue Journal';

  @override
  String get homeRecentlyAdded => 'Recently Added Places';

  @override
  String get homeRandomRecommendation => 'Random Karachi Recommendation';

  @override
  String get homeTrending => 'Trending Places';

  @override
  String get homeHighestRated => 'Highest Rated Places';

  @override
  String get homeWishlist => 'Wishlist';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeWishlistEmpty =>
      'Places you\'re saving for later will live here.';

  @override
  String get homeArchiveEateries => 'In archive';

  @override
  String get homeArchiveVisits => 'Visits logged';

  @override
  String get homeArchiveAreas => 'Areas';

  @override
  String get homeBrowseAreas => 'Browse by area';

  @override
  String get homeSpotlight => 'Tonight in Karachi';

  @override
  String homeSpotlightCraving(String craving) {
    return 'Picked for your $craving mood';
  }

  @override
  String homeCravingTitle(String craving) {
    return 'Craving $craving?';
  }

  @override
  String get homeCravingSubtitle =>
      'Spots in your archive with this on the menu';

  @override
  String get homeCravingCta => 'See all';

  @override
  String get homeMoodStrip => 'Jump back in';

  @override
  String exploreResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '1 place',
    );
    return '$_temp0';
  }

  @override
  String get eateryMenu => 'Menu';

  @override
  String eateryMenuYear(int year) {
    return 'Prices from $year';
  }

  @override
  String get searchHint => 'Search eateries, areas, dishes...';

  @override
  String get addVisit => 'Add Visit';

  @override
  String get addEatery => 'Add Eatery';

  @override
  String get exploreTitle => 'Explore';

  @override
  String get exploreFilters => 'Filters';

  @override
  String get exploreHideFilters => 'Hide filters';

  @override
  String get emptyExplore =>
      'Nothing here yet — try Burns Road, Do Darya, or Clifton.';

  @override
  String get errorExplore => 'The kitchen\'s not answering right now.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get mapComingSoonTitle => 'Karachi on the map';

  @override
  String get mapComingSoonBody =>
      'Pins for every place in your archive — arriving soon.';

  @override
  String get journalEmptyTitle => 'Your first visit starts here';

  @override
  String get journalEmptyBody =>
      'Every outing becomes a page in your personal food journal.';

  @override
  String get journalSubtitle =>
      'Visit by visit — Burns Road to Do Darya, year by year.';

  @override
  String mapPinCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places on the Karachi map',
      one: '1 place on the Karachi map',
      zero: 'No pins yet — seed data or add eateries with locations.',
    );
    return '$_temp0';
  }

  @override
  String get profileMemberSince => 'Archive member';

  @override
  String get profileVisits => 'Visits';

  @override
  String get profileAreas => 'Areas';

  @override
  String get profileScore => 'Score';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageValue => 'English + Roman Urdu';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Continue';

  @override
  String get onboardingStart => 'Open my archive';

  @override
  String get onboardingWelcomeTitle => 'Your Karachi food journal';

  @override
  String get onboardingWelcomeSubtitle =>
      'Log every visit. Remember every plate. Build the city\'s living archive — one meal at a time.';

  @override
  String get onboardingWelcomeKarachi =>
      'All of Karachi — every area, every plate. Explore neighborhoods from Areas anytime.';

  @override
  String get onboardingCravingTitle => 'What are you craving?';

  @override
  String get onboardingCravingSubtitle =>
      'We\'ll surface spots and dishes around this first.';

  @override
  String get onboardingAreaTitle => 'Your home base in Karachi?';

  @override
  String get onboardingAreaSubtitle =>
      'Pick the area you eat in most — we\'ll start there.';

  @override
  String get onboardingQ1 => 'What brings you here?';

  @override
  String get onboardingQ1Hint =>
      'We\'ll shape your home screen around how you eat Karachi.';

  @override
  String get onboardingQ2 => 'Your favourite area?';

  @override
  String get onboardingQ2Hint =>
      'We\'ll surface places and moods from there first.';

  @override
  String get onboardingQ3 => 'How do you usually eat out?';

  @override
  String get onboardingQ3Hint => 'Pick the mood that fits you most.';

  @override
  String get galleryTitle => 'Screen Gallery';

  @override
  String get gallerySubtitle =>
      'Tap any phone preview to jump straight into that screen.';

  @override
  String get galleryVisitSample => 'Sample visit';

  @override
  String get galleryMobileHint =>
      'Mini iPhone frames show the current journal notebook look.';

  @override
  String get gallerySectionTabs => 'Main tabs';

  @override
  String get gallerySectionTabsHint =>
      'Home · Explore · Map · Journal · Profile';

  @override
  String get gallerySectionJournal => 'Journal & visits';

  @override
  String get gallerySectionJournalHint =>
      'Book flip, timeline, add/edit visit, stickers';

  @override
  String get gallerySectionArchive => 'Archive tools';

  @override
  String get gallerySectionArchiveHint =>
      'Eateries, areas, lists, dishes, collections';

  @override
  String get gallerySectionKarachi => 'Karachi identity';

  @override
  String get gallerySectionKarachiHint =>
      'Passport, trails, wrapped, seasonal, order';

  @override
  String get gallerySectionMore => 'More';

  @override
  String get galleryBookFlipHint => 'Page curl + prev/next + stickers';

  @override
  String get galleryEaterySample => 'Sample eatery profile';

  @override
  String get galleryOfflineHint => 'Bundled — works offline';

  @override
  String get galleryCaptureHint => 'npm run gallery:capture for PNG shots';

  @override
  String get galleryFooterNote =>
      'Hard refresh Chrome after builds. Book memories sync when API online.';

  @override
  String get eateryNotFound => 'Eatery not found in the archive.';

  @override
  String get eateryVisitsHere => 'Visits here';

  @override
  String get eateryNoVisitsYet =>
      'No visits logged here yet — be the first to add one.';

  @override
  String get eateryMustTry => 'Must try';

  @override
  String get eateryDetails => 'Details';

  @override
  String get eateryPhone => 'Phone';

  @override
  String get eateryHours => 'Hours';

  @override
  String get eateryFamousFor => 'Famous for';

  @override
  String get eateryBranches => 'Branches';

  @override
  String get eateryExternalReviews => 'Reviews';

  @override
  String get eateryPromotions => 'Offers & promotions';

  @override
  String get eateryViewReview => 'View review';

  @override
  String get eateryWebsite => 'Website';

  @override
  String get eateryInstagram => 'Instagram';

  @override
  String eateryGoogleRating(double rating, int count) {
    return '$rating ★ on Google ($count reviews)';
  }

  @override
  String get visitReview => 'Your review';

  @override
  String eateryVisitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count visits logged',
      one: '1 visit logged',
    );
    return '$_temp0';
  }

  @override
  String get visitNotFound => 'Visit not found.';

  @override
  String get visitBy => 'By';

  @override
  String get visitMemory => 'Memory';

  @override
  String get visitFavorite => 'Favorite';

  @override
  String get addVisitEatery => 'Where did you eat?';

  @override
  String get addVisitRating => 'Overall rating';

  @override
  String get addVisitReviewHint => 'How was it? A sentence or two is enough.';

  @override
  String get addVisitMood => 'Mood tags';

  @override
  String get addVisitSave => 'Save visit';

  @override
  String get addVisitItems => 'What did you eat?';

  @override
  String get addVisitCustomItem => 'Add something not on the menu';

  @override
  String get addVisitDemoSaved =>
      'Saved locally — connect API to sync with your archive.';

  @override
  String get apiConnected => 'Connected';

  @override
  String get apiOffline => 'Demo mode';

  @override
  String get areasTitle => 'Karachi Areas';

  @override
  String areaEateryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '1 place',
    );
    return '$_temp0';
  }

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'Heart places you love — they\'ll show up here.';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get wishlistEmpty => 'Save spots you want to try next.';

  @override
  String get wishlistAdd => 'Save to wishlist';

  @override
  String get dishesTitle => 'Food Archive';

  @override
  String get dishesSearchHint => 'Search dishes across Karachi...';

  @override
  String dishesResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dishes',
      one: '1 dish',
    );
    return '$_temp0';
  }

  @override
  String get exploreSortRating => 'Top rated';

  @override
  String get exploreSortName => 'A–Z';

  @override
  String get exploreSortArea => 'By area';

  @override
  String get homeDashboardTitle => 'Your food journal';

  @override
  String get homeDashboardPlaces => 'Places visited';

  @override
  String get homeDashboardVisits => 'Total visits';

  @override
  String get homeDashboardSpent => 'Total spent';

  @override
  String get homeDashboardAreas => 'Areas explored';

  @override
  String homeDashboardAvgBill(String amount) {
    return 'Avg bill $amount';
  }

  @override
  String get homeDashboardAvgRating => 'avg rating';

  @override
  String get homeMustTry => 'Must try across Karachi';

  @override
  String get homeLatestReviews => 'Latest reviews';

  @override
  String journalVisitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count visits in journal',
      one: '1 visit in journal',
    );
    return '$_temp0';
  }

  @override
  String get eateryPopular => 'Popular on the menu';

  @override
  String get homeDiscover => 'Discover';

  @override
  String get homeLinkAreas => 'All areas';

  @override
  String get homeLinkFavorites => 'Favorites';

  @override
  String get homeLinkWishlist => 'Wishlist';

  @override
  String get homeLinkDishes => 'Dish search';

  @override
  String get journalFilterAll => 'All';

  @override
  String get visitItems => 'What you ordered';

  @override
  String get visitBill => 'Bill';

  @override
  String get profileEateries => 'City archive';

  @override
  String get profileArchive => 'Your archive';

  @override
  String get passportTitle => 'Food Passport';

  @override
  String get passportSubtitle => 'Stamp every Karachi neighborhood you eat in';

  @override
  String get passportStamps => 'Area stamps';

  @override
  String passportProgress(int visited, int total) {
    return '$visited of $total areas stamped';
  }

  @override
  String passportVisitCount(int count) {
    return '$count visits logged';
  }

  @override
  String passportStampVisited(int count) {
    return '$count places in archive';
  }

  @override
  String passportStampLocked(int count) {
    return '$count places to discover';
  }

  @override
  String get trailsTitle => 'Food Trails';

  @override
  String get trailsComplete => 'Complete';

  @override
  String trailsProgress(int visited, int total) {
    return '$visited of $total stops';
  }

  @override
  String get homeLinkPassport => 'Food Passport';

  @override
  String get homeLinkTrails => 'Food Trails';

  @override
  String get visitShare => 'Share visit';

  @override
  String get journalViewBook => 'Book view';

  @override
  String get journalViewTimeline => 'Timeline view';

  @override
  String get yearInFoodTitle => 'Year in Food';

  @override
  String get yearInFoodSubtitle => 'Your Karachi food story this year';

  @override
  String get yearInFoodVisits => 'Visits logged';

  @override
  String get yearInFoodPlaces => 'Places tried';

  @override
  String get yearInFoodSpent => 'Estimated spend';

  @override
  String get yearInFoodTopArea => 'Top area';

  @override
  String get yearInFoodTopDish => 'Most ordered';

  @override
  String get yearInFoodStory => 'Your story';

  @override
  String get yearInFoodBestVisit => 'Open best visit';

  @override
  String get seasonalPicks => 'Curated picks';

  @override
  String get seasonalEmpty =>
      'No matches yet — add more eateries to the archive.';

  @override
  String get mapHeatHint =>
      'Lit pins = places you\'ve visited. Grey = still to explore.';

  @override
  String mapHeatSummary(int visited, int total) {
    return '$visited visited of $total on map';
  }

  @override
  String get friendActivityTitle => 'Friend\'s latest visit';

  @override
  String get homeLinkWrapped => 'Year in Food';

  @override
  String get homeLinkSeasonal => 'Ramadan & seasons';

  @override
  String get addVisitPhoto => 'Visit photo';

  @override
  String get addVisitPhotoPick => 'Add photo from gallery';

  @override
  String get addVisitPhotoRemove => 'Remove photo';

  @override
  String get profilePhotoPick => 'Choose profile photo';

  @override
  String get profilePhotoRemove => 'Remove profile photo';

  @override
  String get profilePhotoHint => 'Tap photo to change';

  @override
  String get profileNameEdit => 'Display name';

  @override
  String get profileNameHint => 'Your name in the archive';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get editVisitTitle => 'Edit visit';

  @override
  String get visitDeleteTitle => 'Delete visit?';

  @override
  String get visitDeleteBody =>
      'This removes the visit from your journal permanently.';

  @override
  String get visitDeleteConfirm => 'Delete';

  @override
  String get visitCompanions => 'With';

  @override
  String get visitMemoryHint => 'Memory note (optional)';

  @override
  String get customMoodHint => 'Custom mood tag';

  @override
  String get addEateryTitle => 'Add eatery';

  @override
  String get addEateryName => 'Name';

  @override
  String get addEateryArea => 'Area';

  @override
  String get addEateryAddress => 'Address';

  @override
  String get addEateryDescription => 'Description';

  @override
  String get addEaterySave => 'Add to archive';

  @override
  String get addEaterySaved => 'Eatery added to your archive';

  @override
  String get addEateryDuplicateTitle => 'Similar place exists';

  @override
  String get addEateryDuplicateBody => 'Use the existing record or add anyway?';

  @override
  String get addEateryUseExisting => 'Use existing';

  @override
  String get addEateryAddAnyway => 'Add anyway';

  @override
  String get collectionsTitle => 'Collections';

  @override
  String get collectionsEmpty => 'No lists yet — tap + to start one.';

  @override
  String get collectionsNew => 'New collection';

  @override
  String get collectionsNameHint => 'List name';

  @override
  String get collectionsNoPlaces => 'No places yet';

  @override
  String get collectionsAddFromExplore => 'Tick eateries to add to this list';

  @override
  String get theOrderTitle => 'The Order';

  @override
  String get theOrderEmpty => 'Log visits with items to see your breakdown.';

  @override
  String theOrderCount(int count) {
    return '$count×';
  }

  @override
  String get missItTitle => 'Restaurants We Miss';

  @override
  String get missItSubtitle =>
      'Closed places — archive preserved, memory stays.';

  @override
  String get missItEmpty => 'No closed eateries in archive yet.';

  @override
  String get dictionaryTitle => 'Karachi Dictionary';

  @override
  String get nearbyTitle => 'If you\'re here…';

  @override
  String get nearbySubtitle => 'Within a few km';

  @override
  String get pioneerBadge => 'You logged this first';

  @override
  String compareVisitsHint(int count) {
    return '$count visits to compare';
  }

  @override
  String get homeLinkCollections => 'Collections';

  @override
  String get homeLinkOrder => 'The Order';

  @override
  String get homeLinkMissIt => 'Miss It?';

  @override
  String get homeLinkDictionary => 'Dictionary';

  @override
  String get homeLinkAddEatery => 'Add eatery';

  @override
  String get friendProfileTitle => 'Friend profile';

  @override
  String get friendNameEdit => 'Friend\'s name';

  @override
  String get myCardsTitle => 'My cards & deals';

  @override
  String get myCardsSubtitle =>
      'Pick banks, wallets, and programs you use — we highlight matching discounts on eateries.';

  @override
  String get myCardsAggregators => 'Deal apps';

  @override
  String get myCardsBanks => 'Bank cards';

  @override
  String get myCardsWallets => 'Wallets';

  @override
  String get myCardsLoyalty => 'Loyalty programs';

  @override
  String get myCardsPartnerNote => 'Partner apps';

  @override
  String get myCardsNoPublicApi =>
      'Golootlo & Peekaboo have no free public API — we match curated deals and link out. Contact golootlo.pk / FetchSky for partnership feeds.';

  @override
  String get tasteProfileTitle => 'Taste profile';

  @override
  String get tasteGender => 'Gender';

  @override
  String get tasteSpice => 'Spice tolerance';

  @override
  String get tasteSweets => 'Sweets';

  @override
  String get tasteBudget => 'Budget';

  @override
  String get tasteCuisines => 'Favorite cuisines';

  @override
  String get tasteAvoids => 'Usually avoid';

  @override
  String get discountsTitle => 'Your discounts here';

  @override
  String get discountsVerifyHint =>
      'Verify offer at checkout — curated data, not live bank feed.';

  @override
  String get exploreMyDeals => 'My discounts';

  @override
  String get onboardingTasteTitle => 'How do you eat?';

  @override
  String get onboardingTasteSubtitle =>
      'Helps craving picks and future recommendations.';

  @override
  String get onboardingGenderTitle => 'About you';

  @override
  String get onboardingGenderSubtitle => 'Optional — skip by tapping Next.';

  @override
  String get onboardingCuisinesTitle => 'Favorite cuisines';

  @override
  String get onboardingCuisinesSubtitle => 'Pick at least one.';

  @override
  String get onboardingCardsTitle => 'Cards & deal apps';

  @override
  String get onboardingCardsSubtitle =>
      'Golootlo, Peekaboo, bank cards — show where you save.';

  @override
  String get journalExportPdf => 'Export journal PDF';

  @override
  String get visitVoiceAdd => 'Attach voice note';

  @override
  String get visitVoiceAttached => 'Voice note attached';

  @override
  String get visitVoiceRemove => 'Remove voice note';

  @override
  String get trailCertificateTitle => 'Trail completed';

  @override
  String trailCertificateAwarded(String userName) {
    return 'Awarded to $userName';
  }

  @override
  String get trailCertificateFooter => 'DeeFoodieApp — Karachi food archive';

  @override
  String get trailCertificateShare => 'Share certificate';

  @override
  String get trailCertificateCopied => 'Certificate copied — paste to share';
}
