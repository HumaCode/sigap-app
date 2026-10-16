import 'package:hive_flutter/hive_flutter.dart';

/// Offline cache service using Hive for instant offline availability
class CacheService {
  static const String boxName = 'sigap_offline_cache';
  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  static Box get box {
    if (_box == null || !_box!.isOpen) {
      throw StateError('CacheService must be initialized before use');
    }
    return _box!;
  }

  // Cache JSON data with key
  static Future<void> put(String key, dynamic value) async {
    await box.put(key, value);
    await box.put('${key}_cached_at', DateTime.now().toIso8601String());
  }

  static dynamic get(String key) {
    return box.get(key);
  }

  static DateTime? getCachedAt(String key) {
    final str = box.get('${key}_cached_at') as String?;
    if (str != null) {
      return DateTime.tryParse(str);
    }
    return null;
  }

  static Future<void> clear(String key) async {
    await box.delete(key);
    await box.delete('${key}_cached_at');
  }

  static Future<void> clearAll() async {
    await box.clear();
  }
}
