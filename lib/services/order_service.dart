import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/order_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  /// Checkout: terima raw cart.items, lalu map ke payload sesuai kebutuhan endpoint
  Future<int> checkout({
    required String shippingAddress,
    required String paymentMethod,
    required String recipientName,
    required String recipientPhone,
    String? ewalletProvider,
    List<dynamic>? items,
  }) async {
    final token = await AuthService().getToken() ?? '';
    final uri = Uri.parse('$baseUrl/checkout.php');

    // Map raw items ke List<Map<String,dynamic>> sesuai API
    final raw = items ?? [];
    final seenIds = <String>{};
    final mappedItems = <Map<String, dynamic>>[];
    for (var it in raw) {
      final id = it.id.toString();
      if (seenIds.add(id)) {
        final qty = raw.where((e) => e.id.toString() == id).length;
        mappedItems.add({'product_id': id, 'qty': qty});
      }
    }

    // Bangun payload
    final payload = <String, dynamic>{
      'shipping_address': shippingAddress,
      'payment_method': paymentMethod,
      'recipient_name': recipientName,
      'recipient_phone': recipientPhone,
      'items': mappedItems,
    };
    if (ewalletProvider != null && paymentMethod == 'EWallet') {
      payload['ewallet_provider'] = ewalletProvider;
    }

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode == 200) {
      final orderIdRaw = body['order_id'];
      return orderIdRaw is int
          ? orderIdRaw
          : int.tryParse(orderIdRaw.toString()) ?? 0;
    } else if (resp.statusCode == 400) {
      throw Exception(body['error']?.toString() ?? 'Gagal checkout');
    } else if (resp.statusCode == 401) {
      throw Exception('Unauthorized: Silakan login ulang');
    } else {
      throw Exception('Gagal checkout (status ${resp.statusCode})');
    }
  }

  /// Fetch riwayat pesanan user
  Future<List<OrderModel>> fetchHistory() async {
    final token = await AuthService().getToken() ?? '';
    final uri = Uri.parse('$baseUrl/orders.php');
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 200) {
      throw Exception('Gagal load order history: status ${resp.statusCode}');
    }
    final list = jsonDecode(resp.body) as List<dynamic>;
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Update status pesanan (pending → paid/completed)
  Future<bool> updateStatus(int orderId, String status) async {
    final token = await AuthService().getToken() ?? '';
    final uri = Uri.parse('$baseUrl/update_status.php');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'order_id': orderId, 'status': status}),
    );
    if (resp.statusCode == 200) return true;
    throw Exception('Gagal update status: ${resp.body}');
  }

  /// Ambil nota / receipt teks dari server
  Future<String> getReceipt(int orderId) async {
    final token = await AuthService().getToken() ?? '';
    final uri = Uri.parse(
      '$baseUrl/receipt.php',
    ).replace(queryParameters: {'order_id': orderId.toString()});
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return data['receipt'] as String? ?? '';
    }
    throw Exception('Gagal ambil nota: status ${resp.statusCode}');
  }
}
