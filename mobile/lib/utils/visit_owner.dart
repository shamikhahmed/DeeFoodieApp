import '../models/visit.dart';
import '../providers/profile_prefs_provider.dart';

bool canEditVisit(Visit visit, UserProfile profile) {
  final name = visit.userName?.trim();
  if (name == null || name.isEmpty) return visit.id.startsWith('local-');
  return name == profile.displayName || name == 'You' || visit.id.startsWith('local-');
}
