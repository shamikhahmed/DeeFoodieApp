/** Karachi neighborhoods — centroids, addresses, free photo mapping */

export const AREAS = [
  // South / Defence / Sea
  'DHA', 'DHA Phase 6', 'DHA Phase 8', 'DHA City', 'Defence View', 'Clifton', 'Clifton Block 2',
  'Clifton Block 4', 'Zamzama', 'Boat Basin', 'Do Darya', 'Keamari', 'Kemari Town', 'Manora',
  'Ibrahim Hyderi', 'Hawksbay', 'French Beach', 'Port Grand',
  // Central / Old City
  'Saddar', 'Burns Road', 'Kharadar', 'Mithadar', 'Ranchore Line', 'Civil Lines', 'PIDC',
  'II Chundrigar', 'Soldier Bazaar', 'Garden East', 'Garden West', 'Lyari', 'Machar Colony',
  'SITE Area', 'Mauripur', 'Golimar',
  // East
  'PECHS', 'Tariq Road', 'Bahadurabad', 'Jamshed Town', 'Gulshan-e-Iqbal', 'Gulistan-e-Jauhar',
  'Gulshan-e-Maymar', 'Gulzar-e-Hijri', 'Safoora', 'Shahrah-e-Faisal', 'Scheme 33', 'Model Colony',
  'Shah Faisal Colony', 'Malir', 'Malir Cantonment', 'Landhi', 'Korangi', 'Korangi Creek',
  'Korangi Industrial Area', 'Super Highway',
  // North / West
  'North Nazimabad', 'Nazimabad', 'Federal B Area', 'Buffer Zone', 'Surjani Town', 'Orangi',
  'New Karachi', 'Baldia Town', 'Liaquatabad', 'Ayesha Manzil', 'Water Pump', 'Metroville',
  'Bahria Town Karachi',
];

export const CENTROIDS = {
  DHA: [24.8, 67.04],
  'DHA Phase 6': [24.79, 67.06],
  'DHA Phase 8': [24.77, 67.08],
  'DHA City': [24.92, 67.18],
  'Defence View': [24.83, 67.05],
  Clifton: [24.81, 67.03],
  'Clifton Block 2': [24.81, 67.025],
  'Clifton Block 4': [24.805, 67.028],
  Zamzama: [24.808, 67.035],
  'Boat Basin': [24.82, 67.02],
  'Do Darya': [24.81, 67.01],
  Keamari: [24.82, 66.98],
  'Kemari Town': [24.815, 66.975],
  Manora: [24.8, 66.94],
  'Ibrahim Hyderi': [24.79, 67.02],
  Hawksbay: [24.86, 66.88],
  'French Beach': [24.87, 66.86],
  'Port Grand': [24.84, 66.99],
  Saddar: [24.86, 67.02],
  'Burns Road': [24.86, 67.01],
  Kharadar: [24.855, 67.005],
  Mithadar: [24.852, 67.008],
  'Ranchore Line': [24.858, 67.012],
  'Civil Lines': [24.865, 67.03],
  PIDC: [24.86, 67.025],
  'II Chundrigar': [24.848, 67.002],
  'Soldier Bazaar': [24.87, 67.035],
  'Garden East': [24.875, 67.04],
  'Garden West': [24.872, 67.038],
  Lyari: [24.87, 66.99],
  'Machar Colony': [24.825, 66.975],
  'SITE Area': [24.88, 66.98],
  Mauripur: [24.895, 66.96],
  Golimar: [24.905, 67.015],
  PECHS: [24.87, 67.06],
  'Tariq Road': [24.87, 67.05],
  Bahadurabad: [24.88, 67.07],
  'Jamshed Town': [24.88, 67.04],
  'Gulshan-e-Iqbal': [24.91, 67.08],
  'Gulistan-e-Jauhar': [24.91, 67.12],
  'Gulshan-e-Maymar': [24.935, 67.115],
  'Gulzar-e-Hijri': [24.945, 67.09],
  Safoora: [24.928, 67.105],
  'Shahrah-e-Faisal': [24.88, 67.1],
  'Scheme 33': [24.9, 67.11],
  'Model Colony': [24.895, 67.125],
  'Shah Faisal Colony': [24.885, 67.145],
  Malir: [24.9, 67.2],
  'Malir Cantonment': [24.915, 67.21],
  Landhi: [24.84, 67.18],
  Korangi: [24.82, 67.13],
  'Korangi Creek': [24.805, 67.125],
  'Korangi Industrial Area': [24.815, 67.14],
  'Super Highway': [24.96, 67.15],
  'North Nazimabad': [24.94, 67.04],
  Nazimabad: [24.92, 67.03],
  'Federal B Area': [24.93, 67.07],
  'Buffer Zone': [24.95, 67.06],
  'Surjani Town': [25.02, 67.08],
  Orangi: [24.94, 67.0],
  'New Karachi': [24.98, 67.07],
  'Baldia Town': [24.93, 66.95],
  Liaquatabad: [24.9, 67.045],
  'Ayesha Manzil': [24.915, 67.05],
  'Water Pump': [24.908, 67.055],
  Metroville: [24.905, 67.065],
  'Bahria Town Karachi': [25.05, 67.22],
};

