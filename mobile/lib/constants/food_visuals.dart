/// Curated Unsplash food + Karachi photos. Prefer these over cartoon sticker SVGs.
const cravingPhotoUrls = <String, String>{
  'Biryani': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
  'Nihari': 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80',
  'BBQ': 'https://images.unsplash.com/photo-1622597467836-f3285f2131b8?w=800&q=80',
  'Chai & Paratha': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800&q=80',
  'Dessert': 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=800&q=80',
  'Street Food': 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
  'Fast Food': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/800px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
  'Seafood': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Seaview_%28Clifton_Beach%29_Karachi.jpg/800px-Seaview_%28Clifton_Beach%29_Karachi.jpg',
  'Pizza': 'https://upload.wikimedia.org/wikipedia/commons/5/55/A_Pizza_Hut_Restaurant_in_Karachi_Pakistan.jpg',
  'Burgers': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Food_street%2C_Burns_Road%2C_Karachi.jpg/800px-Food_street%2C_Burns_Road%2C_Karachi.jpg',
};

const areaPhotoUrls = <String, String>{
  'Burns Road': 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
  'Clifton': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80',
  'Clifton Block 2': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80',
  'Do Darya': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
  'DHA': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  'DHA Phase 6': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  'DHA Phase 8': 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
  'Boat Basin': 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
  'Saddar': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
  'Tariq Road': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80',
  'PECHS': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  'Gulshan-e-Iqbal': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
  'Gulistan-e-Jauhar': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
  'North Nazimabad': 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
  'Nazimabad': 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
  'Malir': 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80',
  'Korangi': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
  'Lyari': 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
  'Keamari': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
  'Bahadurabad': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
  'Defence View': 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80',
  'Shahrah-e-Faisal': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  'Federal B Area': 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80',
  'Jamshed Town': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
  'Landhi': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80',
  'Orangi': 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
  'SITE Area': 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80',
  'Scheme 33': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
  'Surjani Town': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80',
  'Buffer Zone': 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
};

const _areaPhotoPool = [
  'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
  'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80',
  'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
  'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
  'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80',
  'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80',
  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
];

String areaPhoto(String areaName) {
  final direct = areaPhotoUrls[areaName];
  if (direct != null) return direct;
  return _areaPhotoPool[areaName.hashCode.abs() % _areaPhotoPool.length];
}

const onboardingHeroPhoto =
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1200&q=80';

/// Screen accents when no craving context exists.
const foodAccentPhotos = <String, String>{
  'hero': onboardingHeroPhoto,
  'journal': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=600&q=80',
  'explore': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=600&q=80',
  'favorites': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&q=80',
  'wishlist': 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=600&q=80',
  'journalEmpty': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80',
  'default': onboardingHeroPhoto,
};

String cravingPhoto(String craving) =>
    cravingPhotoUrls[craving] ?? foodAccentPhotos['default']!;

String accentPhoto(String key) => foodAccentPhotos[key] ?? foodAccentPhotos['default']!;
