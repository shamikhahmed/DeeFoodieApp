import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/providers.dart';

class VisitBookMemory {
  const VisitBookMemory({
    this.stickerIds = const [],
    this.photoDataUrls = const [],
    this.photoLabels = const [],
  });

  final List<String> stickerIds;
  final List<String> photoDataUrls;
  final List<String> photoLabels;

  VisitBookMemory copyWith({
    List<String>? stickerIds,
    List<String>? photoDataUrls,
    List<String>? photoLabels,
  }) {
    return VisitBookMemory(
      stickerIds: stickerIds ?? this.stickerIds,
      photoDataUrls: photoDataUrls ?? this.photoDataUrls,
      photoLabels: photoLabels ?? this.photoLabels,
    );
  }

  Map<String, dynamic> toJson() => {
        'stickerIds': stickerIds,
        'photoDataUrls': photoDataUrls,
        'photoLabels': photoLabels,
      };

  factory VisitBookMemory.fromJson(Map<String, dynamic> json) {
    final photos = (json['photoDataUrls'] as List<dynamic>? ?? []).cast<String>();
    final labels = (json['photoLabels'] as List<dynamic>? ?? []).cast<String>();
    return VisitBookMemory(
      stickerIds: (json['stickerIds'] as List<dynamic>? ?? []).cast<String>(),
      photoDataUrls: photos,
      photoLabels: labels.length == photos.length
          ? labels
          : List.filled(photos.length, 'memory'),
    );
  }
}

class VisitBookMemoryStore extends Notifier<Map<String, VisitBookMemory>> {
  static const _key = 'visit_book_memories_v1';

  @override
  Map<String, VisitBookMemory> build() {
    _load();
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      state = map.map((k, v) => MapEntry(k, VisitBookMemory.fromJson(v as Map<String, dynamic>)));
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.map((k, v) => MapEntry(k, v.toJson()))));
  }

  Future<void> _syncApi(String visitId) async {
    try {
      final online = await ref.read(apiOnlineProvider.future);
      if (!online) return;
      final mem = state[visitId];
      if (mem == null) return;
      await ref.read(apiClientProvider).updateVisit(visitId, {'bookMemory': mem.toJson()});
    } catch (_) {}
  }

  VisitBookMemory forVisit(String visitId) => state[visitId] ?? const VisitBookMemory();

  Future<void> addSticker(String visitId, String stickerId) async {
    final current = forVisit(visitId);
    if (current.stickerIds.contains(stickerId)) return;
    state = {...state, visitId: current.copyWith(stickerIds: [...current.stickerIds, stickerId])};
    await _persist();
    await _syncApi(visitId);
  }

  Future<void> removeSticker(String visitId, String stickerId) async {
    final current = forVisit(visitId);
    state = {
      ...state,
      visitId: current.copyWith(stickerIds: current.stickerIds.where((s) => s != stickerId).toList()),
    };
    await _persist();
    await _syncApi(visitId);
  }

  Future<void> addPhoto(String visitId, String dataUrl, {String label = 'memory'}) async {
    final current = forVisit(visitId);
    state = {
      ...state,
      visitId: current.copyWith(
        photoDataUrls: [...current.photoDataUrls, dataUrl],
        photoLabels: [...current.photoLabels, label],
      ),
    };
    await _persist();
    await _syncApi(visitId);
  }

  Future<void> removePhoto(String visitId, int index) async {
    final current = forVisit(visitId);
    final photos = [...current.photoDataUrls]..removeAt(index);
    final labels = [...current.photoLabels];
    if (index < labels.length) labels.removeAt(index);
    state = {...state, visitId: current.copyWith(photoDataUrls: photos, photoLabels: labels)};
    await _persist();
    await _syncApi(visitId);
  }
}

final visitBookMemoryProvider = NotifierProvider<VisitBookMemoryStore, Map<String, VisitBookMemory>>(VisitBookMemoryStore.new);
