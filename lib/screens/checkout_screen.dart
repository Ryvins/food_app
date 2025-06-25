import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cart_notifier.dart';
import '../models/user_prefs.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';
import 'order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  String _method = 'COD';
  String? _ewalletProvider;
  final List<String> _ewalletOptions = ['GoPay', 'OVO', 'DANA', 'ShopeePay'];

  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data dari UserPrefs
    UserPrefs.loadPrefs(); // Pastikan prefs sudah dimuat
    _nameController = TextEditingController(text: UserPrefs.name);
    _phoneController = TextEditingController(text: UserPrefs.phone);
    _addressController = TextEditingController(text: UserPrefs.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = cartNotifier;
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return AnimatedBuilder(
      animation: cart,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Review Order',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._buildOrderSummary(cart, currency),
                const Divider(height: 32),

                const Text(
                  'Nama Penerima',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan nama penerima',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama penerima wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                const Text(
                  'No. HP Penerima',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan nomor HP',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nomor HP wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Alamat Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan alamat pengiriman',
                  ),
                  maxLines: 2,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Alamat tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                RadioListTile<String>(
                  title: const Text('Cash on Delivery'),
                  value: 'COD',
                  groupValue: _method,
                  onChanged: (val) => setState(() {
                    _method = val!;
                    _ewalletProvider = null;
                  }),
                ),
                RadioListTile<String>(
                  title: const Text('E-Wallet'),
                  value: 'EWallet',
                  groupValue: _method,
                  onChanged: (val) => setState(() => _method = val!),
                ),
                if (_method == 'EWallet') ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pilih E-Wallet',
                    ),
                    items: _ewalletOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    value: _ewalletProvider,
                    onChanged: (v) => setState(() => _ewalletProvider = v),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Pilih jenis E-Wallet' : null,
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : () => _onSubmit(cart),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Place Order'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderSummary(cart, NumberFormat currency) {
    final seen = <String>{};
    final widgets = <Widget>[];
    for (var item in cart.items) {
      if (!seen.add(item.id)) continue;
      final qty = cart.quantityOf(item.id);
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('${item.name} ×$qty')),
              Text(currency.format(item.price * qty)),
            ],
          ),
        ),
      );
    }
    widgets.add(const SizedBox(height: 8));
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            currency.format(cart.totalPrice),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
    return widgets;
  }

  Future<void> _onSubmit(cart) async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _error = 'Lengkapi semua field yang diperlukan');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService().updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      await AuthService().updateAddress(_addressController.text.trim());

      await OrderService().checkout(
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _method,
        recipientName: _nameController.text.trim(),
        recipientPhone: _phoneController.text.trim(),
        ewalletProvider: _ewalletProvider,
        items: cart.items,
      );

      cart.clear();
      if (mounted)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
        );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
