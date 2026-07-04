import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  Future<void> delete(String key) => _storage.delete(key: key);
  Future<void> deleteAll() => _storage.deleteAll();
  Future<bool> containsKey(String key) => _storage.containsKey(key: key);
}
