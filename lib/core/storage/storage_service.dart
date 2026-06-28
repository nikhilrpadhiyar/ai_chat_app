import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final GetStorage _box;

  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  Future<void> erase() => _box.erase();
  bool hasData(String key) => _box.hasData(key);
}
