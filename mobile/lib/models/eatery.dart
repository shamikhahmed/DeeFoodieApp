import 'menu_item.dart';

class EateryBranch {
  const EateryBranch({required this.name, required this.area, required this.address, this.phone});

  final String name;
  final String area;
  final String address;
  final String? phone;

  factory EateryBranch.fromJson(Map<String, dynamic> json) => EateryBranch(
        name: json['name'] as String,
        area: json['area'] as String,
        address: json['address'] as String,
        phone: json['phone'] as String?,
      );
}

class ExternalReview {
  const ExternalReview({
    required this.source,
    this.rating,
    this.reviewCount,
    this.snippet,
    this.url,
  });

  final String source;
  final double? rating;
  final int? reviewCount;
  final String? snippet;
  final String? url;

  factory ExternalReview.fromJson(Map<String, dynamic> json) => ExternalReview(
        source: json['source'] as String,
        rating: json['rating'] == null ? null : (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int?,
        snippet: json['snippet'] as String?,
        url: json['url'] as String?,
      );
}

class EateryPromotion {
  const EateryPromotion({required this.title, required this.description, this.source, this.validUntil});

  final String title;
  final String description;
  final String? source;
  final String? validUntil;

  factory EateryPromotion.fromJson(Map<String, dynamic> json) => EateryPromotion(
        title: json['title'] as String,
        description: json['description'] as String,
        source: json['source'] as String?,
        validUntil: json['validUntil'] as String?,
      );
}

class Eatery {
  const Eatery({
    required this.id,
    required this.name,
    required this.venueTypes,
    required this.cuisines,
    required this.badges,
    this.areaName,
    this.address,
    this.description,
    this.coverPhotoUrl,
    this.areaPhotoAsset,
    this.avgRating,
    this.status = 'active',
    this.createdAt,
    this.lat,
    this.lng,
    this.menu,
    this.mustTryName,
    this.mustTryPrice,
    this.visitCount = 0,
    this.phone,
    this.openingHours,
    this.famousFor,
    this.website,
    this.instagramUrl,
    this.googleRating,
    this.googleReviewCount,
    this.branches = const [],
    this.externalReviews = const [],
    this.promotions = const [],
    this.dataSource,
  });

  final String id;
  final String name;
  final List<String> venueTypes;
  final List<String> cuisines;
  final List<String> badges;
  final String? areaName;
  final String? address;
  final String? description;
  final String? coverPhotoUrl;
  final String? areaPhotoAsset;
  final double? avgRating;
  final String status;
  final DateTime? createdAt;
  final double? lat;
  final double? lng;
  final EateryMenu? menu;
  final String? mustTryName;
  final double? mustTryPrice;
  final int visitCount;
  final String? phone;
  final String? openingHours;
  final String? famousFor;
  final String? website;
  final String? instagramUrl;
  final double? googleRating;
  final int? googleReviewCount;
  final List<EateryBranch> branches;
  final List<ExternalReview> externalReviews;
  final List<EateryPromotion> promotions;
  final String? dataSource;

  factory Eatery.fromJson(Map<String, dynamic> json) {
    return Eatery(
      id: json['id'] as String,
      name: json['name'] as String,
      venueTypes: List<String>.from(json['venueTypes'] ?? []),
      cuisines: List<String>.from(json['cuisines'] ?? []),
      badges: List<String>.from(json['badges'] ?? []),
      areaName: (json['area'] as Map<String, dynamic>?)?['name'] as String? ?? json['areaName'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      coverPhotoUrl: json['coverPhotoUrl'] as String?,
      areaPhotoAsset: json['areaPhotoAsset'] as String?,
      avgRating: json['avgRating'] == null ? null : (json['avgRating'] as num).toDouble(),
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] == null ? null : DateTime.tryParse(json['createdAt'] as String),
      lat: json['lat'] == null ? null : (json['lat'] as num).toDouble(),
      lng: json['lng'] == null ? null : (json['lng'] as num).toDouble(),
      menu: json['menu'] == null ? null : _menuFromJson(json['menu']),
      mustTryName: json['mustTryName'] as String?,
      mustTryPrice: json['mustTryPrice'] == null ? null : (json['mustTryPrice'] as num).toDouble(),
      visitCount: json['visitCount'] as int? ?? 0,
      phone: json['phone'] as String?,
      openingHours: json['openingHours'] as String?,
      famousFor: json['famousFor'] as String?,
      website: json['website'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      googleRating: json['googleRating'] == null ? null : (json['googleRating'] as num).toDouble(),
      googleReviewCount: json['googleReviewCount'] as int?,
      branches: (json['branches'] as List<dynamic>?)
              ?.map((b) => EateryBranch.fromJson(b as Map<String, dynamic>))
              .toList() ??
          const [],
      externalReviews: (json['externalReviews'] as List<dynamic>?)
              ?.map((r) => ExternalReview.fromJson(r as Map<String, dynamic>))
              .toList() ??
          const [],
      promotions: (json['promotions'] as List<dynamic>?)
              ?.map((p) => EateryPromotion.fromJson(p as Map<String, dynamic>))
              .toList() ??
          const [],
      dataSource: json['dataSource'] as String?,
    );
  }

  static EateryMenu? _menuFromJson(dynamic menu) {
    if (menu is List) {
      return EateryMenu(
        effectiveYear: 2025,
        items: menu.map((i) => MenuItem.fromJson(i as Map<String, dynamic>)).toList(),
      );
    }
    return EateryMenu.fromJson(menu as Map<String, dynamic>);
  }
}
