import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/recipe.dart';
import '../screens/detail_screen.dart';
import '../screens/recipe_detail_screen.dart';
import 'category_tab.dart';
import 'product_card.dart';
import 'recipe_card.dart';

/// Area daftar produk dengan fungsi pencarian
class ProductListArea extends StatelessWidget {
  final String searchQuery;
  const ProductListArea({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    // Data sumber
    final products = <Product>[
      Product(
        id: 'telur1',
        name: 'Paket Telur Asin',
        imagePath: 'assets/images/telur1.jpg',
        description: 'Telur asin berkualitas dalam satu paket hemat',
        price: 18000,
        rating: 4.5,
        distance: 1,
      ),
      Product(
        id: 'telur2',
        name: 'Telur Asin Klasik Panggang',
        imagePath: 'assets/images/telur2.jpg',
        description: 'Telur asin klasik dengan rasa autentik',
        price: 20000,
        rating: 4.8,
        distance: 0.5,
      ),
      Product(
        id: 'telur3',
        name: 'Telur Asin Autentik',
        imagePath: 'assets/images/telur2.jpg',
        description: 'Rasa klasik yang otentik',
        price: 21000,
        rating: 4.7,
        distance: 0.7,
      ),
      Product(
        id: 'telur4',
        name: 'Telur Asin Spesial',
        imagePath: 'assets/images/telur2.jpg',
        description: 'Telur asin spesial dengan bumbu rahasia',
        price: 22000,
        rating: 4.9,
        distance: 0.3,
      ),
    ];

    final recipes = <Recipe>[
      Recipe(
        id: 'sup1',
        name: 'Sup Telur Asin Panggang',
        imagePath: 'assets/images/sup.jpg',
        description: 'Olahan hangat berempah',
        rating: 4.8,
        distance: 0.5,
        discount: 'Up to 32k discount',
      ),
      Recipe(
        id: 'sup2',
        name: 'Sup Telur Asin Spesial',
        imagePath: 'assets/images/sup.jpg',
        description: 'Olahan spesial dengan rempah pilihan',
        rating: 5.0,
        distance: 0.3,
        discount: 'Up to 40k discount',
      ),
    ];

    final q = searchQuery.toLowerCase();
    final filteredProducts = searchQuery.isEmpty
        ? products
        : products
              .where(
                (p) =>
                    p.name.toLowerCase().contains(q) ||
                    p.description.toLowerCase().contains(q),
              )
              .toList();

    final filteredRecipes = searchQuery.isEmpty
        ? recipes
        : recipes
              .where(
                (r) =>
                    r.name.toLowerCase().contains(q) ||
                    r.description.toLowerCase().contains(q),
              )
              .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Kategori Tab
        const SizedBox(height: 60, child: CategoryTabs()),
        const SizedBox(height: 16),

        // Judul Pencarian Produk
        Text(
          searchQuery.isEmpty
              ? 'Semua Produk'
              : 'Hasil Produk untuk "$searchQuery"',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // List Produk Horizontal
        if (filteredProducts.isNotEmpty)
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredProducts.length,
              itemBuilder: (ctx, i) {
                final p = filteredProducts[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(product: p),
                        ),
                      );
                    },
                    child: SizedBox(width: 160, child: ProductCard(product: p)),
                  ),
                );
              },
            ),
          )
        else
          const Center(child: Text('Produk tidak ditemukan')),

        const SizedBox(height: 24),
        const Text(
          'Sekalian sama olahannya ..',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // List Olahan Horizontal
        if (filteredRecipes.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredRecipes.length,
            itemBuilder: (ctx, i) {
              final r = filteredRecipes[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: r),
                      ),
                    );
                  },
                  child: RecipeCard(
                    id: r.id,
                    name: r.name,
                    imagePath: r.imagePath,
                    rating: r.rating,
                    distance: r.distance,
                    description: r.description,
                    discount: r.discount,
                  ),
                ),
              );
            },
          ),
        ] else ...[
          const Center(child: Text('Olahan tidak ditemukan')),
        ],
      ],
    );
  }
}
