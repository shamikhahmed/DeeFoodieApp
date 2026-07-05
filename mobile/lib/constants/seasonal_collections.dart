class SeasonalCollection {
  const SeasonalCollection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.filterTags,
    required this.eateryNameHints,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<String> filterTags;
  final List<String> eateryNameHints;
}

const seasonalCollections = <SeasonalCollection>[
  SeasonalCollection(
    id: 'ramadan-iftar',
    title: 'Ramadan Iftar',
    subtitle: 'Sunset spreads, karahi, and the first bite after maghrib.',
    emoji: '🌙',
    filterTags: ['BBQ', 'Desi', 'Nihari', 'Dhaba'],
    eateryNameHints: ['Kolachi', 'Bar-B-Q Tonight', 'Sabri Nihari', 'Waris Nihari', 'Delhi Nihari', 'Ghaffar Kabab'],
  ),
  SeasonalCollection(
    id: 'ramadan-sehri',
    title: 'Late Sehri',
    subtitle: 'Nihari before fajr, paratha, chai — the Karachi night shift.',
    emoji: '☕',
    filterTags: ['Nihari', 'Breakfast', 'Tea Spot', 'Dhaba'],
    eateryNameHints: ['Sabri Nihari', 'Waris Nihari', 'Delhi Nihari', 'Haleem Ghar'],
  ),
  SeasonalCollection(
    id: 'mango-season',
    title: 'Mango Season',
    subtitle: 'Falooda, kulfi, rabri — when Karachi goes sweet.',
    emoji: '🥭',
    filterTags: ['Dessert', 'Desserts', 'Ice Cream Parlor'],
    eateryNameHints: ['Burns Road Falooda', 'Hafeez', 'Ginsoo'],
  ),
];
