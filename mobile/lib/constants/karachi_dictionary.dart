class DictionaryEntry {
  const DictionaryEntry({required this.term, required this.meaning, this.example});
  final String term;
  final String meaning;
  final String? example;
}

const karachiDictionary = <DictionaryEntry>[
  DictionaryEntry(term: 'Bun kabab', meaning: 'Spiced patty in a soft bun — Karachi street staple.', example: 'Saddar late-night fuel.'),
  DictionaryEntry(term: 'Dhaba', meaning: 'Roadside desi kitchen. Loud, fast, honest.', example: 'Burns Road after midnight.'),
  DictionaryEntry(term: 'Do Darya', meaning: 'Seafront strip in DHA — BBQ rows and sunset tables.'),
  DictionaryEntry(term: 'Karahi', meaning: 'Wok-style curry cooked in front of you — sharing plate culture.'),
  DictionaryEntry(term: 'Nihari', meaning: 'Slow-cooked beef stew. Breakfast of champions.'),
  DictionaryEntry(term: 'Boat Basin', meaning: 'Clifton food street — casual outdoor seating belt.'),
  DictionaryEntry(term: 'Burns Road', meaning: 'Old Karachi food lane — falooda, nihari, kabab legends.'),
  DictionaryEntry(term: 'Chai spot', meaning: 'Not a café — a pause. Paratha optional.'),
  DictionaryEntry(term: 'Sehri', meaning: 'Pre-dawn meal in Ramadan. Nihari lines go long.'),
  DictionaryEntry(term: 'Iftar', meaning: 'Sunset break-fast. Dates, pakoras, then the real spread.'),
  DictionaryEntry(term: 'Student Biryani', meaning: 'City-wide debate topic. Everyone has a verdict.'),
  DictionaryEntry(term: 'Katakat', meaning: 'Chopped offal on the griddle — acquired taste, cult following.'),
];
