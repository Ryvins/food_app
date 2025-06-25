import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_prefs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  /// Login pakai email & password
  /// - Simpan token + isi UserPrefs
  Future<bool> login(String email, String pass) async {
    final uri = Uri.parse('$baseUrl/login.php');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': pass}),
    );

    if (resp.statusCode != 200) return false;

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = data['user'] as Map<String, dynamic>;

    // Simpan token di SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    // Fill UserPrefs
    UserPrefs.email = user['email'] as String? ?? '';
    UserPrefs.name = user['name'] as String? ?? '';
    UserPrefs.phone = user['phone'] as String? ?? '';
    UserPrefs.bio = user['bio'] as String? ?? '';
    UserPrefs.gender = user['gender'] as String? ?? '';
    UserPrefs.address = user['address'] as String? ?? '';
    if (user['dob'] != null) {
      UserPrefs.dob = DateTime.tryParse(user['dob'] as String);
    }

    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/register.php');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (resp.statusCode != 200) return false;

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = data['user'] as Map<String, dynamic>;

    // save token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    // fill in-memory prefs
    UserPrefs.name = user['name'] as String? ?? '';
    UserPrefs.email = user['email'] as String? ?? '';
    UserPrefs.phone = user['phone'] as String? ?? '';

    return true;
  }

  /// Ambil token dari SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Logout: bersihkan token + profile
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await UserPrefs.clear();
  }

  /// Update nama & no HP user
  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? bio,
    String? gender,
    String? dob,
  }) async {
    final token = await getToken();
    final uri = Uri.parse('$baseUrl/update_profile.php');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'bio': bio,
        'gender': gender,
        'dob': dob,
      }),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['success'] == true) {
        UserPrefs.name = name;
        UserPrefs.phone = phone;
        return true;
      }
    }
    return false;
  }

  /// Update alamat pengiriman user
  Future<bool> updateAddress(String newAddress) async {
    final token = await getToken();
    final uri = Uri.parse('$baseUrl/update_address.php');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'address': newAddress}),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['success'] == true) {
        UserPrefs.address = newAddress;
        // Simpan juga ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('address', newAddress);
        return true;
      }
    }
    return false;
  }
}
