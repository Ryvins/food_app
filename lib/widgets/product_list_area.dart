import 'package:flutter/material.dart';
import 'category_tab.dart';
import 'product_card.dart';
import 'recipe_card.dart';
import '../screens/detail_screen.dart';

class ProductListArea extends StatelessWidget {
  const ProductListArea({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              categoryTabWithIcon(
                "Telur",
                "assets/images/icon_telur.jpg",
                true,
              ),
              categoryTabWithIcon(
                "Botok",
                "assets/images/icon_botok.jpg",
                false,
              ),
              categoryTabWithIcon(
                "Kerupuk",
                "assets/images/icon_kerupuk.jpg",
                false,
              ),
              categoryTabWithIcon("Jus", "assets/images/icon_jus.jpg", false),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailScreen(
                      name: "Paket Telur Asin",
                      imagePath: "assets/images/telur1.jpg",
                      description:
                          "Telur asin berkualitas dalam satu paket hemat",
                      price: 18000,
                      tag: "telur1",
                    ),
                  ),
                ),
                child: SizedBox(
                  width: 160,
                  child: Hero(
                    tag: "telur1",
                    child: ProductCard(
                      name: "Paket Telur Asin",
                      imagePath: "assets/images/telur1.jpg",
                      rating: 4.8,
                      distance: 0.8,
                      price: 18000,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailScreen(
                      name: "Telur Asin",
                      imagePath: "assets/images/telur2.jpg",
                      description: "Telur asin klasik dengan rasa autentik",
                      price: 20000,
                      tag: "telur2",
                    ),
                  ),
                ),
                child: SizedBox(
                  width: 160,
                  child: Hero(
                    tag: "telur2",
                    child: ProductCard(
                      name: "Telur Asin",
                      imagePath: "assets/images/telur2.jpg",
                      rating: 4.9,
                      distance: 2.1,
                      price: 20000,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Sekalian sama olahannya ..",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const RecipeCard(
          name: "Sup Telur Asin Panggang",
          imagePath: "assets/images/sup.jpg",
          rating: 4.8,
          distance: 0.5,
          description: "Minuman, telur asin",
          discount: "Up to 32k discount",
        ),
      ],
    );
  }
}
