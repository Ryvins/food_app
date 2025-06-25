class Product {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final int price;
  final double rating;
  final double distance;

  Product({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.price,
    required this.rating,
    required this.distance,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'].toString();
    return Product(
      id: 'p_$rawId',
      name: json['name'] as String,
      imagePath: json['image_path'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      distance: double.tryParse(json['distance'].toString()) ?? 0.0,
    );
  }
}
