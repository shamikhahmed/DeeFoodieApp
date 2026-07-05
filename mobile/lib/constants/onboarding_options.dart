import 'food_visuals.dart';

const onboardingIntentOptions = [
  'Log my food journal',
  'Explore Karachi',
  'Remember old favorites',
  'Find deals & save',
];

const onboardingPopularAreas = [
  'Clifton',
  'DHA',
  'Burns Road',
  'Do Darya',
  'Boat Basin',
  'Saddar',
  'PECHS',
  'Gulshan-e-Iqbal',
  'North Nazimabad',
  'Bahadurabad',
  'Tariq Road',
  'Korangi',
];

const onboardingCravingOptions = [
  'Biryani',
  'Nihari',
  'BBQ',
  'Chai & Paratha',
  'Dessert',
  'Street Food',
];

const onboardingMoodOptions = [
  'Friends',
  'Family',
  'Date',
  'Alone',
  'Late Night',
  'Celebration',
];

String onboardingHeroAsset = 'assets/backgrounds/karachi_food_street.jpg';

String cravingPhotoFor(String craving) =>
    cravingPhotoUrls[craving] ?? foodAccentPhotos['default']!;
