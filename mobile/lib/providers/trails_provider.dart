import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/karachi_trails.dart';
import '../data/archive_loader.dart';

final archiveTrailsProvider = FutureProvider<List<KarachiTrail>>((ref) async {
  final archive = await ArchiveLoader.load();
  return archive.trails.isNotEmpty ? archive.trails : karachiTrails;
});
