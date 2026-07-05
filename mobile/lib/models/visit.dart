class VisitItem {
  const VisitItem({required this.name, this.type = 'food'});

  final String name;
  final String type;

  factory VisitItem.fromJson(Map<String, dynamic> json) => VisitItem(
        name: json['name'] as String,
        type: json['type'] as String? ?? 'food',
      );
}

class Visit {
  const Visit({
    required this.id,
    required this.eateryId,
    required this.eateryName,
    required this.date,
    required this.rating,
    this.reviewText,
    this.moodTags = const [],
    this.userName,
    this.memoryNote,
    this.favoriteItem,
    this.totalBill,
    this.companions,
    this.items = const [],
    this.photoUrl,
    this.areaName,
    this.photoUrls = const [],
    this.voiceNoteDataUrl,
  });

  final String id;
  final String eateryId;
  final String eateryName;
  final String date;
  final double rating;
  final String? reviewText;
  final List<String> moodTags;
  final String? userName;
  final String? memoryNote;
  final String? favoriteItem;
  final double? totalBill;
  final String? companions;
  final List<VisitItem> items;
  final String? photoUrl;
  final String? areaName;
  final List<String> photoUrls;
  final String? voiceNoteDataUrl;

  List<String> get allPhotoUrls {
    if (photoUrls.isNotEmpty) return photoUrls;
    if (photoUrl != null) return [photoUrl!];
    return const [];
  }

  Visit copyWith({
    String? id,
    String? eateryId,
    String? eateryName,
    String? date,
    double? rating,
    String? reviewText,
    List<String>? moodTags,
    String? userName,
    String? memoryNote,
    String? favoriteItem,
    double? totalBill,
    String? companions,
    List<VisitItem>? items,
    String? photoUrl,
    String? areaName,
    List<String>? photoUrls,
    String? voiceNoteDataUrl,
  }) {
    return Visit(
      id: id ?? this.id,
      eateryId: eateryId ?? this.eateryId,
      eateryName: eateryName ?? this.eateryName,
      date: date ?? this.date,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      moodTags: moodTags ?? this.moodTags,
      userName: userName ?? this.userName,
      memoryNote: memoryNote ?? this.memoryNote,
      favoriteItem: favoriteItem ?? this.favoriteItem,
      totalBill: totalBill ?? this.totalBill,
      companions: companions ?? this.companions,
      items: items ?? this.items,
      photoUrl: photoUrl ?? this.photoUrl,
      areaName: areaName ?? this.areaName,
      photoUrls: photoUrls ?? this.photoUrls,
      voiceNoteDataUrl: voiceNoteDataUrl ?? this.voiceNoteDataUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eateryId': eateryId,
        'eateryName': eateryName,
        'date': date,
        'rating': rating,
        'reviewText': reviewText,
        'moodTags': moodTags,
        'userName': userName,
        'memoryNote': memoryNote,
        'favoriteItem': favoriteItem,
        'totalBill': totalBill,
        'companions': companions,
        'items': items.map((i) => {'name': i.name, 'type': i.type}).toList(),
        'photoUrl': photoUrl,
        'areaName': areaName,
        'photoUrls': photoUrls,
        'voiceNoteDataUrl': voiceNoteDataUrl,
      };

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as String,
      eateryId: json['eateryId'] as String,
      eateryName: json['eateryName'] as String? ??
          (json['eatery'] as Map<String, dynamic>?)?['name'] as String? ??
          'Unknown',
      date: json['date'] is String
          ? json['date'] as String
          : (json['date'] as DateTime).toIso8601String(),
      rating: (json['rating'] as num).toDouble(),
      reviewText: json['reviewText'] as String?,
      moodTags: List<String>.from(json['moodTags'] ?? []),
      userName: (json['user'] as Map<String, dynamic>?)?['name'] as String?,
      memoryNote: json['memoryNote'] as String?,
      favoriteItem: json['favoriteItem'] as String?,
      totalBill: json['totalBill'] == null ? null : (json['totalBill'] as num).toDouble(),
      companions: json['companions'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((i) => VisitItem.fromJson(i as Map<String, dynamic>))
              .toList() ??
          const [],
      photoUrls: _photoUrlsFromJson(json),
      voiceNoteDataUrl: json['voiceNoteDataUrl'] as String?,
    );
  }

  static List<String> _photoUrlsFromJson(Map<String, dynamic> json) {
    final direct = json['photoUrls'];
    if (direct is List && direct.isNotEmpty) return List<String>.from(direct);
    final photos = json['photos'] as List<dynamic>?;
    if (photos != null && photos.isNotEmpty) {
      return photos.map((p) => (p as Map<String, dynamic>)['url'] as String).toList();
    }
    final single = json['photoUrl'] as String?;
    return single != null ? [single] : const [];
  }
}
