import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../models/user_prefs.dart';
import '../models/cart_notifier.dart';
import 'login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  DateTime? _pickedDob;
  String? _pickedGender;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = UserPrefs.name;
    _phoneCtrl.text = UserPrefs.phone;
    _bioCtrl.text = UserPrefs.bio;
    _addrCtrl.text = UserPrefs.address;
    _pickedDob = UserPrefs.dob;
    _pickedGender = UserPrefs.gender.isEmpty ? null : UserPrefs.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _addrCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final auth = AuthService();
      // Update profile fields
      final ok1 = await auth.updateProfile(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
        gender: _pickedGender,
        dob: _pickedDob?.toIso8601String(),
      );
      final ok2 = await auth.updateAddress(_addrCtrl.text.trim());
      if (ok1 && ok2) {
        // Simpan lokal
        UserPrefs.name = _nameCtrl.text.trim();
        UserPrefs.phone = _phoneCtrl.text.trim();
        UserPrefs.bio = _bioCtrl.text.trim();
        UserPrefs.gender = _pickedGender ?? '';
        UserPrefs.dob = _pickedDob;
        UserPrefs.address = _addrCtrl.text.trim();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      } else {
        throw Exception('Gagal memperbarui profil');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _pickedDob ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (d != null) setState(() => _pickedDob = d);
  }

  Future<void> _pickGender() async {
    final sel = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Pilih Jenis Kelamin'),
        children: ['Laki-laki', 'Perempuan'].map((g) {
          return SimpleDialogOption(
            child: Text(g),
            onPressed: () => Navigator.pop(context, g),
          );
        }).toList(),
      ),
    );
    if (sel != null) setState(() => _pickedGender = sel);
  }

  void _logout() {
    UserPrefs.clear();
    cartNotifier.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _editField({
    required String title,
    required TextEditingController ctrl,
    required int maxLines,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atur $title'),
        content: TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {}); // refresh UI
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header biru dengan avatar + info dasar
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 48, bottom: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF2FA8FF),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Text(
                    UserPrefs.initial,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xFF2FA8FF),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  UserPrefs.email,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  UserPrefs.phone,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // List setting
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Nama'),
                  subtitle: Text(_nameCtrl.text),
                  trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                  onTap: () =>
                      _editField(title: 'Nama', ctrl: _nameCtrl, maxLines: 1),
                ),
                const Divider(height: 1),

                ListTile(
                  title: const Text('Telepon'),
                  subtitle: Text(_phoneCtrl.text),
                  trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                  onTap: () => _editField(
                    title: 'Telepon',
                    ctrl: _phoneCtrl,
                    maxLines: 1,
                  ),
                ),
                const Divider(height: 1),

                ListTile(
                  title: const Text('Bio'),
                  subtitle: Text(_bioCtrl.text.isEmpty ? '-' : _bioCtrl.text),
                  trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                  onTap: () =>
                      _editField(title: 'Bio', ctrl: _bioCtrl, maxLines: 3),
                ),
                const Divider(height: 1),

                ListTile(
                  title: const Text('Alamat Pengiriman'),
                  subtitle: Text(_addrCtrl.text.isEmpty ? '-' : _addrCtrl.text),
                  trailing: const Icon(
                    Icons.edit_location,
                    color: Colors.blueAccent,
                  ),
                  onTap: () =>
                      _editField(title: 'Alamat', ctrl: _addrCtrl, maxLines: 2),
                ),
                const Divider(height: 1),

                ListTile(
                  title: const Text('Jenis Kelamin'),
                  subtitle: Text(_pickedGender ?? '-'),
                  trailing: const Icon(Icons.edit, color: Colors.blueAccent),
                  onTap: _pickGender,
                ),
                const Divider(height: 1),

                ListTile(
                  title: const Text('Tanggal Lahir'),
                  subtitle: Text(
                    _pickedDob != null
                        ? DateFormat('dd/MM/yyyy').format(_pickedDob!)
                        : '-',
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: Colors.blueAccent,
                  ),
                  onTap: _pickDob,
                ),
                const Divider(height: 1),

                if (_error != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Simpan Perubahan',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Logout', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
