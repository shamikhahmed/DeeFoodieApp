const areaStories = <String, String>{
  'Clifton': 'Sea breeze, Boat Basin lights, and the city\'s longest food promenade.',
  'DHA': 'Do Darya sunsets, Defence dining rooms, and late-night chai runs.',
  'Burns Road': 'Old Karachi in one lane — nihari steam, falooda lines, kabab smoke.',
  'Saddar': 'Bun kabab counters, student budgets, and century-old sweet shops.',
  'Do Darya': 'BBQ rows facing the Arabian Sea — Karachi\'s open-air dinner theatre.',
  'Tipu Sultan Road': 'Mid-city food belt — chains, cafés, and family dinner spots.',
  'North Nazimabad': 'Neighbourhood classics away from the spotlight — honest portions.',
  'Gulshan-e-Iqbal': 'University crowds, budget bites, and midnight student biryani.',
  'Bahadurabad': 'Residential strips with hidden gems and dependable desi kitchens.',
  'Zamzama': 'Café lane energy — brunch, dessert, and people-watching.',
};

String areaStory(String areaName) =>
    areaStories[areaName] ?? 'Another Karachi neighbourhood in your food archive.';
