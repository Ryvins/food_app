// lib/widgets/product_list_area.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/recipe.dart';
import '../services/product_service.dart';
import '../services/recipe_service.dart';
import '../screens/detail_screen.dart';
import '../screens/recipe_detail_screen.dart';
import 'product_card.dart';
import 'recipe_card.dart';

/// Area daftar produk (horizontal) dengan infinite scroll dan olahan (vertical) dengan auto-load saat scroll down
class ProductListArea extends StatefulWidget {
  final String searchQuery;
  const ProductListArea({super.key, this.searchQuery = ''});

  @override
  _ProductListAreaState createState() => _ProductListAreaState();
}

class _ProductListAreaState extends State<ProductListArea> {
  final _productService = ProductService();
  final _recipeService = RecipeService();

  // Product pagination
  final List<Product> _products = [];
  int _productPage = 1;
  bool _loadingProducts = false;
  bool _hasMoreProducts = true;
  late final ScrollController _prodController;

  // Recipe pagination
  final List<Recipe> _recipes = [];
  int _recipePage = 1;
  bool _loadingRecipes = false;
  bool _hasMoreRecipes = true;
  late final ScrollController _mainController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _prodController = ScrollController()..addListener(_onProductScroll);
    _mainController = ScrollController()..addListener(_onRecipeScroll);

    // Load initial data
    _loadProducts();
    _loadRecipes();
  }

  @override
  void dispose() {
    _prodController.removeListener(_onProductScroll);
    _mainController.removeListener(_onRecipeScroll);
    _prodController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  void _onProductScroll() {
    if (_prodController.position.pixels >=
            _prodController.position.maxScrollExtent - 100 &&
        !_loadingProducts &&
        _hasMoreProducts) {
      _loadProducts();
    }
  }

  void _onRecipeScroll() {
    if (_mainController.position.pixels >=
            _mainController.position.maxScrollExtent - 200 &&
        !_loadingRecipes &&
        _hasMoreRecipes) {
      _loadRecipes();
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _loadingProducts = true);
    try {
      final fetched = await _productService.fetchProducts(page: _productPage);
      setState(() {
        if (fetched.isEmpty) {
          _hasMoreProducts = false;
        } else {
          _productPage++;
          _products.addAll(fetched);
        }
      });
    } finally {
      setState(() => _loadingProducts = false);
    }
  }

  Future<void> _loadRecipes() async {
    setState(() => _loadingRecipes = true);
    try {
      final fetched = await _recipeService.fetchRecipes(page: _recipePage);
      setState(() {
        if (fetched.isEmpty) {
          _hasMoreRecipes = false;
        } else {
          _recipePage++;
          _recipes.addAll(fetched);
        }
      });
    } finally {
      setState(() => _loadingRecipes = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.searchQuery.toLowerCase();

    // Filtered lists
    final filteredProducts = _products
        .where(
          (p) =>
              query.isEmpty ||
              p.name.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query),
        )
        .toList();

    final filteredRecipes = _recipes
        .where(
          (r) =>
              query.isEmpty ||
              r.name.toLowerCase().contains(query) ||
              r.description.toLowerCase().contains(query),
        )
        .toList();

    return ListView(
      controller: _mainController,
      padding: const EdgeInsets.all(16),
      children: [
        // Produk section
        Text(
          widget.searchQuery.isEmpty
              ? 'Semua Produk'
              : 'Hasil Produk untuk "${widget.searchQuery}"',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Empty message if no products
        if (filteredProducts.isEmpty && !_loadingProducts)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Produk tidak ditemukan')),
          )
        else
          SizedBox(
            height: 260,
            child: ListView.builder(
              controller: _prodController,
              scrollDirection: Axis.horizontal,
              itemCount: filteredProducts.length + (_hasMoreProducts ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i < filteredProducts.length) {
                  final p = filteredProducts[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(product: p),
                        ),
                      ),
                      child: SizedBox(
                        width: 160,
                        child: ProductCard(product: p),
                      ),
                    ),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        const Divider(),
        const SizedBox(height: 16),
        // Recipe section
        Text(
          widget.searchQuery.isEmpty
              ? 'Sekalian sama olahannya ..'
              : 'Hasil Olahan untuk "${widget.searchQuery}"',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Empty message if no recipes
        if (filteredRecipes.isEmpty && !_loadingRecipes)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Olahan tidak ditemukan')),
          )
        else
          ...filteredRecipes.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: r),
                  ),
                ),
                child: RecipeCard(recipe: r),
              ),
            ),
          ),
        // Loading indicator for recipes
        if (_hasMoreRecipes)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CircularProgressIndicator(),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
