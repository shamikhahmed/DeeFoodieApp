import 'package:flutter/widgets.dart';

const _ur = <String, String>{
  'Log my food journal': 'Apna food journal likhna',
  'Explore Karachi': 'Karachi explore karna',
  'Remember old favorites': 'Purani favorites yaad rakhna',
  'Find deals & save': 'Deals dhoondh kar bachat',
  'Clifton': 'Clifton',
  'DHA': 'DHA',
  'Burns Road': 'Burns Road',
  'Do Darya': 'Do Darya',
  'Tipu Sultan Road': 'Tipu Sultan Road',
  'Biryani': 'Biryani',
  'Nihari': 'Nihari',
  'BBQ': 'BBQ',
  'Fast Food': 'Fast Food',
  'Street Food': 'Street Food',
  "McDonald's": "McDonald's",
  'KFC': 'KFC',
  "Hardee's": "Hardee's",
  'Friends': 'Doston ke sath',
  'Family': 'Ghar walon ke sath',
  'Desi': 'Desi',
  'Chinese': 'Chinese',
  'Pizza': 'Pizza',
  'Burgers': 'Burgers',
};

String onboardingChipLabel(BuildContext context, String english) {
  final code = Localizations.localeOf(context).languageCode;
  if (code != 'ur') return english;
  return _ur[english] ?? english;
}
