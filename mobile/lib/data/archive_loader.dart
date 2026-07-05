import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/eatery.dart';
import '../models/menu_item.dart';
import '../models/visit.dart';
import '../constants/karachi_trails.dart';

class ArchiveData {
  const ArchiveData({
    required this.eateries,
    required this.visits,
    this.trails = const [],
  });

  final List<Eatery> eateries;
  final List<Visit> visits;
  final List<KarachiTrail> trails;
}

class ArchiveLoader {
  static ArchiveData? _cache;

  static Future<ArchiveData> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/demo/archive.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final eateries = (json['eateries'] as List<dynamic>).map((e) {
      final m = e as Map<String, dynamic>;
      final menuList = m['menu'] as List<dynamic>? ?? [];
      final menu = menuList.isEmpty
          ? null
          : EateryMenu(
              effectiveYear: 2025,
              items: menuList.map((i) => MenuItem.fromJson(i as Map<String, dynamic>)).toList(),
            );
      return Eatery(
        id: m['id'] as String,
        name: m['name'] as String,
        areaName: m['areaName'] as String?,
        venueTypes: List<String>.from(m['venueTypes'] ?? []),
        cuisines: List<String>.from(m['cuisines'] ?? []),
        badges: List<String>.from(m['badges'] ?? []),
        description: m['description'] as String?,
        coverPhotoUrl: m['coverPhotoUrl'] as String?,
        avgRating: m['avgRating'] == null ? null : (m['avgRating'] as num).toDouble(),
        lat: m['lat'] == null ? null : (m['lat'] as num).toDouble(),
        lng: m['lng'] == null ? null : (m['lng'] as num).toDouble(),
        menu: menu,
        mustTryName: m['mustTryName'] as String?,
        mustTryPrice: m['mustTryPrice'] == null ? null : (m['mustTryPrice'] as num).toDouble(),
        visitCount: m['visitCount'] as int? ?? 0,
        createdAt: m['createdAt'] == null ? null : DateTime.tryParse(m['createdAt'] as String),
        status: m['status'] as String? ?? 'active',
        phone: m['phone'] as String?,
        openingHours: m['openingHours'] as String?,
        famousFor: m['famousFor'] as String?,
        website: m['website'] as String?,
        instagramUrl: m['instagramUrl'] as String?,
        googleRating: m['googleRating'] == null ? null : (m['googleRating'] as num).toDouble(),
        googleReviewCount: m['googleReviewCount'] as int?,
        areaPhotoAsset: m['areaPhotoAsset'] as String?,
        branches: (m['branches'] as List<dynamic>?)
                ?.map((b) => EateryBranch.fromJson(b as Map<String, dynamic>))
                .toList() ??
            const [],
        externalReviews: (m['externalReviews'] as List<dynamic>?)
                ?.map((r) => ExternalReview.fromJson(r as Map<String, dynamic>))
                .toList() ??
            const [],
        promotions: (m['promotions'] as List<dynamic>?)
                ?.map((p) => EateryPromotion.fromJson(p as Map<String, dynamic>))
                .toList() ??
            const [],
        dataSource: m['dataSource'] as String?,
      );
    }).toList();

    final visits = (json['visits'] as List<dynamic>).map((v) {
      final m = v as Map<String, dynamic>;
      return Visit(
        id: m['id'] as String,
        eateryId: m['eateryId'] as String,
        eateryName: m['eateryName'] as String,
        date: m['date'] as String,
        rating: (m['rating'] as num).toDouble(),
        reviewText: m['reviewText'] as String?,
        moodTags: List<String>.from(m['moodTags'] ?? []),
        userName: m['userName'] as String?,
        memoryNote: m['memoryNote'] as String?,
        favoriteItem: m['favoriteItem'] as String?,
        totalBill: m['totalBill'] == null ? null : (m['totalBill'] as num).toDouble(),
        companions: m['companions'] as String?,
        items: (m['items'] as List<dynamic>?)
                ?.map((i) => VisitItem.fromJson(i as Map<String, dynamic>))
                .toList() ??
            const [],
        photoUrl: m['photoUrl'] as String?,
        areaName: m['areaName'] as String?,
        photoUrls: m['photoUrl'] != null ? [m['photoUrl'] as String] : const [],
      );
    }).toList();

    final trails = (json['trails'] as List<dynamic>? ?? [])
        .map((t) {
          final m = t as Map<String, dynamic>;
          return KarachiTrail(
            id: m['id'] as String,
            name: m['name'] as String,
            description: m['description'] as String,
            eateryNames: List<String>.from(m['eateryNames'] ?? []),
            emoji: m['emoji'] as String? ?? '🍽️',
          );
        })
        .toList();

    _cache = ArchiveData(eateries: eateries, visits: visits, trails: trails);
    return _cache!;
  }

  static void clearCache() => _cache = null;
}
