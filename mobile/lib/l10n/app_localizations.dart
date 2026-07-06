import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'DeeFoodieApp'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Your Karachi archive'**
  String get homeGreeting;

  /// No description provided for @homeKarachiScore.
  ///
  /// In en, this message translates to:
  /// **'Karachi Score'**
  String get homeKarachiScore;

  /// No description provided for @homeRecentVisits.
  ///
  /// In en, this message translates to:
  /// **'Recent Visits'**
  String get homeRecentVisits;

  /// No description provided for @homeContinueJournal.
  ///
  /// In en, this message translates to:
  /// **'Continue Journal'**
  String get homeContinueJournal;

  /// No description provided for @homeRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added Places'**
  String get homeRecentlyAdded;

  /// No description provided for @homeRandomRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Random Karachi Recommendation'**
  String get homeRandomRecommendation;

  /// No description provided for @homeTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending Places'**
  String get homeTrending;

  /// No description provided for @homeHighestRated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated Places'**
  String get homeHighestRated;

  /// No description provided for @homeWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get homeWishlist;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeWishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Places you\'re saving for later will live here.'**
  String get homeWishlistEmpty;

  /// No description provided for @homeArchiveEateries.
  ///
  /// In en, this message translates to:
  /// **'In archive'**
  String get homeArchiveEateries;

  /// No description provided for @homeArchiveVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits logged'**
  String get homeArchiveVisits;

  /// No description provided for @homeArchiveAreas.
  ///
  /// In en, this message translates to:
  /// **'Areas'**
  String get homeArchiveAreas;

  /// No description provided for @homeBrowseAreas.
  ///
  /// In en, this message translates to:
  /// **'Browse by area'**
  String get homeBrowseAreas;

  /// No description provided for @homeSpotlight.
  ///
  /// In en, this message translates to:
  /// **'Tonight in Karachi'**
  String get homeSpotlight;

  /// No description provided for @homeSpotlightCraving.
  ///
  /// In en, this message translates to:
  /// **'Picked for your {craving} mood'**
  String homeSpotlightCraving(String craving);

  /// No description provided for @homeCravingTitle.
  ///
  /// In en, this message translates to:
  /// **'Craving {craving}?'**
  String homeCravingTitle(String craving);

  /// No description provided for @homeCravingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spots in your archive with this on the menu'**
  String get homeCravingSubtitle;

  /// No description provided for @homeCravingCta.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeCravingCta;

  /// No description provided for @homeMoodStrip.
  ///
  /// In en, this message translates to:
  /// **'Jump back in'**
  String get homeMoodStrip;

  /// No description provided for @exploreResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place} other{{count} places}}'**
  String exploreResultCount(int count);

  /// No description provided for @eateryMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get eateryMenu;

  /// No description provided for @eateryMenuYear.
  ///
  /// In en, this message translates to:
  /// **'Prices from {year}'**
  String eateryMenuYear(int year);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search eateries, areas, dishes...'**
  String get searchHint;

  /// No description provided for @addVisit.
  ///
  /// In en, this message translates to:
  /// **'Add Visit'**
  String get addVisit;

  /// No description provided for @addEatery.
  ///
  /// In en, this message translates to:
  /// **'Add Eatery'**
  String get addEatery;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTitle;

  /// No description provided for @exploreFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get exploreFilters;

  /// No description provided for @exploreHideFilters.
  ///
  /// In en, this message translates to:
  /// **'Hide filters'**
  String get exploreHideFilters;

  /// No description provided for @emptyExplore.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet — try Burns Road, Do Darya, or Clifton.'**
  String get emptyExplore;

  /// No description provided for @errorExplore.
  ///
  /// In en, this message translates to:
  /// **'The kitchen\'s not answering right now.'**
  String get errorExplore;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @mapComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Karachi on the map'**
  String get mapComingSoonTitle;

  /// No description provided for @mapComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Pins for every place in your archive — arriving soon.'**
  String get mapComingSoonBody;

  /// No description provided for @journalEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first visit starts here'**
  String get journalEmptyTitle;

  /// No description provided for @journalEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Every outing becomes a page in your personal food journal.'**
  String get journalEmptyBody;

  /// No description provided for @journalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visit by visit — Burns Road to Do Darya, year by year.'**
  String get journalSubtitle;

  /// No description provided for @mapPinCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No pins yet — seed data or add eateries with locations.} =1{1 place on the Karachi map} other{{count} places on the Karachi map}}'**
  String mapPinCount(int count);

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Archive member'**
  String get profileMemberSince;

  /// No description provided for @profileVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get profileVisits;

  /// No description provided for @profileAreas.
  ///
  /// In en, this message translates to:
  /// **'Areas'**
  String get profileAreas;

  /// No description provided for @profileScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get profileScore;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLanguageValue.
  ///
  /// In en, this message translates to:
  /// **'English + Roman Urdu'**
  String get profileLanguageValue;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Open my archive'**
  String get onboardingStart;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Karachi food journal'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log every visit. Remember every plate. Build the city\'s living archive — one meal at a time.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingWelcomeKarachi.
  ///
  /// In en, this message translates to:
  /// **'All of Karachi — every area, every plate. Explore neighborhoods from Areas anytime.'**
  String get onboardingWelcomeKarachi;

  /// No description provided for @onboardingCravingTitle.
  ///
  /// In en, this message translates to:
  /// **'What are you craving?'**
  String get onboardingCravingTitle;

  /// No description provided for @onboardingCravingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll surface spots and dishes around this first.'**
  String get onboardingCravingSubtitle;

  /// No description provided for @onboardingAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Your home base in Karachi?'**
  String get onboardingAreaTitle;

  /// No description provided for @onboardingAreaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the area you eat in most — we\'ll start there.'**
  String get onboardingAreaSubtitle;

  /// No description provided for @onboardingQ1.
  ///
  /// In en, this message translates to:
  /// **'What brings you here?'**
  String get onboardingQ1;

  /// No description provided for @onboardingQ1Hint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll shape your home screen around how you eat Karachi.'**
  String get onboardingQ1Hint;

  /// No description provided for @onboardingQ2.
  ///
  /// In en, this message translates to:
  /// **'Your favourite area?'**
  String get onboardingQ2;

  /// No description provided for @onboardingQ2Hint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll surface places and moods from there first.'**
  String get onboardingQ2Hint;

  /// No description provided for @onboardingQ3.
  ///
  /// In en, this message translates to:
  /// **'How do you usually eat out?'**
  String get onboardingQ3;

  /// No description provided for @onboardingQ3Hint.
  ///
  /// In en, this message translates to:
  /// **'Pick the mood that fits you most.'**
  String get onboardingQ3Hint;

  /// No description provided for @galleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen Gallery'**
  String get galleryTitle;

  /// No description provided for @gallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap any phone preview to jump straight into that screen.'**
  String get gallerySubtitle;

  /// No description provided for @galleryVisitSample.
  ///
  /// In en, this message translates to:
  /// **'Sample visit'**
  String get galleryVisitSample;

  /// No description provided for @galleryMobileHint.
  ///
  /// In en, this message translates to:
  /// **'Mini iPhone frames show the current journal notebook look.'**
  String get galleryMobileHint;

  /// No description provided for @gallerySectionTabs.
  ///
  /// In en, this message translates to:
  /// **'Main tabs'**
  String get gallerySectionTabs;

  /// No description provided for @gallerySectionTabsHint.
  ///
  /// In en, this message translates to:
  /// **'Home · Explore · Map · Journal · Profile'**
  String get gallerySectionTabsHint;

  /// No description provided for @gallerySectionJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal & visits'**
  String get gallerySectionJournal;

  /// No description provided for @gallerySectionJournalHint.
  ///
  /// In en, this message translates to:
  /// **'Book flip, timeline, add/edit visit, stickers'**
  String get gallerySectionJournalHint;

  /// No description provided for @gallerySectionArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive tools'**
  String get gallerySectionArchive;

  /// No description provided for @gallerySectionArchiveHint.
  ///
  /// In en, this message translates to:
  /// **'Eateries, areas, lists, dishes, collections'**
  String get gallerySectionArchiveHint;

  /// No description provided for @gallerySectionKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi identity'**
  String get gallerySectionKarachi;

  /// No description provided for @gallerySectionKarachiHint.
  ///
  /// In en, this message translates to:
  /// **'Passport, trails, wrapped, seasonal, order'**
  String get gallerySectionKarachiHint;

  /// No description provided for @gallerySectionMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get gallerySectionMore;

  /// No description provided for @galleryBookFlipHint.
  ///
  /// In en, this message translates to:
  /// **'Page curl + prev/next + stickers'**
  String get galleryBookFlipHint;

  /// No description provided for @galleryEaterySample.
  ///
  /// In en, this message translates to:
  /// **'Sample eatery profile'**
  String get galleryEaterySample;

  /// No description provided for @galleryOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Bundled — works offline'**
  String get galleryOfflineHint;

  /// No description provided for @galleryCaptureHint.
  ///
  /// In en, this message translates to:
  /// **'npm run gallery:capture for PNG shots'**
  String get galleryCaptureHint;

  /// No description provided for @galleryFooterNote.
  ///
  /// In en, this message translates to:
  /// **'Hard refresh Chrome after builds. Book memories sync when API online.'**
  String get galleryFooterNote;

  /// No description provided for @eateryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Eatery not found in the archive.'**
  String get eateryNotFound;

  /// No description provided for @eateryVisitsHere.
  ///
  /// In en, this message translates to:
  /// **'Visits here'**
  String get eateryVisitsHere;

  /// No description provided for @eateryNoVisitsYet.
  ///
  /// In en, this message translates to:
  /// **'No visits logged here yet — be the first to add one.'**
  String get eateryNoVisitsYet;

  /// No description provided for @eateryMustTry.
  ///
  /// In en, this message translates to:
  /// **'Must try'**
  String get eateryMustTry;

  /// No description provided for @eateryDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get eateryDetails;

  /// No description provided for @eateryPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get eateryPhone;

  /// No description provided for @eateryHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get eateryHours;

  /// No description provided for @eateryFamousFor.
  ///
  /// In en, this message translates to:
  /// **'Famous for'**
  String get eateryFamousFor;

  /// No description provided for @eateryBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get eateryBranches;

  /// No description provided for @eateryExternalReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get eateryExternalReviews;

  /// No description provided for @eateryPromotions.
  ///
  /// In en, this message translates to:
  /// **'Offers & promotions'**
  String get eateryPromotions;

  /// No description provided for @eateryViewReview.
  ///
  /// In en, this message translates to:
  /// **'View review'**
  String get eateryViewReview;

  /// No description provided for @eateryWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get eateryWebsite;

  /// No description provided for @eateryInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get eateryInstagram;

  /// No description provided for @eateryGoogleRating.
  ///
  /// In en, this message translates to:
  /// **'{rating} ★ on Google ({count} reviews)'**
  String eateryGoogleRating(double rating, int count);

  /// No description provided for @visitReview.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get visitReview;

  /// No description provided for @eateryVisitCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 visit logged} other{{count} visits logged}}'**
  String eateryVisitCount(int count);

  /// No description provided for @visitNotFound.
  ///
  /// In en, this message translates to:
  /// **'Visit not found.'**
  String get visitNotFound;

  /// No description provided for @visitBy.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get visitBy;

  /// No description provided for @visitMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get visitMemory;

  /// No description provided for @visitFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get visitFavorite;

  /// No description provided for @addVisitEatery.
  ///
  /// In en, this message translates to:
  /// **'Where did you eat?'**
  String get addVisitEatery;

  /// No description provided for @addVisitRating.
  ///
  /// In en, this message translates to:
  /// **'Overall rating'**
  String get addVisitRating;

  /// No description provided for @addVisitReviewHint.
  ///
  /// In en, this message translates to:
  /// **'How was it? A sentence or two is enough.'**
  String get addVisitReviewHint;

  /// No description provided for @addVisitMood.
  ///
  /// In en, this message translates to:
  /// **'Mood tags'**
  String get addVisitMood;

  /// No description provided for @addVisitSave.
  ///
  /// In en, this message translates to:
  /// **'Save visit'**
  String get addVisitSave;

  /// No description provided for @addVisitItems.
  ///
  /// In en, this message translates to:
  /// **'What did you eat?'**
  String get addVisitItems;

  /// No description provided for @addVisitCustomItem.
  ///
  /// In en, this message translates to:
  /// **'Add something not on the menu'**
  String get addVisitCustomItem;

  /// No description provided for @addVisitDemoSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved locally — connect API to sync with your archive.'**
  String get addVisitDemoSaved;

  /// No description provided for @apiConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get apiConnected;

  /// No description provided for @apiOffline.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get apiOffline;

  /// No description provided for @areasTitle.
  ///
  /// In en, this message translates to:
  /// **'Karachi Areas'**
  String get areasTitle;

  /// No description provided for @areaEateryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place} other{{count} places}}'**
  String areaEateryCount(int count);

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Heart places you love — they\'ll show up here.'**
  String get favoritesEmpty;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Save spots you want to try next.'**
  String get wishlistEmpty;

  /// No description provided for @wishlistAdd.
  ///
  /// In en, this message translates to:
  /// **'Save to wishlist'**
  String get wishlistAdd;

  /// No description provided for @dishesTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Archive'**
  String get dishesTitle;

  /// No description provided for @dishesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search dishes across Karachi...'**
  String get dishesSearchHint;

  /// No description provided for @dishesResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 dish} other{{count} dishes}}'**
  String dishesResultCount(int count);

  /// No description provided for @exploreSortRating.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get exploreSortRating;

  /// No description provided for @exploreSortName.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get exploreSortName;

  /// No description provided for @exploreSortArea.
  ///
  /// In en, this message translates to:
  /// **'By area'**
  String get exploreSortArea;

  /// No description provided for @homeDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your food journal'**
  String get homeDashboardTitle;

  /// No description provided for @homeDashboardPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places visited'**
  String get homeDashboardPlaces;

  /// No description provided for @homeDashboardVisits.
  ///
  /// In en, this message translates to:
  /// **'Total visits'**
  String get homeDashboardVisits;

  /// No description provided for @homeDashboardSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get homeDashboardSpent;

  /// No description provided for @homeDashboardAreas.
  ///
  /// In en, this message translates to:
  /// **'Areas explored'**
  String get homeDashboardAreas;

  /// No description provided for @homeDashboardAvgBill.
  ///
  /// In en, this message translates to:
  /// **'Avg bill {amount}'**
  String homeDashboardAvgBill(String amount);

  /// No description provided for @homeDashboardAvgRating.
  ///
  /// In en, this message translates to:
  /// **'avg rating'**
  String get homeDashboardAvgRating;

  /// No description provided for @homeMustTry.
  ///
  /// In en, this message translates to:
  /// **'Must try across Karachi'**
  String get homeMustTry;

  /// No description provided for @homeLatestReviews.
  ///
  /// In en, this message translates to:
  /// **'Latest reviews'**
  String get homeLatestReviews;

  /// No description provided for @journalVisitCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 visit in journal} other{{count} visits in journal}}'**
  String journalVisitCount(int count);

  /// No description provided for @eateryPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular on the menu'**
  String get eateryPopular;

  /// No description provided for @homeDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get homeDiscover;

  /// No description provided for @homeLinkAreas.
  ///
  /// In en, this message translates to:
  /// **'All areas'**
  String get homeLinkAreas;

  /// No description provided for @homeLinkFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get homeLinkFavorites;

  /// No description provided for @homeLinkWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get homeLinkWishlist;

  /// No description provided for @homeLinkDishes.
  ///
  /// In en, this message translates to:
  /// **'Dish search'**
  String get homeLinkDishes;

  /// No description provided for @journalFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get journalFilterAll;

  /// No description provided for @visitItems.
  ///
  /// In en, this message translates to:
  /// **'What you ordered'**
  String get visitItems;

  /// No description provided for @visitBill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get visitBill;

  /// No description provided for @profileEateries.
  ///
  /// In en, this message translates to:
  /// **'City archive'**
  String get profileEateries;

  /// No description provided for @profileArchive.
  ///
  /// In en, this message translates to:
  /// **'Your archive'**
  String get profileArchive;

  /// No description provided for @passportTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Passport'**
  String get passportTitle;

  /// No description provided for @passportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stamp every Karachi neighborhood you eat in'**
  String get passportSubtitle;

  /// No description provided for @passportStamps.
  ///
  /// In en, this message translates to:
  /// **'Area stamps'**
  String get passportStamps;

  /// No description provided for @passportProgress.
  ///
  /// In en, this message translates to:
  /// **'{visited} of {total} areas stamped'**
  String passportProgress(int visited, int total);

  /// No description provided for @passportVisitCount.
  ///
  /// In en, this message translates to:
  /// **'{count} visits logged'**
  String passportVisitCount(int count);

  /// No description provided for @passportStampVisited.
  ///
  /// In en, this message translates to:
  /// **'{count} places in archive'**
  String passportStampVisited(int count);

  /// No description provided for @passportStampLocked.
  ///
  /// In en, this message translates to:
  /// **'{count} places to discover'**
  String passportStampLocked(int count);

  /// No description provided for @trailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Trails'**
  String get trailsTitle;

  /// No description provided for @trailsComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get trailsComplete;

  /// No description provided for @trailsProgress.
  ///
  /// In en, this message translates to:
  /// **'{visited} of {total} stops'**
  String trailsProgress(int visited, int total);

  /// No description provided for @homeLinkPassport.
  ///
  /// In en, this message translates to:
  /// **'Food Passport'**
  String get homeLinkPassport;

  /// No description provided for @homeLinkTrails.
  ///
  /// In en, this message translates to:
  /// **'Food Trails'**
  String get homeLinkTrails;

  /// No description provided for @visitShare.
  ///
  /// In en, this message translates to:
  /// **'Share visit'**
  String get visitShare;

  /// No description provided for @journalViewBook.
  ///
  /// In en, this message translates to:
  /// **'Book view'**
  String get journalViewBook;

  /// No description provided for @journalViewTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline view'**
  String get journalViewTimeline;

  /// No description provided for @yearInFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Year in Food'**
  String get yearInFoodTitle;

  /// No description provided for @yearInFoodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Karachi food story this year'**
  String get yearInFoodSubtitle;

  /// No description provided for @yearInFoodVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits logged'**
  String get yearInFoodVisits;

  /// No description provided for @yearInFoodPlaces.
  ///
  /// In en, this message translates to:
  /// **'Places tried'**
  String get yearInFoodPlaces;

  /// No description provided for @yearInFoodSpent.
  ///
  /// In en, this message translates to:
  /// **'Estimated spend'**
  String get yearInFoodSpent;

  /// No description provided for @yearInFoodTopArea.
  ///
  /// In en, this message translates to:
  /// **'Top area'**
  String get yearInFoodTopArea;

  /// No description provided for @yearInFoodTopDish.
  ///
  /// In en, this message translates to:
  /// **'Most ordered'**
  String get yearInFoodTopDish;

  /// No description provided for @yearInFoodStory.
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get yearInFoodStory;

  /// No description provided for @yearInFoodBestVisit.
  ///
  /// In en, this message translates to:
  /// **'Open best visit'**
  String get yearInFoodBestVisit;

  /// No description provided for @seasonalPicks.
  ///
  /// In en, this message translates to:
  /// **'Curated picks'**
  String get seasonalPicks;

  /// No description provided for @seasonalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matches yet — add more eateries to the archive.'**
  String get seasonalEmpty;

  /// No description provided for @mapHeatHint.
  ///
  /// In en, this message translates to:
  /// **'Lit pins = places you\'ve visited. Grey = still to explore.'**
  String get mapHeatHint;

  /// No description provided for @mapAreaOverlayLabel.
  ///
  /// In en, this message translates to:
  /// **'Area boundaries'**
  String get mapAreaOverlayLabel;

  /// No description provided for @mapAreaOverlayHint.
  ///
  /// In en, this message translates to:
  /// **'Green zones = neighborhoods you\'ve visited. Boundaries from OpenStreetMap where available.'**
  String get mapAreaOverlayHint;

  /// No description provided for @mapOfflineDownloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving Karachi map to your phone…'**
  String get mapOfflineDownloadLabel;

  /// No description provided for @mapHeatSummary.
  ///
  /// In en, this message translates to:
  /// **'{visited} visited of {total} on map'**
  String mapHeatSummary(int visited, int total);

  /// No description provided for @friendActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s latest visit'**
  String get friendActivityTitle;

  /// No description provided for @homeLinkWrapped.
  ///
  /// In en, this message translates to:
  /// **'Year in Food'**
  String get homeLinkWrapped;

  /// No description provided for @homeLinkSeasonal.
  ///
  /// In en, this message translates to:
  /// **'Ramadan & seasons'**
  String get homeLinkSeasonal;

  /// No description provided for @addVisitPhoto.
  ///
  /// In en, this message translates to:
  /// **'Visit photo'**
  String get addVisitPhoto;

  /// No description provided for @addVisitPhotoPick.
  ///
  /// In en, this message translates to:
  /// **'Add photo from gallery'**
  String get addVisitPhotoPick;

  /// No description provided for @addVisitPhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get addVisitPhotoRemove;

  /// No description provided for @profilePhotoPick.
  ///
  /// In en, this message translates to:
  /// **'Choose profile photo'**
  String get profilePhotoPick;

  /// No description provided for @profilePhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove profile photo'**
  String get profilePhotoRemove;

  /// No description provided for @profilePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Tap photo to change'**
  String get profilePhotoHint;

  /// No description provided for @profileNameEdit.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileNameEdit;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name in the archive'**
  String get profileNameHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit visit'**
  String get editVisitTitle;

  /// No description provided for @visitDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete visit?'**
  String get visitDeleteTitle;

  /// No description provided for @visitDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the visit from your journal permanently.'**
  String get visitDeleteBody;

  /// No description provided for @visitDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get visitDeleteConfirm;

  /// No description provided for @visitCompanions.
  ///
  /// In en, this message translates to:
  /// **'With'**
  String get visitCompanions;

  /// No description provided for @visitMemoryHint.
  ///
  /// In en, this message translates to:
  /// **'Memory note (optional)'**
  String get visitMemoryHint;

  /// No description provided for @customMoodHint.
  ///
  /// In en, this message translates to:
  /// **'Custom mood tag'**
  String get customMoodHint;

  /// No description provided for @addEateryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add eatery'**
  String get addEateryTitle;

  /// No description provided for @addEateryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get addEateryName;

  /// No description provided for @addEateryArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get addEateryArea;

  /// No description provided for @addEateryAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addEateryAddress;

  /// No description provided for @addEateryDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get addEateryDescription;

  /// No description provided for @addEaterySave.
  ///
  /// In en, this message translates to:
  /// **'Add to archive'**
  String get addEaterySave;

  /// No description provided for @addEaterySaved.
  ///
  /// In en, this message translates to:
  /// **'Eatery added to your archive'**
  String get addEaterySaved;

  /// No description provided for @addEateryDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'Similar place exists'**
  String get addEateryDuplicateTitle;

  /// No description provided for @addEateryDuplicateBody.
  ///
  /// In en, this message translates to:
  /// **'Use the existing record or add anyway?'**
  String get addEateryDuplicateBody;

  /// No description provided for @addEateryUseExisting.
  ///
  /// In en, this message translates to:
  /// **'Use existing'**
  String get addEateryUseExisting;

  /// No description provided for @addEateryAddAnyway.
  ///
  /// In en, this message translates to:
  /// **'Add anyway'**
  String get addEateryAddAnyway;

  /// No description provided for @collectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collectionsTitle;

  /// No description provided for @collectionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No lists yet — tap + to start one.'**
  String get collectionsEmpty;

  /// No description provided for @collectionsNew.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get collectionsNew;

  /// No description provided for @collectionsNameHint.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get collectionsNameHint;

  /// No description provided for @collectionsNoPlaces.
  ///
  /// In en, this message translates to:
  /// **'No places yet'**
  String get collectionsNoPlaces;

  /// No description provided for @collectionsAddFromExplore.
  ///
  /// In en, this message translates to:
  /// **'Tick eateries to add to this list'**
  String get collectionsAddFromExplore;

  /// No description provided for @theOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'The Order'**
  String get theOrderTitle;

  /// No description provided for @theOrderEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log visits with items to see your breakdown.'**
  String get theOrderEmpty;

  /// No description provided for @theOrderCount.
  ///
  /// In en, this message translates to:
  /// **'{count}×'**
  String theOrderCount(int count);

  /// No description provided for @missItTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurants We Miss'**
  String get missItTitle;

  /// No description provided for @missItSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Closed places — archive preserved, memory stays.'**
  String get missItSubtitle;

  /// No description provided for @missItEmpty.
  ///
  /// In en, this message translates to:
  /// **'No closed eateries in archive yet.'**
  String get missItEmpty;

  /// No description provided for @dictionaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Karachi Dictionary'**
  String get dictionaryTitle;

  /// No description provided for @nearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'If you\'re here…'**
  String get nearbyTitle;

  /// No description provided for @nearbySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Within a few km'**
  String get nearbySubtitle;

  /// No description provided for @pioneerBadge.
  ///
  /// In en, this message translates to:
  /// **'You logged this first'**
  String get pioneerBadge;

  /// No description provided for @compareVisitsHint.
  ///
  /// In en, this message translates to:
  /// **'{count} visits to compare'**
  String compareVisitsHint(int count);

  /// No description provided for @homeLinkCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get homeLinkCollections;

  /// No description provided for @homeLinkOrder.
  ///
  /// In en, this message translates to:
  /// **'The Order'**
  String get homeLinkOrder;

  /// No description provided for @homeLinkMissIt.
  ///
  /// In en, this message translates to:
  /// **'Miss It?'**
  String get homeLinkMissIt;

  /// No description provided for @homeLinkDictionary.
  ///
  /// In en, this message translates to:
  /// **'Dictionary'**
  String get homeLinkDictionary;

  /// No description provided for @homeLinkAddEatery.
  ///
  /// In en, this message translates to:
  /// **'Add eatery'**
  String get homeLinkAddEatery;

  /// No description provided for @friendProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend profile'**
  String get friendProfileTitle;

  /// No description provided for @friendNameEdit.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s name'**
  String get friendNameEdit;

  /// No description provided for @myCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'My cards & deals'**
  String get myCardsTitle;

  /// No description provided for @myCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick banks, wallets, and programs you use — we highlight matching discounts on eateries.'**
  String get myCardsSubtitle;

  /// No description provided for @myCardsAggregators.
  ///
  /// In en, this message translates to:
  /// **'Deal apps'**
  String get myCardsAggregators;

  /// No description provided for @myCardsBanks.
  ///
  /// In en, this message translates to:
  /// **'Bank cards'**
  String get myCardsBanks;

  /// No description provided for @myCardsWallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get myCardsWallets;

  /// No description provided for @myCardsLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty programs'**
  String get myCardsLoyalty;

  /// No description provided for @myCardsPartnerNote.
  ///
  /// In en, this message translates to:
  /// **'Partner apps'**
  String get myCardsPartnerNote;

  /// No description provided for @myCardsNoPublicApi.
  ///
  /// In en, this message translates to:
  /// **'Golootlo & Peekaboo have no free public API — we match curated deals and link out. Contact golootlo.pk / FetchSky for partnership feeds.'**
  String get myCardsNoPublicApi;

  /// No description provided for @tasteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Taste profile'**
  String get tasteProfileTitle;

  /// No description provided for @tasteGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get tasteGender;

  /// No description provided for @tasteSpice.
  ///
  /// In en, this message translates to:
  /// **'Spice tolerance'**
  String get tasteSpice;

  /// No description provided for @tasteSweets.
  ///
  /// In en, this message translates to:
  /// **'Sweets'**
  String get tasteSweets;

  /// No description provided for @tasteBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get tasteBudget;

  /// No description provided for @tasteCuisines.
  ///
  /// In en, this message translates to:
  /// **'Favorite cuisines'**
  String get tasteCuisines;

  /// No description provided for @tasteAvoids.
  ///
  /// In en, this message translates to:
  /// **'Usually avoid'**
  String get tasteAvoids;

  /// No description provided for @discountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your discounts here'**
  String get discountsTitle;

  /// No description provided for @discountsVerifyHint.
  ///
  /// In en, this message translates to:
  /// **'Verify offer at checkout — curated data, not live bank feed.'**
  String get discountsVerifyHint;

  /// No description provided for @exploreMyDeals.
  ///
  /// In en, this message translates to:
  /// **'My discounts'**
  String get exploreMyDeals;

  /// No description provided for @onboardingTasteTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you eat?'**
  String get onboardingTasteTitle;

  /// No description provided for @onboardingTasteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Helps craving picks and future recommendations.'**
  String get onboardingTasteSubtitle;

  /// No description provided for @onboardingGenderTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get onboardingGenderTitle;

  /// No description provided for @onboardingGenderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — skip by tapping Next.'**
  String get onboardingGenderSubtitle;

  /// No description provided for @onboardingCuisinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite cuisines'**
  String get onboardingCuisinesTitle;

  /// No description provided for @onboardingCuisinesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one.'**
  String get onboardingCuisinesSubtitle;

  /// No description provided for @onboardingCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards & deal apps'**
  String get onboardingCardsTitle;

  /// No description provided for @onboardingCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Golootlo, Peekaboo, bank cards — show where you save.'**
  String get onboardingCardsSubtitle;

  /// No description provided for @journalExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export journal PDF'**
  String get journalExportPdf;

  /// No description provided for @visitVoiceAdd.
  ///
  /// In en, this message translates to:
  /// **'Attach voice note'**
  String get visitVoiceAdd;

  /// No description provided for @visitVoiceAttached.
  ///
  /// In en, this message translates to:
  /// **'Voice note attached'**
  String get visitVoiceAttached;

  /// No description provided for @visitVoiceRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove voice note'**
  String get visitVoiceRemove;

  /// No description provided for @trailCertificateTitle.
  ///
  /// In en, this message translates to:
  /// **'Trail completed'**
  String get trailCertificateTitle;

  /// No description provided for @trailCertificateAwarded.
  ///
  /// In en, this message translates to:
  /// **'Awarded to {userName}'**
  String trailCertificateAwarded(String userName);

  /// No description provided for @trailCertificateFooter.
  ///
  /// In en, this message translates to:
  /// **'DeeFoodieApp — Karachi food archive'**
  String get trailCertificateFooter;

  /// No description provided for @trailCertificateShare.
  ///
  /// In en, this message translates to:
  /// **'Share certificate'**
  String get trailCertificateShare;

  /// No description provided for @trailCertificateCopied.
  ///
  /// In en, this message translates to:
  /// **'Certificate copied — paste to share'**
  String get trailCertificateCopied;

  /// No description provided for @mapPinClusterSummary.
  ///
  /// In en, this message translates to:
  /// **'{shown} pins shown · {total} in archive'**
  String mapPinClusterSummary(int shown, int total);

  /// No description provided for @homeChainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your chains & spots'**
  String get homeChainsTitle;

  /// No description provided for @homeChainsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Matches from your onboarding picks'**
  String get homeChainsSubtitle;

  /// No description provided for @onboardingPickOne.
  ///
  /// In en, this message translates to:
  /// **'Pick one'**
  String get onboardingPickOne;

  /// No description provided for @onboardingChainsTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite chains & spots'**
  String get onboardingChainsTitle;

  /// No description provided for @onboardingChainsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — helps surface deals and familiar names.'**
  String get onboardingChainsSubtitle;

  /// No description provided for @addVisitTime.
  ///
  /// In en, this message translates to:
  /// **'Visit time'**
  String get addVisitTime;

  /// No description provided for @addVisitTimeOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional — when you ate'**
  String get addVisitTimeOptional;

  /// No description provided for @nearMeTitle.
  ///
  /// In en, this message translates to:
  /// **'Near you now'**
  String get nearMeTitle;

  /// No description provided for @nearMeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spots within a few km'**
  String get nearMeSubtitle;

  /// No description provided for @planTonightTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan tonight'**
  String get planTonightTitle;

  /// No description provided for @planTonightHint.
  ///
  /// In en, this message translates to:
  /// **'Long-press map pins to add (max 3)'**
  String get planTonightHint;

  /// No description provided for @planTonightEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stops picked yet'**
  String get planTonightEmpty;

  /// No description provided for @planTonightOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get planTonightOpenMaps;

  /// No description provided for @quickLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick log'**
  String get quickLogTitle;

  /// No description provided for @quickLogContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to full form'**
  String get quickLogContinue;

  /// No description provided for @syncQueuePending.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 visit waiting to sync} other{{count} visits waiting to sync}}'**
  String syncQueuePending(int count);

  /// No description provided for @dishRankingTitle.
  ///
  /// In en, this message translates to:
  /// **'City archive rating'**
  String get dishRankingTitle;

  /// No description provided for @dishOnMenuAt.
  ///
  /// In en, this message translates to:
  /// **'On the menu at'**
  String get dishOnMenuAt;

  /// No description provided for @dishNoMenuHits.
  ///
  /// In en, this message translates to:
  /// **'No menu matches yet — log visits with this dish.'**
  String get dishNoMenuHits;

  /// No description provided for @exploreUnvisited.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t been'**
  String get exploreUnvisited;

  /// No description provided for @explorePriceBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get explorePriceBudget;

  /// No description provided for @explorePriceMid.
  ///
  /// In en, this message translates to:
  /// **'Mid-range'**
  String get explorePriceMid;

  /// No description provided for @explorePriceSplurge.
  ///
  /// In en, this message translates to:
  /// **'Splurge'**
  String get explorePriceSplurge;

  /// No description provided for @dictionaryFromCraving.
  ///
  /// In en, this message translates to:
  /// **'What is {term}?'**
  String dictionaryFromCraving(String term);

  /// No description provided for @shareVisitImage.
  ///
  /// In en, this message translates to:
  /// **'Share as image'**
  String get shareVisitImage;

  /// No description provided for @voiceOnSpread.
  ///
  /// In en, this message translates to:
  /// **'Voice memory'**
  String get voiceOnSpread;

  /// No description provided for @visitTemplateApply.
  ///
  /// In en, this message translates to:
  /// **'Use usual order'**
  String get visitTemplateApply;

  /// No description provided for @visitTemplateSaved.
  ///
  /// In en, this message translates to:
  /// **'Usual order saved for next time'**
  String get visitTemplateSaved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
