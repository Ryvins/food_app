// lib/data/cart_notifier.dart

import 'package:flutter/foundation.dart';
import 'product.dart';
import 'recipe.dart';

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

  /// Check if the cart contains a specific product/recipe by id
  bool contains(String id) {
    return _items.any(
      (item) =>
          (item is Product && item.id == id) ||
          (item is Recipe && item.id == id),
    );
  }

  /// Total price of all items in the cart
  double get totalPrice {
    final seen = <String>{};
    double total = 0;
    for (var item in _items) {
      if (item is Product || item is Recipe) {
        if (!seen.contains(item.id)) {
          final qty = quantityOf(item.id);
          total += item.price * qty;
          seen.add(item.id);
        }
      }
    }
    return total;
  }
}

/// Global instance of CartNotifier
final cartNotifier = CartNotifier();
