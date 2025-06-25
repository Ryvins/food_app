import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/recipe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecipeService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  /// Fetch recipes with pagination
  Future<List<Recipe>> fetchRecipes({int page = 1, int limit = 10}) async {
    final token = await AuthService().getToken();
    final uri = Uri.parse('$baseUrl/recipes.php').replace(
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
      final list = data['recipes'] as List<dynamic>;
      return list
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal load recipes: ${resp.statusCode}');
    }
  }
}
