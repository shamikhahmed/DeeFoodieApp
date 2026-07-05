/** Karachi neighborhood centroids + address helpers for archive generation */

export const AREAS = [
  'DHA', 'Clifton', 'PECHS', 'Bahadurabad', 'Gulshan-e-Iqbal', 'Gulistan-e-Jauhar',
  'Saddar', 'Burns Road', 'Tariq Road', 'Shahrah-e-Faisal', 'North Nazimabad', 'Nazimabad',
  'Federal B Area', 'Korangi', 'Malir', 'Lyari', 'Keamari', 'Scheme 33', 'Defence View',
  'Boat Basin', 'Do Darya', 'Jamshed Town', 'Landhi', 'Orangi', 'SITE Area', 'Clifton Block 2',
  'DHA Phase 6', 'DHA Phase 8', 'Buffer Zone', 'Surjani Town',
];

const CENTROIDS = {
  DHA: [24.8, 67.04],
  Clifton: [24.81, 67.03],
  'Do Darya': [24.81, 67.01],
  'Burns Road': [24.86, 67.01],
  Saddar: [24.86, 67.02],
  PECHS: [24.87, 67.06],
  'Gulshan-e-Iqbal': [24.91, 67.08],
  'Gulistan-e-Jauhar': [24.91, 67.12],
  'North Nazimabad': [24.94, 67.04],
  Lyari: [24.87, 66.99],
  Malir: [24.9, 67.2],
  Korangi: [24.82, 67.13],
  'Boat Basin': [24.82, 67.02],
  'Tariq Road': [24.87, 67.05],
  Keamari: [24.82, 66.98],
  'DHA Phase 6': [24.79, 67.06],
  'DHA Phase 8': [24.77, 67.08],
  'Clifton Block 2': [24.81, 67.025],
  Bahadurabad: [24.88, 67.07],
  Nazimabad: [24.92, 67.03],
  'Federal B Area': [24.93, 67.07],
  'Shahrah-e-Faisal': [24.88, 67.1],
  'Scheme 33': [24.9, 67.11],
  Landhi: [24.84, 67.18],
  Orangi: [24.94, 67.0],
  'SITE Area': [24.88, 66.98],
  'Jamshed Town': [24.88, 67.04],
  'Buffer Zone': [24.95, 67.06],
  'Surjani Town': [25.02, 67.08],
  'Defence View': [24.83, 67.05],
};

const STREETS = {
  'Burns Road': ['Burns Road', 'I.I. Chundrigar Road'],
  'Do Darya': ['Beach Avenue', 'Sea View Road', 'DHA Phase 8'],
  Clifton: ['Block 2 Clifton', 'Khayaban-e-Shamsheer', 'Marine Drive'],
  DHA: ['Khayaban-e-Ittehad', 'Khayaban-e-Shaheen', 'Sunset Boulevard'],
  Saddar: ['Preedy Street', 'Zaibunnisa Street', 'Empress Market Road'],
  PECHS: ['PECHS Block 2', 'Allama Iqbal Road'],
  'Boat Basin': ['Boat Basin Food Street', 'Block 5 Clifton'],
  'Tariq Road': ['Tariq Road', 'PECHS Block 3'],
  Lyari: ['Lyari Expressway Service Road', 'Chakiwara'],
  Keamari: ['Keamari Fish Harbour Road', 'Mai Kolachi Road'],
};

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
  const streets = STREETS[area] ?? ['Main Road', 'Service Lane', 'Commercial Street'];
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
  if (['Do Darya', 'Boat Basin', 'Keamari'].includes(area)) return 'assets/backgrounds/karachi_seafront_evening.jpg';
  if (['Burns Road', 'Lyari', 'Saddar', 'SITE Area'].includes(area)) return 'assets/backgrounds/karachi_food_street.jpg';
  if (['Clifton', 'DHA', 'DHA Phase 6', 'DHA Phase 8', 'Clifton Block 2', 'Defence View'].includes(area)) {
    return 'assets/backgrounds/karachi_coast_aerial.jpg';
  }
  return 'assets/backgrounds/karachi_clifton_sunset.jpg';
}
