import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static String email = '';
  static String phone = '';
  static String name = '';
  static String bio = '';
  static String gender = '';
  static String address = '';
  static DateTime? dob;

  /// Panggil di init app untuk load semua prefs
  static Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    address = prefs.getString('address') ?? '';
    phone = prefs.getString('phone') ?? '';
    // (jika perlu load token/fields lain juga)
  }

  /// Clear all user prefs (misal pas logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    email = phone = name = bio = gender = address = '';
    dob = null;
  }

  static String get initial {
    if (name.isNotEmpty) return name[0].toUpperCase();
    return '?';
  }
}
