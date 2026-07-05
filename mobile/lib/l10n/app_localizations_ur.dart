// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'DeeFoodieApp';

  @override
  String get navHome => 'Ghar';

  @override
  String get navExplore => 'Talash';

  @override
  String get navMap => 'Naksha';

  @override
  String get navJournal => 'Journal';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeGreeting => 'Aap ka Karachi archive';

  @override
  String get homeKarachiScore => 'Karachi Score';

  @override
  String get homeRecentVisits => 'Haal ke Visits';

  @override
  String get homeContinueJournal => 'Journal Jari Rakhein';

  @override
  String get homeRecentlyAdded => 'Nayi Shamil Jagahein';

  @override
  String get homeRandomRecommendation => 'Karachi ki Ek Tajweez';

  @override
  String get homeTrending => 'Trending Jagahein';

  @override
  String get homeHighestRated => 'Behtareen Rating';

  @override
  String get homeWishlist => 'Wishlist';

  @override
  String get homeSeeAll => 'Sab dekhein';

  @override
  String get homeWishlistEmpty =>
      'Baad ke liye bachi jagahein yahan dikhein gi.';

  @override
  String get homeArchiveEateries => 'Archive mein';

  @override
  String get homeArchiveVisits => 'Visits';

  @override
  String get homeArchiveAreas => 'Ilaqe';

  @override
  String get homeBrowseAreas => 'Ilaqe se dekhein';

  @override
  String get homeSpotlight => 'Aaj Karachi mein';

  @override
  String homeSpotlightCraving(String craving) {
    return '$craving mood ke liye';
  }

  @override
  String homeCravingTitle(String craving) {
    return '$craving craving?';
  }

  @override
  String get homeCravingSubtitle => 'Archive mein yeh dish wali jagahein';

  @override
  String get homeCravingCta => 'Sab dekhein';

  @override
  String get homeMoodStrip => 'Wapas jayein';

  @override
  String exploreResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jagahein',
      one: '1 jagah',
    );
    return '$_temp0';
  }

  @override
  String get eateryMenu => 'Menu';

  @override
  String eateryMenuYear(int year) {
    return '$year ke rates';
  }

  @override
  String get searchHint => 'Eateries, ilaqe, dishes talash karein...';

  @override
  String get addVisit => 'Visit Shamil Karein';

  @override
  String get addEatery => 'Eatery Shamil Karein';

  @override
  String get exploreTitle => 'Talash';

  @override
  String get exploreFilters => 'Filters';

  @override
  String get exploreHideFilters => 'Filters chhupayein';

  @override
  String get emptyExplore =>
      'Abhi kuch nahi — Burns Road, Do Darya, ya Clifton try karein.';

  @override
  String get errorExplore => 'Abhi kitchen jawab nahi de rahi.';

  @override
  String get tryAgain => 'Dobara koshish karein';

  @override
  String get mapComingSoonTitle => 'Karachi ka naksha';

  @override
  String get mapComingSoonBody => 'Har jagah ke pins — jald aa rahe hain.';

  @override
  String get journalEmptyTitle => 'Aap ki pehli visit yahan se shuru';

  @override
  String get journalEmptyBody =>
      'Har outing aap ke food journal ka ek safha ban jati hai.';

  @override
  String get journalSubtitle =>
      'Visit dar visit — Burns Road se Do Darya, saal dar saal.';

  @override
  String mapPinCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Karachi map par $count jagahein',
      one: 'Karachi map par 1 jagah',
      zero:
          'Abhi koi pin nahi — seed data ya location wali eateries shamil karein.',
    );
    return '$_temp0';
  }

  @override
  String get profileMemberSince => 'Archive member';

  @override
  String get profileVisits => 'Visits';

  @override
  String get profileAreas => 'Ilaqe';

  @override
  String get profileScore => 'Score';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileLanguage => 'Zaban';

  @override
  String get profileLanguageValue => 'English + Roman Urdu';

  @override
  String get onboardingTitle => 'Khush aamdeed';

  @override
  String get onboardingSkip => 'Chhor dein';

  @override
  String get onboardingNext => 'Aage';

  @override
  String get onboardingStart => 'Archive kholen';

  @override
  String get onboardingWelcomeTitle => 'Aap ka Karachi food journal';

  @override
  String get onboardingWelcomeSubtitle =>
      'Har visit likho. Har plate yaad rakho.';

  @override
  String get onboardingWelcomeKarachi =>
      'Poora Karachi — har ilaqa. Craving chunein; areas baad mein.';

  @override
  String get onboardingCravingTitle => 'Craving kya hai?';

  @override
  String get onboardingCravingSubtitle => 'Is dish ke around spots dikhayenge.';

  @override
  String get onboardingAreaTitle => 'Home base area?';

  @override
  String get onboardingAreaSubtitle =>
      'Jahan sab se zyada khate ho — wahan se start.';

  @override
  String get onboardingQ1 => 'Aap yahan kyun aaye?';

  @override
  String get onboardingQ1Hint => 'Home screen aap ke andaaz ke mutabiq banegi.';

  @override
  String get onboardingQ2 => 'Pasandida ilaqa?';

  @override
  String get onboardingQ2Hint => 'Wahan ki jagahein pehle dikhaein ge.';

  @override
  String get onboardingQ3 => 'Aam tor par kaise khate hain?';

  @override
  String get onboardingQ3Hint => 'Jo mood suit kare woh chunein.';

  @override
  String get galleryTitle => 'Screen Gallery';

  @override
  String get gallerySubtitle =>
      'Kisi phone preview par tap karke seedha us screen par jayein.';

  @override
  String get galleryVisitSample => 'Sample visit';

  @override
  String get galleryMobileHint =>
      'Chhote iPhone frames ab journal notebook look dikhate hain.';

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
  String get galleryOfflineHint => 'Bundled — offline chalta hai';

  @override
  String get galleryCaptureHint => 'PNG shots: npm run gallery:capture';

  @override
  String get galleryFooterNote =>
      'Build ke baad Chrome hard refresh. Book memories API online par sync.';

  @override
  String get eateryNotFound => 'Yeh eatery archive mein nahi mili.';

  @override
  String get eateryVisitsHere => 'Yahan visits';

  @override
  String get eateryNoVisitsYet => 'Abhi koi visit nahi — pehle aap add karein.';

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
    return 'Google pe $rating ★ ($count reviews)';
  }

  @override
  String get visitReview => 'Aap ki review';

  @override
  String eateryVisitCount(int count) {
    return '$count visits logged';
  }

  @override
  String get visitNotFound => 'Visit nahi mili.';

  @override
  String get visitBy => 'By';

  @override
  String get visitMemory => 'Yaad';

  @override
  String get visitFavorite => 'Favorite';

  @override
  String get addVisitEatery => 'Kahan khaye?';

  @override
  String get addVisitRating => 'Overall rating';

  @override
  String get addVisitReviewHint => 'Kaisa tha? Ek do jumle kafi hain.';

  @override
  String get addVisitMood => 'Mood tags';

  @override
  String get addVisitSave => 'Visit save karein';

  @override
  String get addVisitItems => 'Kya khaya?';

  @override
  String get addVisitCustomItem => 'Menu se alag item';

  @override
  String get addVisitDemoSaved =>
      'Locally save — API se sync ke liye connect karein.';

  @override
  String get apiConnected => 'Connected';

  @override
  String get apiOffline => 'Demo mode';

  @override
  String get areasTitle => 'Karachi ke Ilaqe';

  @override
  String areaEateryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jagahein',
      one: '1 jagah',
    );
    return '$_temp0';
  }

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'Pasand ki jagahein yahan aayengi.';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get wishlistEmpty => 'Baad mein try karne ki list yahan.';

  @override
  String get wishlistAdd => 'Wishlist mein save';

  @override
  String get dishesTitle => 'Food Archive';

  @override
  String get dishesSearchHint => 'Karachi bhar dishes talash...';

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
  String get exploreSortArea => 'Ilaqe se';

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
    return '$count visits in journal';
  }

  @override
  String get eateryPopular => 'Popular on the menu';

  @override
  String get homeDiscover => 'Discover';

  @override
  String get homeLinkAreas => 'Tamam ilaqe';

  @override
  String get homeLinkFavorites => 'Favorites';

  @override
  String get homeLinkWishlist => 'Wishlist';

  @override
  String get homeLinkDishes => 'Dish search';

  @override
  String get journalFilterAll => 'Sab';

  @override
  String get visitItems => 'Kya order kiya';

  @override
  String get visitBill => 'Bill';

  @override
  String get profileEateries => 'City archive';

  @override
  String get profileArchive => 'Your archive';

  @override
  String get passportTitle => 'Food Passport';

  @override
  String get passportSubtitle => 'Har ilaqa jahan khaye — stamp lagao';

  @override
  String get passportStamps => 'Area stamps';

  @override
  String passportProgress(int visited, int total) {
    return '$visited / $total ilaqe';
  }

  @override
  String passportVisitCount(int count) {
    return '$count visits';
  }

  @override
  String passportStampVisited(int count) {
    return '$count jagah archive mein';
  }

  @override
  String passportStampLocked(int count) {
    return '$count jagah explore karein';
  }

  @override
  String get trailsTitle => 'Food Trails';

  @override
  String get trailsComplete => 'Complete';

  @override
  String trailsProgress(int visited, int total) {
    return '$visited / $total stops';
  }

  @override
  String get homeLinkPassport => 'Food Passport';

  @override
  String get homeLinkTrails => 'Food Trails';

  @override
  String get visitShare => 'Share karein';

  @override
  String get journalViewBook => 'Book view';

  @override
  String get journalViewTimeline => 'Timeline view';

  @override
  String get yearInFoodTitle => 'Year in Food';

  @override
  String get yearInFoodSubtitle => 'Is saal ki Karachi food story';

  @override
  String get yearInFoodVisits => 'Visits';

  @override
  String get yearInFoodPlaces => 'Jagah';

  @override
  String get yearInFoodSpent => 'Kharcha';

  @override
  String get yearInFoodTopArea => 'Top ilaqa';

  @override
  String get yearInFoodTopDish => 'Zyada order';

  @override
  String get yearInFoodStory => 'Aap ki kahani';

  @override
  String get yearInFoodBestVisit => 'Best visit dekhein';

  @override
  String get seasonalPicks => 'Curated picks';

  @override
  String get seasonalEmpty => 'Abhi match nahi — archive barhao.';

  @override
  String get mapHeatHint =>
      'Lit pin = visit ho chuki. Grey = abhi explore karna hai.';

  @override
  String mapHeatSummary(int visited, int total) {
    return '$visited visited / $total map par';
  }

  @override
  String get friendActivityTitle => 'Friend ki latest visit';

  @override
  String get homeLinkWrapped => 'Year in Food';

  @override
  String get homeLinkSeasonal => 'Ramadan & seasons';

  @override
  String get addVisitPhoto => 'Visit photo';

  @override
  String get addVisitPhotoPick => 'Gallery se photo';

  @override
  String get addVisitPhotoRemove => 'Photo hatao';

  @override
  String get profilePhotoPick => 'Profile photo chunein';

  @override
  String get profilePhotoRemove => 'Profile photo hatao';

  @override
  String get profilePhotoHint => 'Photo change karne tap karein';

  @override
  String get profileNameEdit => 'Naam';

  @override
  String get profileNameHint => 'Archive mein aap ka naam';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get editVisitTitle => 'Edit visit';

  @override
  String get visitDeleteTitle => 'Delete visit?';

  @override
  String get visitDeleteBody => 'Visit hamesha ke liye delete ho jayegi.';

  @override
  String get visitDeleteConfirm => 'Delete';

  @override
  String get visitCompanions => 'Saath';

  @override
  String get visitMemoryHint => 'Memory note';

  @override
  String get customMoodHint => 'Custom mood';

  @override
  String get addEateryTitle => 'Add eatery';

  @override
  String get addEateryName => 'Naam';

  @override
  String get addEateryArea => 'Ilaqa';

  @override
  String get addEateryAddress => 'Address';

  @override
  String get addEateryDescription => 'Description';

  @override
  String get addEaterySave => 'Archive mein add';

  @override
  String get addEaterySaved => 'Add ho gaya';

  @override
  String get addEateryDuplicateTitle => 'Milta julta jagah';

  @override
  String get addEateryDuplicateBody => 'Existing use karein ya phir bhi add?';

  @override
  String get addEateryUseExisting => 'Existing';

  @override
  String get addEateryAddAnyway => 'Add anyway';

  @override
  String get collectionsTitle => 'Collections';

  @override
  String get collectionsEmpty => 'Abhi koi list nahi';

  @override
  String get collectionsNew => 'Nayi list';

  @override
  String get collectionsNameHint => 'List ka naam';

  @override
  String get collectionsNoPlaces => 'Abhi koi jagah nahi';

  @override
  String get collectionsAddFromExplore => 'Eateries tick karein';

  @override
  String get theOrderTitle => 'The Order';

  @override
  String get theOrderEmpty => 'Items ke sath visits log karein';

  @override
  String theOrderCount(int count) {
    return '$count×';
  }

  @override
  String get missItTitle => 'Restaurants We Miss';

  @override
  String get missItSubtitle => 'Band jagah — archive safe';

  @override
  String get missItEmpty => 'Abhi koi closed nahi';

  @override
  String get dictionaryTitle => 'Karachi Dictionary';

  @override
  String get nearbyTitle => 'If you\'re here…';

  @override
  String get nearbySubtitle => 'Paas ke spots';

  @override
  String get pioneerBadge => 'Aap ne pehle log kiya';

  @override
  String compareVisitsHint(int count) {
    return '$count visits compare';
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
  String get friendNameEdit => 'Friend ka naam';

  @override
  String get myCardsTitle => 'Meray cards & deals';

  @override
  String get myCardsSubtitle =>
      'Banks/wallets/programs chunein — matching discounts eatery par dikhengi.';

  @override
  String get myCardsAggregators => 'Deal apps';

  @override
  String get myCardsBanks => 'Bank cards';

  @override
  String get myCardsWallets => 'Wallets';

  @override
  String get myCardsLoyalty => 'Loyalty';

  @override
  String get myCardsPartnerNote => 'Partner apps';

  @override
  String get myCardsNoPublicApi =>
      'Golootlo/Peekaboo ki free public API nahi — curated deals + link out.';

  @override
  String get tasteProfileTitle => 'Taste profile';

  @override
  String get tasteGender => 'Gender';

  @override
  String get tasteSpice => 'Spice level';

  @override
  String get tasteSweets => 'Meetha';

  @override
  String get tasteBudget => 'Budget';

  @override
  String get tasteCuisines => 'Favorite cuisines';

  @override
  String get tasteAvoids => 'Avoid';

  @override
  String get discountsTitle => 'Yahan aap ki discounts';

  @override
  String get discountsVerifyHint =>
      'Checkout par verify karein — live bank feed nahi.';

  @override
  String get exploreMyDeals => 'Meri discounts';

  @override
  String get onboardingTasteTitle => 'Aap ka taste?';

  @override
  String get onboardingTasteSubtitle => 'Craving picks ke liye.';

  @override
  String get onboardingGenderTitle => 'About you';

  @override
  String get onboardingGenderSubtitle => 'Optional — skip OK.';

  @override
  String get onboardingCuisinesTitle => 'Favorite cuisines';

  @override
  String get onboardingCuisinesSubtitle => 'Kam az kam ek.';

  @override
  String get onboardingCardsTitle => 'Cards & deal apps';

  @override
  String get onboardingCardsSubtitle => 'Golootlo, Peekaboo, bank cards.';

  @override
  String get journalExportPdf => 'Journal PDF';

  @override
  String get visitVoiceAdd => 'Voice note';

  @override
  String get visitVoiceAttached => 'Voice attached';

  @override
  String get visitVoiceRemove => 'Voice hatao';

  @override
  String get trailCertificateTitle => 'Trail complete';

  @override
  String trailCertificateAwarded(String userName) {
    return '$userName ko';
  }

  @override
  String get trailCertificateFooter => 'DeeFoodieApp';

  @override
  String get trailCertificateShare => 'Certificate share';

  @override
  String get trailCertificateCopied => 'Copied';
}