const STREETS = {
  'Burns Road': ['Burns Road', 'I.I. Chundrigar Road'],
  Kharadar: ['Kharadar Bazar', 'Bolton Market'],
  Mithadar: ['Mithadar Road', 'Lea Market'],
  'Do Darya': ['Beach Avenue', 'Sea View Road', 'DHA Phase 8'],
  Clifton: ['Block 2 Clifton', 'Khayaban-e-Shamsheer', 'Marine Drive'],
  Zamzama: ['Zamzama Lane', 'Khayaban-e-Shamsheer'],
  DHA: ['Khayaban-e-Ittehad', 'Khayaban-e-Shaheen', 'Sunset Boulevard'],
  Saddar: ['Preedy Street', 'Zaibunnisa Street', 'Empress Market Road'],
  PECHS: ['PECHS Block 2', 'Allama Iqbal Road'],
  'Boat Basin': ['Boat Basin Food Street', 'Block 5 Clifton'],
  'Tariq Road': ['Tariq Road', 'PECHS Block 3'],
  Lyari: ['Lyari Expressway Service Road', 'Chakiwara'],
  Keamari: ['Keamari Fish Harbour Road', 'Mai Kolachi Road'],
  Liaquatabad: ['Liaquatabad No. 10', 'Main Liaquatabad Road'],
  'Gulshan-e-Iqbal': ['Rashid Minhas Road', 'University Road'],
  'North Nazimabad': ['Block H North Nazimabad', 'Nagan Chowrangi'],
  'Port Grand': ['West Wharf', 'Mai Kolachi Road'],
  'Bahria Town Karachi': ['Bahria Town Precinct 1', 'Jinnah Avenue'],
};

const SEA_AREAS = new Set([
  'Do Darya', 'Boat Basin', 'Keamari', 'Kemari Town', 'Manora', 'Ibrahim Hyderi',
  'Hawksbay', 'French Beach', 'Port Grand', 'Clifton', 'Clifton Block 2', 'Clifton Block 4',
  'Zamzama', 'DHA', 'DHA Phase 6', 'DHA Phase 8', 'Defence View',
]);

const OLD_CITY_AREAS = new Set([
  'Burns Road', 'Saddar', 'Kharadar', 'Mithadar', 'Ranchore Line', 'Civil Lines', 'PIDC',
  'II Chundrigar', 'Soldier Bazaar', 'Garden East', 'Garden West', 'Lyari', 'Machar Colony',
  'SITE Area', 'Mauripur', 'Golimar',
]);

export function coord(area, i = 0) {
  const [lat, lng] = CENTROIDS[area] ?? [24.86, 67.05];
  const jitter = ((i % 23) - 11) * 0.0018;
  return { lat: +(lat + jitter).toFixed(4), lng: +(lng + jitter * 1.1).toFixed(4) };
}

export function nearestArea(lat, lng) {
  let best = 'Saddar';
  let bestD = Infinity;
  for (const [area, [aLat, aLng]] of Object.entries(CENTROIDS)) {
    const d = (lat - aLat) ** 2 + (lng - aLng) ** 2;
    if (d < bestD) {
      bestD = d;
      best = area;
    }
  }
  return best;
}

export function formatAddress(area, name, i = 0) {
  const streets = STREETS[area] ?? ['Main Road', 'Service Lane', 'Commercial Street', 'Market Road'];
  const street = streets[i % streets.length];
  const plot = 10 + (i % 180);
  return `Plot ${plot}, ${street}, ${area}, Karachi`;
}

export function phoneFor(area, i = 0) {
  const areaCode = { 'Do Darya': '21', Clifton: '21', DHA: '21', Saddar: '21' }[area] ?? '21';
  const suffix = String(3000000 + (i * 7919) % 7000000).padStart(7, '0');
  return `+92-${areaCode}-${suffix.slice(0, 3)}-${suffix.slice(3)}`;
}

export function hoursFor(venueTypes) {
  if (venueTypes?.includes('Cafe') || venueTypes?.includes('Tea Spot')) return '07:00-23:00';
  if (venueTypes?.includes('Street Food') || venueTypes?.includes('Dhaba')) return '12:00-02:00';
  if (venueTypes?.includes('Fast Food')) return '10:00-00:00';
  return '12:00-23:30';
}

export function areaPhotoAsset(area) {
  if (SEA_AREAS.has(area)) return 'assets/backgrounds/karachi_seafront_evening.jpg';
  if (OLD_CITY_AREAS.has(area)) return 'assets/backgrounds/karachi_food_street.jpg';
  if (['Clifton', 'DHA', 'DHA Phase 6', 'DHA Phase 8', 'Defence View', 'Zamzama'].includes(area)) {
    return 'assets/backgrounds/karachi_coast_aerial.jpg';
  }
  return 'assets/backgrounds/karachi_clifton_sunset.jpg';
}

export function areaPhotoGroup(area) {
  if (SEA_AREAS.has(area)) return 'sea';
  if (OLD_CITY_AREAS.has(area)) return 'old-city';
  return 'east';
}
