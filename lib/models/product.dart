class Product {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final int price;
  final double rating;
  final double distance; // dalam km

  Product({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.price,
    required this.rating,
    required this.distance,
  });
}
