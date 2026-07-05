import 'dart:convert';
import 'package:http/http.dart' as http;

Future<({double lat, double lng})?> geocodeKarachi(String query) async {
  final q = query.trim();
  if (q.isEmpty) return null;
  final uri = Uri.parse(
    'https://nominatim.openstreetmap.org/search'
    '?q=${Uri.encodeComponent('$q, Karachi, Pakistan')}&format=json&limit=1',
  );
  try {
    final res = await http.get(uri, headers: {'User-Agent': 'DeeFoodieApp/1.0 (food archive)'}).timeout(const Duration(seconds: 6));
    if (res.statusCode != 200) return null;
    final list = jsonDecode(res.body) as List<dynamic>;
    if (list.isEmpty) return null;
    final item = list.first as Map<String, dynamic>;
    return (lat: double.parse(item['lat'] as String), lng: double.parse(item['lon'] as String));
  } catch (_) {
    return null;
  }
}
