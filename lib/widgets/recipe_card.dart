import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recipe.dart';

/// Card untuk menampilkan recipe dengan network image, harga, Hero transition,
/// serta loading/error handling
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Tentukan URL gambar: network atau default asset
    final imageUrl = recipe.imagePath.startsWith('http')
        ? recipe.imagePath
        : 'http://10.0.2.2/api_food/${recipe.imagePath}';

    // Format mata uang
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 300,
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero untuk gambar
            Hero(
              tag: 'recipe_image_${recipe.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      width: 100,
                      height: 140,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => SizedBox(
                    width: 100,
                    height: 140,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Detail teks
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating & Jarak
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.distance.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    // Judul dengan Hero
                    Hero(
                      tag: 'recipe_title_${recipe.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    // Harga
                    Text(
                      currency.format(recipe.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),

                    // Deskripsi
                    Text(
                      recipe.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Diskon
                    if (recipe.discount.isNotEmpty)
                      Text(
                        recipe.discount,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
