class Recipe {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final double rating;
  final double distance;
  final String discount;

  Recipe({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.rating,
    required this.distance,
    required this.discount,
  });
}
