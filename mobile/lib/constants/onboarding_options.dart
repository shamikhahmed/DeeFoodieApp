import 'package:flutter/material.dart';
import 'food_visuals.dart';

const onboardingIntentOptions = [
  'Log my food journal',
  'Explore Karachi',
  'Remember old favorites',
  'Find deals & save',
];

/// Popular Karachi areas — grouped for onboarding chips.
const onboardingPopularAreas = [
  'Clifton',
  'DHA',
  'DHA Phase 6',
  'DHA Phase 8',
  'Defence View',
  'Boat Basin',
  'Do Darya',
  'Burns Road',
  'Saddar',
  'Tariq Road',
  'PECHS',
  'Bahadurabad',
  'Bahria Town',
  'Gulshan-e-Iqbal',
  'Gulistan-e-Jauhar',
  'North Nazimabad',
  'Nazimabad',
  'Federal B Area',
  'Korangi',
  'Malir',
  'Lyari',
  'Keamari',
  'Port Grand',
  'Tipu Sultan Road',
  'Shahrah-e-Faisal',
  'Kharadar',
  'Zamzama',
  'Hawksbay',
  'Liaquatabad',
  'Buffer Zone',
];

const onboardingCravingOptions = [
  'Biryani',
  'Nihari',
  'BBQ',
  'Chai & Paratha',
  'Dessert',
  'Street Food',
  'Fast Food',
  'Seafood',
  'Pizza',
  'Burgers',
];

const onboardingMoodOptions = [
  'Friends',
  'Family',
  'Date',
  'Alone',
  'Late Night',
  'Celebration',
  'Work',
  'Study',
];

const onboardingCuisineOptions = [
  'Desi',
  'Chinese',
  'BBQ',
  'Biryani',
  'Continental',
  'Fast Food',
  'Street Food',
  'Dessert',
  'Seafood',
  'Pizza',
  'Burgers',
  'Cafe',
  'Breakfast',
  'Ice Cream',
  'Tea & Paratha',
];

/// Karachi fast-food & chain spots users recognize.
const onboardingChainOptions = [
  'McDonald\'s',
  'KFC',
  'Hardee\'s',
  'Burger King',
  'Pizza Hut',
  'Domino\'s',
  'Subway',
  'Optp',
  'Kolachi',
  'Bar-B-Q Tonight',
  'Howdy',
  'Ginsoy',
  'Kababjees',
  'Nando\'s',
  'Broadway',
];

String onboardingHeroAsset = 'assets/backgrounds/karachi_food_street.jpg';

String cravingPhotoFor(String craving) =>
    cravingPhotoUrls[craving] ?? foodAccentPhotos['default']!;

/// Extra journal stickers rendered as Material icons (no SVG asset).
const journalIconStickers = <String, IconData>{
  'heart': Icons.favorite,
  'star': Icons.star,
  'friends': Icons.groups,
  'family': Icons.family_restroom,
  'camera': Icons.photo_camera,
  'burger': Icons.lunch_dining,
  'pizza': Icons.local_pizza,
  'icecream': Icons.icecream,
  'spice': Icons.local_fire_department,
  'celebrate': Icons.celebration,
  'night': Icons.nightlight,
  'map': Icons.place,
};
