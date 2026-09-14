import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bearer token in Keychain via flutter_secure_storage (D-10 / DFD-P0-04).
class AuthTokenStore {
  AuthTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  static const _key = 'deefoodie_api_bearer_token';
  final FlutterSecureStorage _storage;

  Future<String?> read() => _storage.read(key: _key);

  Future<void> write(String token) => _storage.write(key: _key, value: token);

  Future<void> clear() => _storage.delete(key: _key);
}

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) => AuthTokenStore());

final authTokenProvider = FutureProvider<String?>((ref) async {
  return ref.watch(authTokenStoreProvider).read();
});
