import 'package:flutter/material.dart';
import '../data/cart_items.dart';
import '../data/user_prefs.dart';
import 'order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  String _method = 'COD';
  @override
  Widget build(BuildContext cx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              UserPrefs.address.isEmpty
                  ? '– alamat belum diset –'
                  : UserPrefs.address,
            ),
            const Divider(height: 32),

            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: const Text('Cash on Delivery'),
              value: 'COD',
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v!),
            ),
            RadioListTile(
              title: const Text('E-Wallet'),
              value: 'EWallet',
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v!),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // clear cart, lalu ke history
                  cartNotifier.clear();
                  Navigator.pushReplacement(
                    cx,
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  );
                },
                child: const Text('Bayar Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
