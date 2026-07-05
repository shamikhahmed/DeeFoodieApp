import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/haptics.dart';

class ProfilePrefs {
  static const _photoKey = 'profile_avatar_url';
  static const _nameKey = 'profile_display_name';

  static Future<String?> loadPhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoKey);
  }

  static Future<String> loadDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? 'You';
  }

  static Future<void> savePhotoUrl(String? dataUrl) async {
    final prefs = await SharedPreferences.getInstance();
    if (dataUrl == null || dataUrl.isEmpty) {
      await prefs.remove(_photoKey);
    } else {
      await prefs.setString(_photoKey, dataUrl);
    }
  }

  static Future<void> saveDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      await prefs.remove(_nameKey);
    } else {
      await prefs.setString(_nameKey, trimmed);
    }
  }
}

class UserProfile {
  const UserProfile({this.photoUrl, this.displayName = 'You'});

  final String? photoUrl;
  final String displayName;
}

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    _load();
    return const UserProfile();
  }

  Future<void> _load() async {
    final photo = await ProfilePrefs.loadPhotoUrl();
    final name = await ProfilePrefs.loadDisplayName();
    state = UserProfile(photoUrl: photo, displayName: name);
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final dataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    await ProfilePrefs.savePhotoUrl(dataUrl);
    state = UserProfile(photoUrl: dataUrl, displayName: state.displayName);
    AppHaptics.success();
  }

  Future<void> removePhoto() async {
    await ProfilePrefs.savePhotoUrl(null);
    state = UserProfile(displayName: state.displayName);
    AppHaptics.light();
  }

  Future<void> setDisplayName(String name) async {
    await ProfilePrefs.saveDisplayName(name);
    state = UserProfile(photoUrl: state.photoUrl, displayName: name.trim().isEmpty ? 'You' : name.trim());
  }
}

class FriendProfile {
  const FriendProfile({this.photoUrl, this.displayName = 'Friend'});

  final String? photoUrl;
  final String displayName;
}

class FriendProfileNotifier extends Notifier<FriendProfile> {
  static const _photoKey = 'friend_avatar_url';
  static const _nameKey = 'friend_display_name';

  @override
  FriendProfile build() {
    _load();
    return const FriendProfile();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = FriendProfile(
      photoUrl: prefs.getString(_photoKey),
      displayName: prefs.getString(_nameKey) ?? 'Friend',
    );
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final dataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photoKey, dataUrl);
    state = FriendProfile(photoUrl: dataUrl, displayName: state.displayName);
    AppHaptics.success();
  }

  Future<void> setDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = name.trim().isEmpty ? 'Friend' : name.trim();
    await prefs.setString(_nameKey, trimmed);
    state = FriendProfile(photoUrl: state.photoUrl, displayName: trimmed);
  }
}

final friendProfileProvider = NotifierProvider<FriendProfileNotifier, FriendProfile>(FriendProfileNotifier.new);

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(UserProfileNotifier.new);
