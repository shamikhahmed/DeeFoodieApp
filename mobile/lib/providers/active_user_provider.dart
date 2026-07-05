import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ActiveArchiveUser { you, friend }

class ActiveUserNotifier extends Notifier<ActiveArchiveUser> {
  static const _key = 'active_archive_user';

  @override
  ActiveArchiveUser build() {
    _load();
    return ActiveArchiveUser.you;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == 'friend') state = ActiveArchiveUser.friend;
  }

  Future<void> set(ActiveArchiveUser user) async {
    state = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, user == ActiveArchiveUser.friend ? 'friend' : 'you');
  }

  void toggle() => set(state == ActiveArchiveUser.you ? ActiveArchiveUser.friend : ActiveArchiveUser.you);

  String get displayName => state == ActiveArchiveUser.you ? 'You' : 'Friend';
}

final activeUserProvider = NotifierProvider<ActiveUserNotifier, ActiveArchiveUser>(ActiveUserNotifier.new);
