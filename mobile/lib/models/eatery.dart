import 'menu_item.dart';

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
    this.avgRating,
    this.status = 'active',
    this.createdAt,
    this.lat,
    this.lng,
    this.menu,
    this.mustTryName,
    this.mustTryPrice,
    this.visitCount = 0,
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
  final double? avgRating;
  final String status;
  final DateTime? createdAt;
  final double? lat;
  final double? lng;
  final EateryMenu? menu;
  final String? mustTryName;
  final double? mustTryPrice;
  final int visitCount;

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
      avgRating: json['avgRating'] == null ? null : (json['avgRating'] as num).toDouble(),
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      lat: json['lat'] == null ? null : (json['lat'] as num).toDouble(),
      lng: json['lng'] == null ? null : (json['lng'] as num).toDouble(),
      menu: json['menu'] == null
          ? null
          : EateryMenu.fromJson(json['menu'] as Map<String, dynamic>),
      mustTryName: json['mustTryName'] as String?,
      mustTryPrice: json['mustTryPrice'] == null ? null : (json['mustTryPrice'] as num).toDouble(),
      visitCount: json['visitCount'] as int? ?? 0,
    );
  }
}
