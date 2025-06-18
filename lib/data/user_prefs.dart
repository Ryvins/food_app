library user_prefs;

/// Simple in-memory store for user profile
class UserPrefs {
  static String email = '';
  static String phone = '';
  static String name = ''; // kita isi dari prefix email
  static String bio = '';
  static String gender = ''; // "Laki-laki" / "Perempuan"
  static String address = ''; // "Laki-laki" / "Perempuan"
  static DateTime? dob; // tanggal lahir

  /// Derive initial for avatar (huruf pertama nama, uppercase)
  static String get initial {
    if (name.isNotEmpty) return name[0].toUpperCase();
    return '?';
  }
}
