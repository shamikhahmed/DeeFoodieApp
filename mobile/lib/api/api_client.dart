import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/eatery.dart';
import '../models/taxonomy.dart';
import '../models/visit.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({
    this.baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:3000',
    ),
    this.userId,
  });

  final String baseUrl;
  final String? userId;

  Map<String, String> get _headers => {
        if (userId != null) 'X-User-Id': userId!,
        'Content-Type': 'application/json',
      };

  Future<bool> checkHealth() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/health'), headers: _headers)
          .timeout(const Duration(seconds: 4));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<List<Eatery>> fetchEateries({
    String? q,
    String? venueType,
    String? cuisine,
    String? area,
  }) async {
    final params = <String, String>{
      if (q != null && q.isNotEmpty) 'q': q,
      if (venueType != null) 'venueType': venueType,
      if (cuisine != null) 'cuisine': cuisine,
      if (area != null) 'area': area,
    };
    final json = await _getList('/eateries', params);
    return json.map((e) => Eatery.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Eatery> fetchEatery(String id) async {
    final res = await http
        .get(Uri.parse('$baseUrl/eateries/$id'), headers: _headers)
        .timeout(const Duration(seconds: 6));
    if (res.statusCode != 200) throw ApiException(res.statusCode, res.body);
    return Eatery.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<NamedEntry>> fetchVenueTypes() async =>
      (await _getList('/venue-types')).map((e) => NamedEntry.fromJson(e as Map<String, dynamic>)).toList();

  Future<List<NamedEntry>> fetchCuisines() async =>
      (await _getList('/cuisines')).map((e) => NamedEntry.fromJson(e as Map<String, dynamic>)).toList();

  Future<List<NamedEntry>> fetchAreas() async =>
      (await _getList('/areas')).map((e) => NamedEntry.fromJson(e as Map<String, dynamic>)).toList();

  Future<List<Visit>> fetchVisits({
    String? eateryId,
    String? userId,
    String? moodTag,
  }) async {
    final params = <String, String>{
      if (eateryId != null) 'eateryId': eateryId,
      if (userId != null) 'userId': userId,
      if (moodTag != null) 'moodTag': moodTag,
    };
    final json = await _getList('/visits', params);
    return json.map((e) => Visit.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Visit> createVisit({
    required String eateryId,
    required String date,
    required double rating,
    String? reviewText,
    List<String>? moodTags,
    String? memoryNote,
    List<Map<String, String>>? items,
    double? totalBill,
    String? favoriteItem,
    String? companions,
    List<String>? photoUrls,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/visits'),
      headers: _headers,
      body: jsonEncode({
        'eateryId': eateryId,
        'date': date,
        'rating': rating,
        if (reviewText != null) 'reviewText': reviewText,
        if (moodTags != null) 'moodTags': moodTags,
        if (memoryNote != null) 'memoryNote': memoryNote,
        if (items != null && items.isNotEmpty) 'items': items,
        if (totalBill != null) 'totalBill': totalBill,
        if (favoriteItem != null) 'favoriteItem': favoriteItem,
        if (companions != null) 'companions': companions,
        if (photoUrls != null && photoUrls.isNotEmpty) 'photoUrls': photoUrls,
      }),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw ApiException(res.statusCode, res.body);
    }
    return Visit.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Visit> updateVisit(String id, Map<String, dynamic> body) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/visits/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) throw ApiException(res.statusCode, res.body);
    return Visit.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteVisit(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/visits/$id'), headers: _headers);
    if (res.statusCode != 200 && res.statusCode != 204) throw ApiException(res.statusCode, res.body);
  }

  Future<Map<String, dynamic>> createEatery({
    required String name,
    required String areaId,
    required List<String> venueTypeIds,
    required List<String> cuisineIds,
    required double lat,
    required double lng,
    String? address,
    String? description,
    bool ignoreDuplicateWarning = false,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/eateries'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'areaId': areaId,
        'venueTypeIds': venueTypeIds,
        'cuisineIds': cuisineIds,
        'lat': lat,
        'lng': lng,
        if (address != null) 'address': address,
        if (description != null) 'description': description,
        'ignoreDuplicateWarning': ignoreDuplicateWarning,
      }),
    );
    if (res.statusCode != 200 && res.statusCode != 201) throw ApiException(res.statusCode, res.body);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<String> uploadPhoto({
    required List<int> bytes,
    String? visitId,
    String? eateryId,
    String filename = 'photo.jpg',
  }) async {
    final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/photos'));
    if (userId != null) req.headers['X-User-Id'] = userId!;
    req.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    if (visitId != null) req.fields['visitId'] = visitId;
    if (eateryId != null) req.fields['eateryId'] = eateryId;

    final streamed = await req.send().timeout(const Duration(seconds: 20));
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200 && streamed.statusCode != 201) {
      throw ApiException(streamed.statusCode, body);
    }
    final json = jsonDecode(body) as Map<String, dynamic>;
    final path = json['url'] as String;
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

  Future<List<dynamic>> _getList(String path, [Map<String, String>? params]) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params?.isNotEmpty == true ? params : null);
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) {
      throw ApiException(res.statusCode, res.body);
    }
    return jsonDecode(res.body) as List<dynamic>;
  }
}
