import 'package:flutter/material.dart';
import '../data/user_prefs.dart';
import '../data/cart_items.dart';
import 'login_screen.dart';
import 'package:flutter/services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  // controllers baru:
  final _addrCtrl = TextEditingController();
  DateTime? _pickedDob;
  String? _pickedGender;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = UserPrefs.name;
    _bioCtrl.text = UserPrefs.bio;
    _addrCtrl.text = UserPrefs.address;
    _pickedDob = UserPrefs.dob;
    _pickedGender = UserPrefs.gender.isEmpty ? null : UserPrefs.gender;
  }

  Future<void> _editField({
    required String title,
    required TextEditingController ctrl,
    required VoidCallback onSave,
    int maxLines = 1,
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
              onSave();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _pickedDob ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (d != null) {
      UserPrefs.dob = d;
      setState(() => _pickedDob = d);
    }
  }

  Future<void> _pickGender() async {
    final genders = ['Laki-laki', 'Perempuan'];
    final sel = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Pilih Jenis Kelamin'),
        children: genders
            .map(
              (g) => SimpleDialogOption(
                child: Text(g),
                onPressed: () => Navigator.pop(context, g),
              ),
            )
            .toList(),
      ),
    );
    if (sel != null) {
      UserPrefs.gender = sel;
      setState(() => _pickedGender = sel);
    }
  }

  void _logout() {
    // clear prefs & cart
    UserPrefs.name = '';
    UserPrefs.email = '';
    UserPrefs.phone = '';
    UserPrefs.bio = '';
    UserPrefs.gender = '';
    UserPrefs.dob = null;
    UserPrefs.address = '';
    cartNotifier.clear();
    // kembali ke LoginScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Column(
        children: [
          // — Header biru sama seperti sebelumnya —
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
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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

          // — Daftar setting —
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Nama'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Atur Sekarang',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.edit, size: 16, color: Colors.blueAccent),
                    ],
                  ),
                  onTap: () => _editField(
                    title: 'Nama',
                    ctrl: _nameCtrl,
                    onSave: () => UserPrefs.name = _nameCtrl.text.trim(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Bio'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Atur Sekarang',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.edit, size: 16, color: Colors.blueAccent),
                    ],
                  ),
                  onTap: () => _editField(
                    title: 'Bio',
                    ctrl: _bioCtrl,
                    maxLines: 3,
                    onSave: () => UserPrefs.bio = _bioCtrl.text.trim(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Alamat'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Atur Sekarang',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.edit_location,
                        size: 16,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  onTap: () => _editField(
                    title: 'Alamat Pengiriman',
                    ctrl: _addrCtrl,
                    maxLines: 3,
                    onSave: () => UserPrefs.address = _addrCtrl.text.trim(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Jenis Kelamin'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Atur Sekarang',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.edit, size: 16, color: Colors.blueAccent),
                    ],
                  ),
                  onTap: _pickGender,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Tanggal Lahir'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Atur Sekarang',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  onTap: _pickDob,
                ),
                const Divider(height: 1),

                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
