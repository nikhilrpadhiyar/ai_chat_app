import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static final HiveStorage _instance = HiveStorage._internal();
  factory HiveStorage() => _instance;
  HiveStorage._internal();

  Box<T> box<T>(String name) => Hive.box<T>(name);

  Future<void> put<T>(String boxName, String key, T value) async {
    await Hive.box<T>(boxName).put(key, value);
  }

  T? get<T>(String boxName, String key) => Hive.box<T>(boxName).get(key);

  Future<void> delete<T>(String boxName, String key) async {
    await Hive.box<T>(boxName).delete(key);
  }

  List<T> getAll<T>(String boxName) => Hive.box<T>(boxName).values.toList();

  Future<void> clear<T>(String boxName) async {
    await Hive.box<T>(boxName).clear();
  }
}
