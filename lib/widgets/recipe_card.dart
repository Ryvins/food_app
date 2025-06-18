import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String id;
  final String name;
  final String imagePath;
  final double rating;
  final double distance;
  final String description;
  final String discount;

  const RecipeCard({
    super.key,
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.rating,
    required this.distance,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380, // batas lebar
      height: 120, // batas tinggi
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dengan Hero
            Hero(
              tag: id,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  height: 120,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Kolom isi teks
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating dan lokasi
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${distance.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    // Judul dengan Hero
                    Hero(
                      tag: '${id}_title',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Deskripsi dan diskon
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      discount,
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
