// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Tentukan URL gambar: network atau default asset
    final imageUrl = product.imagePath.startsWith('http')
        ? product.imagePath
        : 'http://10.0.2.2/api_food/${product.imagePath}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero untuk transisi gambar
          Hero(
            tag: 'image_${product.id}',
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return SizedBox(
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
                errorBuilder: (context, error, stack) => SizedBox(
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

          // Detail produk
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul dengan Hero
                Hero(
                  tag: 'title_${product.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Harga
                Text(
                  'Rp ${product.price}',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                // Rating & Jarak
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${product.distance.toStringAsFixed(1)} km',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
