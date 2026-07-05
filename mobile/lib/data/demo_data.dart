import '../models/eatery.dart';
import '../models/visit.dart';

/// Offline demo archive — used when API is unreachable so the app never feels dead.
/// Coords match api/prisma/seed.ts EATERIES list. Photos: Unsplash food (category-themed, not venue logos).
class DemoData {
  static final eateries = <Eatery>[
    _e('demo-kolachi', 'Kolachi', 'Do Darya', ['Restaurant'], ['BBQ', 'Desi'], 67.0086, 24.8138,
        'Do Darya legend — BBQ platters, sea breeze, and the view everyone brings out-of-town guests for.',
        'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800&q=80', 4.5, ['Karachi Classic']),
    _e('demo-waris', 'Waris Nihari', 'Burns Road', ['Dhaba', 'Restaurant'], ['Nihari', 'Desi'], 67.0270, 24.8620,
        'Burns Road institution. Slow-cooked nihari before noon is a Karachi rite of passage.',
        'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80', 5.0, []),
    _e('demo-xanders', "Xander's", 'Clifton', ['Cafe'], ['Continental', 'Breakfast'], 67.0300, 24.8138,
        'Clifton café comfort — brunch, coffee, and the kind of table you linger at for hours.',
        'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&q=80', 4.0, []),
    _e('demo-student-biryani', 'Student Biryani', 'Tariq Road', ['Fast Food', 'Restaurant'], ['Biryani', 'Desi'],
        67.0610, 24.8720,
        'Tariq Road fuel stop. Spicy, fast, and somehow always the right call at midnight.',
        'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80', 4.5, ['Local Legend']),
    _e('demo-bbq-tonight', 'Bar-B-Q Tonight', 'Do Darya', ['Restaurant', 'BBQ Joint'], ['BBQ', 'Desi'], 67.0090,
        24.8140,
        'Do Darya BBQ spread — seekh kabab, karahi, and the full Karachi weekend energy.',
        'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=800&q=80', 4.0, []),
    _e('demo-cafe-flo', 'Cafe Flo', 'Clifton', ['Cafe', 'Restaurant'], ['Continental'], 67.0310, 24.8130,
        'Clifton European café — pastas, desserts, and a quiet corner when the city gets loud.',
        'https://images.unsplash.com/photo-1495474472287-4d89b57c5f2a?w=800&q=80', 4.5, []),
    _e('demo-javed-nihari', 'Javed Nihari', 'Burns Road', ['Dhaba'], ['Nihari', 'Desi'], 67.0275, 24.8615,
        'Pre-office nihari on Burns Road — faster than Waris, almost as good.',
        'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80', 4.5, []),
    _e('demo-boat-basin', 'Boat Basin Food Street', 'Boat Basin', ['Street Food', 'Fast Food'],
        ['Fast Food', 'BBQ'], 67.0335, 24.8275,
        'Classic Boat Basin run — bun kabab, chai, and people-watching till 1am.',
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80', 4.0, []),
    _e('demo-kababjees', 'Kababjees', 'Clifton', ['Restaurant', 'BBQ Joint'], ['BBQ', 'Desi'], 67.0295, 24.8125,
        'Solid Clifton BBQ for groups who cannot decide on one place.',
        'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=800&q=80', 3.5, []),
    _e('demo-seafood', 'Do Darya Seafood Grill', 'Do Darya', ['Restaurant'], ['Seafood'], 67.0080, 24.8145,
        'Fresh catch off the grill with the Arabian Sea right there. Go at sunset.',
        'https://images.unsplash.com/photo-1553621042-f6e147245754?w=800&q=80', 4.5, []),
    _e('demo-patio', 'The Patio', 'DHA', ['Cafe', 'Restaurant'], ['Continental', 'Breakfast'], 67.0500, 24.7960,
        'DHA brunch date — avocado toast actually good for once.',
        'https://images.unsplash.com/photo-1495474472287-4d89b57c5f2a?w=800&q=80', 4.5, []),
    _e('demo-nirala', 'Nirala Sweets', 'Tariq Road', ['Dessert Shop', 'Fast Food'], ['Desserts', 'Fast Food'],
        67.0620, 24.8730,
        'Tariq Road mithai — ras malai and gulab jamun, always reliable.',
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800&q=80', 4.0, []),
  ];

  static Eatery _e(
    String id,
    String name,
    String area,
    List<String> venueTypes,
    List<String> cuisines,
    double lng,
    double lat,
    String description,
    String cover,
    double rating,
    List<String> badges,
  ) =>
      Eatery(
        id: id,
        name: name,
        areaName: area,
        venueTypes: venueTypes,
        cuisines: cuisines,
        lng: lng,
        lat: lat,
        description: description,
        coverPhotoUrl: cover,
        avgRating: rating,
        badges: badges,
      );

  static final visits = <Visit>[
    const Visit(
      id: 'demo-v1',
      eateryId: 'demo-kolachi',
      eateryName: 'Kolachi',
      date: '2025-02-14',
      rating: 4.5,
      reviewText:
          'The seekh kabab still hits. Sea breeze, fairy lights, and that Do Darya hum — Karachi at its best.',
      moodTags: ['Friends', 'Late Night'],
      userName: 'You',
      memoryNote: 'Post-cricket match dinner with the boys.',
    ),
    const Visit(
      id: 'demo-v2',
      eateryId: 'demo-waris',
      eateryName: 'Waris Nihari',
      date: '2025-01-08',
      rating: 5.0,
      reviewText:
          'Sunday morning nihari ritual. The paya broth is unreal — worth the Burns Road parking nightmare.',
      moodTags: ['Alone', 'Comfort Food'],
      userName: 'You',
    ),
    const Visit(
      id: 'demo-v3',
      eateryId: 'demo-xanders',
      eateryName: "Xander's",
      date: '2025-03-02',
      rating: 4.0,
      reviewText:
          "Brunch for Ami's birthday. Eggs benedict solid, service warm, Clifton parking still painful.",
      moodTags: ['Family', 'Birthday'],
      userName: 'Friend',
    ),
    const Visit(
      id: 'demo-v4',
      eateryId: 'demo-student-biryani',
      eateryName: 'Student Biryani',
      date: '2024-12-31',
      rating: 4.5,
      reviewText: "New Year's biryani run. Spicy, greasy, perfect. The queue was worth it.",
      moodTags: ['Friends', 'Celebration', 'Late Night'],
      userName: 'You',
    ),
    const Visit(
      id: 'demo-v5',
      eateryId: 'demo-bbq-tonight',
      eateryName: 'Bar-B-Q Tonight',
      date: '2025-02-20',
      rating: 4.0,
      reviewText: 'Do Darya date night. Mixed grill platter for two — generous portions, great view.',
      moodTags: ['Date', 'Late Night'],
      userName: 'Friend',
      memoryNote: 'First proper date here.',
    ),
    const Visit(
      id: 'demo-v6',
      eateryId: 'demo-cafe-flo',
      eateryName: 'Cafe Flo',
      date: '2024-11-15',
      rating: 4.5,
      reviewText: 'Afternoon laptop session. Quiet corner, good wifi, pistachio latte on repeat.',
      moodTags: ['Alone', 'Study'],
      userName: 'You',
    ),
    const Visit(
      id: 'demo-v7',
      eateryId: 'demo-boat-basin',
      eateryName: 'Boat Basin Food Street',
      date: '2024-07-04',
      rating: 4.0,
      reviewText: 'Independence Day bun kabab run — chai till 1am on the basin.',
      moodTags: ['Friends', 'Late Night'],
      userName: 'Friend',
    ),
    const Visit(
      id: 'demo-v8',
      eateryId: 'demo-javed-nihari',
      eateryName: 'Javed Nihari',
      date: '2024-09-20',
      rating: 4.5,
      reviewText: 'Pre-office Burns Road nihari. Naan still warm.',
      moodTags: ['Work', 'Alone'],
      userName: 'Friend',
    ),
    const Visit(
      id: 'demo-v9',
      eateryId: 'demo-patio',
      eateryName: 'The Patio',
      date: '2024-06-18',
      rating: 4.5,
      reviewText: 'DHA brunch date. Avocado toast actually good — rare for Karachi cafés.',
      moodTags: ['Date', 'Birthday'],
      userName: 'You',
      memoryNote: 'Birthday brunch.',
    ),
    const Visit(
      id: 'demo-v10',
      eateryId: 'demo-nirala',
      eateryName: 'Nirala Sweets',
      date: '2024-05-01',
      rating: 4.0,
      reviewText: 'Eid box pickup turned into a feast. Ras malai and gulab jamun — always reliable.',
      moodTags: ['Family', 'Celebration'],
      userName: 'Friend',
    ),
    const Visit(
      id: 'demo-v11',
      eateryId: 'demo-kababjees',
      eateryName: 'Kababjees',
      date: '2024-08-12',
      rating: 3.5,
      reviewText: 'Solid BBQ but nothing new. Good for groups who cannot decide on a place.',
      moodTags: ['Friends'],
      userName: 'You',
    ),
    const Visit(
      id: 'demo-v12',
      eateryId: 'demo-seafood',
      eateryName: 'Do Darya Seafood Grill',
      date: '2024-10-05',
      rating: 4.5,
      reviewText: 'Sunset grill by the sea. Prawns off the charcoal, salt in the air.',
      moodTags: ['Date', 'Late Night'],
      userName: 'Friend',
    ),
  ];

  static Eatery? eateryById(String id) {
    try {
      return eateries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static Visit? visitById(String id) {
    try {
      return visits.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }
}
