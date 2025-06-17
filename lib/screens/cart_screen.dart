import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(cartItems[index].name),
                subtitle: Text("Rp ${cartItems[index].price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    cartItems.removeAt(index);
                    (context as Element).reassemble();
                  },
                ),
              ),
            ),
    );
  }
}
