class KarachiTrail {
  const KarachiTrail({
    required this.id,
    required this.name,
    required this.description,
    required this.eateryNames,
    this.emoji = '🍽️',
  });

  final String id;
  final String name;
  final String description;
  final List<String> eateryNames;
  final String emoji;
}

const karachiTrails = <KarachiTrail>[
  KarachiTrail(
    id: 'burns-road',
    name: 'Burns Road Legends',
    description: 'The old city lane where Karachi still eats like it means it.',
    emoji: '🔥',
    eateryNames: [
      'Burns Road Falooda',
      'Delhi Nihari',
      'Waris Nihari',
      'Sabri Nihari',
      'Ghaffar Kabab House',
      'Haleem Ghar Burns Road',
    ],
  ),
  KarachiTrail(
    id: 'do-darya',
    name: 'Do Darya Sunset Row',
    description: 'Sea breeze, coal smoke, and the full weekend Karachi spread.',
    emoji: '🌊',
    eateryNames: ['Kolachi', 'Bar-B-Q Tonight', 'Sajjad Restaurant', 'Kababjees', 'Pompei'],
  ),
  KarachiTrail(
    id: 'bun-kabab',
    name: 'Bun Kabab Trail',
    description: 'Street buns, chutney, and late-night fuel across the city.',
    emoji: '🥙',
    eateryNames: [
      'Bun Kabab Corner Saddar',
      'Dera Bun Kabab',
      'Jans Bun Kabab',
      'Lal Qila Bun Kabab',
    ],
  ),
  KarachiTrail(
    id: 'clifton-cafes',
    name: 'Clifton Café Circuit',
    description: 'Brunch, coffee, and dessert stops along the south shore.',
    emoji: '☕',
    eateryNames: [
      'Butlers Chocolate Café',
      'Esquires Coffee Clifton',
      'Florentine',
      'Chatterbox Cafe',
      'Pie in the Sky',
    ],
  ),
  KarachiTrail(
    id: 'biryani-crawl',
    name: 'Biryani Crawl',
    description: 'The debate never ends — log your own verdict at each stop.',
    emoji: '🍚',
    eateryNames: [
      'Student Biryani',
      'Indus Biryani',
      'Farhan Biryani',
      'Cafe Khan Biryani',
      'Jiddat Biryani',
    ],
  ),
];
