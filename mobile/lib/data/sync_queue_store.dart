import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum SyncOpType { createVisit, createEatery, updateVisit, deleteVisit }

class SyncOp {
  SyncOp({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.retries = 0,
  });

  final String id;
  final SyncOpType type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retries;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
        'retries': retries,
      };

  factory SyncOp.fromJson(Map<String, dynamic> json) => SyncOp(
        id: json['id'] as String,
        type: SyncOpType.values.byName(json['type'] as String),
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        createdAt: DateTime.parse(json['createdAt'] as String),
        retries: json['retries'] as int? ?? 0,
      );

  SyncOp withRetry() => SyncOp(
        id: id,
        type: type,
        payload: payload,
        createdAt: createdAt,
        retries: retries + 1,
      );
}

class SyncQueueStore {
  static const _key = 'offline_sync_queue';

  static Future<List<SyncOp>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key);
    if (raw == null) return [];
    return raw
        .map((s) => SyncOp.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> save(List<SyncOp> ops) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ops.map((o) => jsonEncode(o.toJson())).toList());
  }

  static Future<void> enqueue(SyncOp op) async {
    final list = await load();
    list.add(op);
    await save(list);
  }

  static Future<void> remove(String id) async {
    final list = await load();
    list.removeWhere((o) => o.id == id);
    await save(list);
  }
}
