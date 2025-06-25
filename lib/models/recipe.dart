class Recipe {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final double rating;
  final double distance;
  final String discount;
  final int price;

  Recipe({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.rating,
    required this.distance,
    required this.discount,
    this.price = 0,
  });

  /// Create Recipe from JSON map (API response)
  factory Recipe.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'].toString();
    return Recipe(
      id: 'r_$rawId',
      name: json['name'] as String? ?? '',
      imagePath: json['image_path'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      distance: double.tryParse(json['distance'].toString()) ?? 0.0,
      discount: json['discount'] as String? ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
    );
  }

  /// Convert Recipe to JSON map for constructing request bodies if needed
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_path': imagePath,
    'description': description,
    'rating': rating,
    'distance': distance,
    'discount': discount,
    'price': price,
  };
}
