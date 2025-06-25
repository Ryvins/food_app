import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';

class PaymentScreen extends StatelessWidget {
  final OrderModel order;
  const PaymentScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2FA8FF),
        title: const Text('Pembayaran'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bayar Pesanan ORD-${order.id}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total yang harus dibayar:',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              currency.format(order.total),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            if (order.paymentMethod == 'COD') ...[
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Saya Sudah Bayar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ] else ...[
              const Text(
                'Transfer ke salah satu rekening berikut:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _bankRow(context, 'Bank BCA', '1234567890'),
              _bankRow(context, 'Bank Mandiri', '0987654321'),
              _bankRow(context, 'Bank BNI', '1122334455'),
              const SizedBox(height: 24),
              Text(
                'Scan QR ${order.ewalletProvider}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Center(
                child: Image.network(
                  _qrUrl(order.ewalletProvider),
                  width: 200,
                  height: 200,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.qr_code, size: 100, color: Colors.grey),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Saya Sudah Transfer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _qrUrl(String? provider) {
    switch (provider) {
      case 'GoPay':
        return 'https://example.com/qr_gopay.png';
      case 'OVO':
        return 'https://example.com/qr_ovo.png';
      case 'DANA':
        return 'https://example.com/qr_dana.png';
      case 'ShopeePay':
        return 'https://example.com/qr_shopeepay.png';
      default:
        return '';
    }
  }
}

Widget _bankRow(BuildContext context, String bank, String account) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        const Icon(Icons.account_balance, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(child: Text('$bank : $account')),
        IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: account));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Nomor $bank disalin'),
                duration: const Duration(milliseconds: 800),
              ),
            );
          },
        ),
      ],
    ),
  );
}
