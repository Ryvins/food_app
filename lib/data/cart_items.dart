import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/recipe.dart';

/// Manages cart items with ChangeNotifier for real-time updates
class CartNotifier extends ChangeNotifier {
  final List<dynamic> _items = [];

  /// Unmodifiable view of cart items
  List<dynamic> get items => List.unmodifiable(_items);

  /// Add an item and notify listeners
  void addItem(dynamic item) {
    _items.add(item);
    notifyListeners();
  }

  /// Remove an item and notify listeners
  void removeItem(dynamic item) {
    _items.remove(item);
    notifyListeners();
  }

  /// Total count of items
  int get count => _items.length;

  /// Quantity of a specific product/recipe by id
  int quantityOf(String id) {
    return _items
        .where(
          (item) =>
              (item is Product && item.id == id) ||
              (item is Recipe && item.id == id),
        )
        .length;
  }

  /// Clear the cart and notify listeners
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Global instance of CartNotifier
final cartNotifier = CartNotifier();
