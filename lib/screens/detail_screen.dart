// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/cart_screen.dart';
import '../models/cart_notifier.dart';

/// Layar detail produk yang sinkron dengan CartNotifier sebagai source of truth
class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = cartNotifier.quantityOf(widget.product.id);
    cartNotifier.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    cartNotifier.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {
      quantity = cartNotifier.quantityOf(widget.product.id);
    });
  }

  void _updateCart(int delta) {
    if (delta > 0) {
      cartNotifier.addItem(widget.product);
      _showMessage('Ditambahkan satu ${widget.product.name}');
    } else if (delta < 0 && quantity > 0) {
      cartNotifier.removeItem(widget.product);
      _showMessage('Dihapus satu ${widget.product.name}');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 800)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = cartNotifier.count;
    final imageUrl = widget.product.imagePath.startsWith('http')
        ? widget.product.imagePath
        : 'http://10.0.2.2/api_food/${widget.product.imagePath}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.product.name, overflow: TextOverflow.ellipsis),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk dengan Hero
            Hero(
              tag: 'image_${widget.product.id}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Hero(
                    tag: 'title_${widget.product.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Harga
                  Text(
                    'Harga: Rp ${widget.product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Deskripsi
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  // Kontrol jumlah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          size: 32,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _updateCart(-1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 32,
                          color: Colors.green,
                        ),
                        onPressed: () => _updateCart(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Di keranjang: $quantity',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
