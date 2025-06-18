import 'package:flutter/material.dart';
import 'package:food_app/screens/checkout_screen.dart';
import '../models/product.dart';
import '../models/recipe.dart';
import '../data/cart_items.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    cartNotifier.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    cartNotifier.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // Hitung quantity per item & kumpulkan unique items
    final counts = <String, int>{};
    final uniqueItems = <dynamic>[];
    for (var item in cartNotifier.items) {
      final id = (item is Product)
          ? item.id
          : (item is Recipe)
          ? item.id
          : null;
      if (id == null) continue;
      if (!counts.containsKey(id)) {
        counts[id] = 1;
        uniqueItems.add(item);
      } else {
        counts[id] = counts[id]! + 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Daftar item
          if (uniqueItems.isEmpty)
            const Expanded(child: Center(child: Text('Keranjang kosong')))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: uniqueItems.length,
                itemBuilder: (_, i) {
                  final item = uniqueItems[i];
                  final qty = counts[item.id]!;
                  final image = Image.asset(
                    item.imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                  final title = item.name;
                  final subtitle = item is Product
                      ? 'Harga: Rp ${item.price}'
                      : 'Diskon: ${item.discount}';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: image,
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(subtitle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: qty > 0
                                ? () => cartNotifier.removeItem(item)
                                : null,
                          ),
                          Text(
                            qty.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () => cartNotifier.addItem(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Tombol Checkout
          if (uniqueItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Bisa bersihkan cartNotifier.clear() di sini jika ingin reset
                    // cartNotifier.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  },
                  child: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
