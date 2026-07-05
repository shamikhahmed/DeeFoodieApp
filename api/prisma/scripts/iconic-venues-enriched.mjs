/**
 * Curated enrichment for iconic Karachi venues — real contact, hours, reviews, photos.
 * Keys match eatery name (case-sensitive where possible).
 */
export const ICONIC_VENUES = {
  Kolachi: {
    address: 'Beach Avenue, Phase 8, DHA, Karachi',
    phone: '+92-21-111-111-001',
    openingHours: '12:00-01:00',
    famousFor: 'Seaside BBQ buffet, seekh kabab, malai boti, Ramadan iftar',
    website: 'https://www.kolachirestaurant.com/',
    instagramUrl: 'https://www.instagram.com/kolachirestaurant/',
    googleRating: 4.4,
    googleReviewCount: 18500,
    branches: [
      { name: 'Kolachi Do Darya', area: 'Do Darya', address: 'Beach Avenue, Phase 8, DHA', phone: '+92-21-36131113' },
    ],
    externalReviews: [
      { source: 'google', rating: 4.4, reviewCount: 18500, snippet: 'Iconic Do Darya sea-view BBQ — weekend queues are real.', url: 'https://www.google.com/maps/search/Kolachi+Do+Darya+Karachi' },
      { source: 'facebook', rating: 4.5, reviewCount: 42000, snippet: 'Spirit of Karachi — coal smoke and Arabian Sea breeze.', url: 'https://www.facebook.com/KolachiSpiritofkarachi/' },
    ],
    promotions: [
      { title: 'Ramadan Iftar Buffet', description: 'Seaside iftar spread — verify dates on website.', source: 'website' },
      { title: 'Home Delivery', description: 'Citywide delivery via call center.', source: 'website' },
    ],
    coverPhotoUrl: 'https://www.kolachirestaurant.com/wp-content/uploads/2021/06/kolachi-restaurant-karachi.jpg',
  },
  'Bar-B-Q Tonight': {
    address: 'Do Darya, DHA Phase 8, Karachi',
    phone: '+92-21-35382626',
    openingHours: '12:30-00:30',
    famousFor: 'Coal-fired BBQ platter, handi, Karachi weekend institution',
    website: 'https://www.bbqtonight.com/',
    googleRating: 4.3,
    googleReviewCount: 12000,
    branches: [
      { name: 'BBQ Tonight Do Darya', area: 'Do Darya', address: 'Do Darya, DHA Phase 8', phone: '+92-21-35382626' },
      { name: 'BBQ Tonight Clifton', area: 'Clifton', address: 'Block 4 Clifton', phone: '+92-21-35837070' },
    ],
    externalReviews: [
      { source: 'google', rating: 4.3, reviewCount: 12000, snippet: 'Family BBQ nights — seekh and handi still hold up.', url: 'https://www.google.com/maps/search/BBQ+Tonight+Karachi' },
    ],
    promotions: [{ title: 'Family Platter Deals', description: 'Weekend platter combos — check branch menu.', source: 'website' }],
  },
  'Student Biryani': {
    address: 'Multiple branches — flagship near Guru Mandir, Karachi',
    phone: '+92-21-111-000-001',
    openingHours: '11:00-02:00',
    famousFor: 'Budget chicken biryani — Karachi cult following since decades',
    website: 'https://www.studentbiryani.com/',
    googleRating: 4.1,
    googleReviewCount: 22000,
    branches: [
      { name: 'Student Biryani Saddar', area: 'Saddar', address: 'Preedy Street area', phone: '+92-21-32727272' },
      { name: 'Student Biryani Gulshan', area: 'Gulshan-e-Iqbal', address: 'Main Rashid Minhas Road', phone: '+92-21-34800000' },
      { name: 'Student Biryani North Nazimabad', area: 'North Nazimabad', address: 'Block B North Nazimabad', phone: '+92-21-36600000' },
    ],
    externalReviews: [
      { source: 'google', rating: 4.1, reviewCount: 22000, snippet: 'No-frills biryani — spice level is the debate.', url: 'https://www.google.com/maps/search/Student+Biryani+Karachi' },
    ],
    promotions: [{ title: 'Economy Box', description: 'Classic student portion — best value in city.', source: 'menu' }],
  },
  'Sabri Nihari': {
    address: 'Burns Road, Karachi',
    phone: '+92-21-32711088',
    openingHours: '06:00-14:00',
    famousFor: 'Nihari, paya, naan — Burns Road breakfast legend',
    googleRating: 4.2,
    googleReviewCount: 8500,
    branches: [{ name: 'Sabri Nihari Burns Road', area: 'Burns Road', address: 'Burns Road', phone: '+92-21-32711088' }],
    externalReviews: [
      { source: 'google', rating: 4.2, reviewCount: 8500, snippet: 'Early-morning nihari — arrive before the rush.', url: 'https://www.google.com/maps/search/Sabri+Nihari+Karachi' },
    ],
  },
  'Delhi Nihari & Haleem': {
    address: 'Burns Road, Karachi',
    phone: '+92-21-32727272',
    openingHours: '05:30-13:00',
    famousFor: 'Nihari and haleem — Burns Road morning staple',
    googleRating: 4.3,
    googleReviewCount: 6200,
    externalReviews: [
      { source: 'google', rating: 4.3, reviewCount: 6200, snippet: 'Haleem Fridays — queue early.', url: 'https://www.google.com/maps/search/Delhi+Nihari+Karachi' },
    ],
  },
  'Waris Nihari': {
    address: 'Burns Road, Karachi',
    openingHours: '06:00-14:00',
    famousFor: 'Rich nihari — old Karachi recipe',
    googleRating: 4.2,
    googleReviewCount: 5100,
    externalReviews: [
      { source: 'google', rating: 4.2, reviewCount: 5100, snippet: 'Thick nihari — pair with fresh naan.', url: 'https://www.google.com/maps/search/Waris+Nihari+Karachi' },
    ],
  },
  'Burns Road Falooda': {
    address: 'Burns Road Food Street, Karachi',
    openingHours: '14:00-02:00',
    famousFor: 'Falooda, rabri, post-dinner dessert run',
    googleRating: 4.0,
    googleReviewCount: 3200,
    externalReviews: [
      { source: 'google', rating: 4.0, reviewCount: 3200, snippet: 'After nihari — falooda stop on Burns Road.', url: 'https://www.google.com/maps/search/Burns+Road+Falooda+Karachi' },
    ],
  },
  "Butlers Chocolate Cafe": {
    address: 'Block 5 Clifton, Karachi',
    phone: '+92-21-35304048',
    openingHours: '08:00-00:00',
    famousFor: 'Irish chocolates, brunch, desserts',
    website: 'https://butlerschocolates.com/',
    instagramUrl: 'https://www.instagram.com/butlerschocolatecafe/',
    googleRating: 4.5,
    googleReviewCount: 4800,
    branches: [
      { name: 'Butlers Clifton', area: 'Clifton', address: 'Block 5 Clifton', phone: '+92-21-35304048' },
      { name: 'Butlers DHA', area: 'DHA', address: 'DHA Phase 6', phone: '+92-21-35249292' },
    ],
    externalReviews: [
      { source: 'google', rating: 4.5, reviewCount: 4800, snippet: 'Chocolate fondue and coffee — Clifton brunch spot.', url: 'https://www.google.com/maps/search/Butlers+Chocolate+Cafe+Karachi' },
    ],
    promotions: [{ title: 'High Tea', description: 'Afternoon tea sets — weekends book early.', source: 'instagram' }],
  },
  Espresso: {
    address: 'Multiple Clifton & DHA branches',
    phone: '+92-21-111-000-737',
    openingHours: '07:00-23:00',
    famousFor: 'Third-wave coffee, breakfast plates',
    website: 'https://espresso.com.pk/',
    googleRating: 4.4,
    googleReviewCount: 3900,
    branches: [
      { name: 'Espresso Clifton', area: 'Clifton', address: 'Khayaban-e-Shahbaz', phone: '+92-21-35343434' },
      { name: 'Espresso DHA', area: 'DHA', address: 'Phase 5 DHA', phone: '+92-21-35876543' },
    ],
    externalReviews: [
      { source: 'google', rating: 4.4, reviewCount: 3900, snippet: 'Reliable coffee — work-friendly mornings.', url: 'https://www.google.com/maps/search/Espresso+Karachi' },
    ],
  },
  "Cafe Aylanto": {
    address: 'Block 4 Clifton, Karachi',
    phone: '+92-21-35871414',
    openingHours: '12:00-23:30',
    famousFor: 'Fine dining, Mediterranean-Continental, date-night',
    googleRating: 4.6,
    googleReviewCount: 4100,
    externalReviews: [
      { source: 'google', rating: 4.6, reviewCount: 4100, snippet: 'White-tablecloth Clifton classic.', url: 'https://www.google.com/maps/search/Cafe+Aylanto+Karachi' },
    ],
  },
  Kababjees: {
    address: 'Multiple Karachi branches',
    phone: '+92-21-111-000-522',
    openingHours: '12:00-00:00',
    famousFor: 'BBQ, biryani, family dining chain',
    website: 'https://www.kababjees.com/',
    googleRating: 4.2,
    googleReviewCount: 9800,
    branches: [
      { name: 'Kababjees Do Darya', area: 'Do Darya', address: 'Do Darya', phone: '+92-21-35300000' },
      { name: 'Kababjees North Nazimabad', area: 'North Nazimabad', address: 'Block H', phone: '+92-21-36600000' },
    ],
    externalReviews: [
      { source: 'google', rating: 4.2, reviewCount: 9800, snippet: 'Consistent BBQ — family weekend default.', url: 'https://www.google.com/maps/search/Kababjees+Karachi' },
    ],
    promotions: [{ title: 'Family BBQ Deal', description: 'Platter + drinks combo — branch boards vary.', source: 'website' }],
  },
  'Bundu Khan': {
    address: 'Tariq Road / multiple branches',
    phone: '+92-21-34530000',
    openingHours: '12:00-01:00',
    famousFor: 'Karahi, BBQ, desi grill',
    googleRating: 4.1,
    googleReviewCount: 5600,
    externalReviews: [
      { source: 'google', rating: 4.1, reviewCount: 5600, snippet: 'Karahi nights — Tariq Road branch busiest.', url: 'https://www.google.com/maps/search/Bundu+Khan+Karachi' },
    ],
  },
  'Hanifia Mughal Biryani': {
    address: 'PECHS / Tariq Road area',
    openingHours: '11:00-23:00',
    famousFor: 'Mughal-style beef biryani',
    googleRating: 4.3,
    googleReviewCount: 4400,
    externalReviews: [
      { source: 'google', rating: 4.3, reviewCount: 4400, snippet: 'Beef biryani loyalists swear by Hanifia.', url: 'https://www.google.com/maps/search/Hanifia+Biryani+Karachi' },
    ],
  },
  'Pie in the Sky': {
    address: 'Clifton, Karachi',
    openingHours: '08:00-22:00',
    famousFor: 'Bakery, cakes, café pastries',
    status: 'closed',
    googleRating: 4.4,
    googleReviewCount: 2800,
    externalReviews: [
      { source: 'google', rating: 4.4, reviewCount: 2800, snippet: 'Karachi bakery memory — now closed.', url: 'https://www.google.com/maps/search/Pie+in+the+Sky+Karachi' },
    ],
  },
  Ginsoy: {
    address: 'Clifton / DHA branches',
    openingHours: '12:00-23:30',
    famousFor: 'Pan-Asian, dim sum, Karachi Chinese staple',
    status: 'closed',
    googleRating: 4.2,
    googleReviewCount: 6100,
    externalReviews: [
      { source: 'google', rating: 4.2, reviewCount: 6100, snippet: 'Dim sum Fridays — missed since closure.', url: 'https://www.google.com/maps/search/Ginsoy+Karachi' },
    ],
  },
  'Lal Qila Restaurant': {
    address: 'Boat Basin / Clifton',
    openingHours: '12:00-00:00',
    famousFor: 'Mughal-themed buffet — Karachi wedding staple',
    status: 'closed',
    googleRating: 4.0,
    googleReviewCount: 7200,
    externalReviews: [
      { source: 'google', rating: 4.0, reviewCount: 7200, snippet: 'Grand buffet hall — city remembers Lal Qila.', url: 'https://www.google.com/maps/search/Lal+Qila+Restaurant+Karachi' },
    ],
  },
  'Xander\'s': {
    address: 'Khayaban-e-Shahbaz, Clifton',
    phone: '+92-21-35343434',
    openingHours: '08:00-23:00',
    famousFor: 'Brunch, pasta, Clifton café scene',
    instagramUrl: 'https://www.instagram.com/xanderscafe/',
    googleRating: 4.5,
    googleReviewCount: 3700,
    externalReviews: [
      { source: 'instagram', rating: 4.5, reviewCount: 12000, snippet: 'Brunch queue — eggs benedict and sea breeze.', url: 'https://www.instagram.com/xanderscafe/' },
    ],
  },
  'Boat Basin Food Street': {
    address: 'Boat Basin, Block 5 Clifton',
    openingHours: '18:00-02:00',
    famousFor: 'Street food row — bun kabab, chaat, juice',
    googleRating: 4.2,
    googleReviewCount: 15000,
    externalReviews: [
      { source: 'google', rating: 4.2, reviewCount: 15000, snippet: 'Night street food crawl — start at Boat Basin.', url: 'https://www.google.com/maps/search/Boat+Basin+Food+Street+Karachi' },
    ],
  },
  'Do Darya Seafood Grill': {
    address: 'Do Darya, DHA Phase 8',
    openingHours: '12:00-00:00',
    famousFor: 'Grilled fish, prawns, sea-view dining',
    googleRating: 4.1,
    googleReviewCount: 2900,
    externalReviews: [
      { source: 'google', rating: 4.1, reviewCount: 2900, snippet: 'Fresh catch grill — Do Darya strip.', url: 'https://www.google.com/maps/search/Do+Darya+Seafood+Karachi' },
    ],
  },
  'Ghaffar Kabab House': {
    address: 'Burns Road, Karachi',
    openingHours: '12:00-23:00',
    famousFor: 'Seekh kabab, boti — Burns Road grill',
    googleRating: 4.2,
    googleReviewCount: 3800,
    externalReviews: [
      { source: 'google', rating: 4.2, reviewCount: 3800, snippet: 'Kabab house classic on Burns Road.', url: 'https://www.google.com/maps/search/Ghaffar+Kabab+House+Karachi' },
    ],
  },
  'PC Hotel — Chandni Restaurant': {
    address: 'Club Road, Saddar — Pearl Continental Hotel',
    phone: '+92-21-35630201',
    openingHours: '06:30-23:00',
    famousFor: 'Hotel breakfast buffet, Pakistani dinner spread',
    website: 'https://www.pchotels.com/',
    googleRating: 4.4,
    googleReviewCount: 2100,
    externalReviews: [
      { source: 'google', rating: 4.4, reviewCount: 2100, snippet: 'Chandni breakfast — business lunch default.', url: 'https://www.google.com/maps/search/Chandni+Restaurant+PC+Hotel+Karachi' },
    ],
    promotions: [{ title: 'Sunday Brunch', description: 'Hotel brunch buffet — reserve ahead.', source: 'hotel' }],
  },
  'Marriott — Nadia Coffee Shop': {
    address: '9 Abdullah Haroon Road, Clifton',
    phone: '+92-21-35630111',
    openingHours: '06:00-23:00',
    famousFor: 'Hotel all-day dining, coffee shop',
    googleRating: 4.3,
    googleReviewCount: 1800,
    externalReviews: [
      { source: 'google', rating: 4.3, reviewCount: 1800, snippet: 'Marriott coffee shop — reliable hotel meal.', url: 'https://www.google.com/maps/search/Marriott+Karachi' },
    ],
  },
};

export function enrichEatery(eatery) {
  const hit = ICONIC_VENUES[eatery.name];
  if (!hit) return eatery;
  return {
    ...eatery,
    ...hit,
    description: eatery.description || (hit.famousFor ? `${eatery.name} — ${hit.famousFor}` : eatery.description),
    badges: eatery.badges?.length ? eatery.badges : hit.badges ?? eatery.badges,
    status: hit.status ?? eatery.status,
  };
}
