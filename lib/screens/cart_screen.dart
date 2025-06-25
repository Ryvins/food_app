import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cart_notifier.dart';
import '../models/recipe.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = cartNotifier;
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        // Unique items by id
        final seen = <String>{};
        final uniqueItems = <dynamic>[];
        for (var item in cart.items) {
          if (!seen.contains(item.id)) {
            seen.add(item.id);
            uniqueItems.add(item);
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Keranjang'),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            centerTitle: true,
            actions: [
              if (cart.count > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      cart.count.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
          body: uniqueItems.isEmpty
              ? const Center(child: Text('Keranjang kosong'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: uniqueItems.length,
                        itemBuilder: (ctx, i) {
                          final item = uniqueItems[i];
                          final qty = cart.quantityOf(item.id);
                          final price = item is Recipe
                              ? item.price
                              : item.price;
                          final subtitle = item is Recipe
                              ? '${currency.format(item.price)} • Diskon: ${item.discount}'
                              : currency.format(item.price);

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
                                child: Image.network(
                                  item.imagePath.startsWith('http')
                                      ? item.imagePath
                                      : 'http://10.0.2.2/api_food/${item.imagePath}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
                                    onPressed: () =>
                                        cartNotifier.removeItem(item),
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Subtotal: ${currency.format(cart.totalPrice)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CheckoutScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
