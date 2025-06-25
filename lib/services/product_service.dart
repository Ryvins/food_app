import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  /// Fetch products with pagination
  Future<List<Product>> fetchProducts({int page = 1, int limit = 10}) async {
    final token = await AuthService().getToken();
    // tambahkan page & limit di query string
    final uri = Uri.parse('$baseUrl/products.php').replace(
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final list = data['products'] as List<dynamic>;
      return list
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal load products: ${resp.statusCode}');
    }
  }
}
