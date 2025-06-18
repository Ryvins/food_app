import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // dua tab: Riwayat & Penilaian
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2FA8FF),
          elevation: 0,
          toolbarHeight: 100,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Riwayat Pesanan'),
              Tab(text: 'Penilaian'),
            ],
          ),
          title: const Text(
            'Pesanan Saya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: const TabBarView(
          children: [
            _OrderList(), // daftar pesanan dengan alamat
            _ReviewList(), // daftar penilaian
          ],
        ),
      ),
    );
  }
}

// Model sederhana untuk dummy order
class _Order {
  final String id;
  final DateTime date;
  final String sellerAddress;
  final String shippingAddress;
  final List<String> items;
  final int total;
  final String status;
  const _Order({
    required this.id,
    required this.date,
    required this.sellerAddress,
    required this.shippingAddress,
    required this.items,
    required this.total,
    required this.status,
  });
}

class _OrderList extends StatelessWidget {
  const _OrderList();

  static final _dummyOrders = [
    _Order(
      id: 'ORD-001',
      date: DateTime(2025, 6, 15, 14, 30),
      sellerAddress: 'Jl. Melati No.10, Jakarta',
      shippingAddress: 'Jl. Mawar No.5, Jakarta',
      items: ['Paket Telur Asin ×2', 'Sup Telur Asin ×1'],
      total: 56000,
      status: 'Dikirim',
    ),
    _Order(
      id: 'ORD-002',
      date: DateTime(2025, 6, 10, 9, 15),
      sellerAddress: 'Jl. Kenanga No.7, Bandung',
      shippingAddress: 'Jl. Anggrek No.20, Bandung',
      items: ['Telur Asin Klasik ×3'],
      total: 60000,
      status: 'Selesai',
    ),
  ];

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext ctx) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _dummyOrders.length,
      itemBuilder: (_, i) {
        final o = _dummyOrders[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: ID & tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      o.id,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatDate(o.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: o.status == 'Dikirim'
                        ? Colors.blueAccent.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    o.status,
                    style: TextStyle(
                      color: o.status == 'Dikirim'
                          ? Colors.blueAccent
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(height: 24),

                // Alamat penjual
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.store, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dari: ${o.sellerAddress}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Alamat pengiriman
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ke: ${o.shippingAddress}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Daftar item
                ...o.items
                    .map(
                      (it) =>
                          Text('• $it', style: const TextStyle(fontSize: 14)),
                    )
                    .toList(),
                const SizedBox(height: 12),

                // Total bayar
                Text(
                  'Total: Rp ${o.total}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReviewList extends StatelessWidget {
  const _ReviewList();
  @override
  Widget build(BuildContext ctx) {
    // Stub penilaian
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.star, color: Colors.amber),
          title: Text('Paket Telur Asin'),
          subtitle: Text('★★★★☆'),
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.amber),
          title: Text('Sup Telur Asin'),
          subtitle: Text('★★★★★'),
        ),
      ],
    );
  }
}
