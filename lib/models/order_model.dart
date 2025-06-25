class OrderModel {
  final int id;
  final DateTime createdAt;
  final String shippingAddress;
  final String paymentMethod;
  final String recipientName;
  final String recipientPhone;
  final String? ewalletProvider;
  final int total;
  final String status;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.recipientName,
    required this.recipientPhone,
    this.ewalletProvider,
    required this.total,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> j) {
    final idRaw = j['id'];
    final totalRaw = j['total'];
    return OrderModel(
      id: idRaw is int ? idRaw : int.tryParse(idRaw.toString()) ?? 0,
      createdAt: DateTime.parse(j['created_at'].toString()),
      shippingAddress: j['shipping_address'].toString(),
      paymentMethod: j['payment_method'].toString(),
      recipientName: j['recipient_name'].toString(),
      recipientPhone: j['recipient_phone'].toString(),
      ewalletProvider: j['ewallet_provider']?.toString(),
      total: totalRaw is int
          ? totalRaw
          : int.tryParse(totalRaw.toString()) ?? 0,
      status: j['status'].toString(),
      items: (j['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderItem {
  final String productId;
  final String name;
  final int qty;
  final int price;

  OrderItem({
    required this.productId,
    required this.name,
    required this.qty,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> j) {
    final pid = j['product_id'].toString();
    final nameRaw = j['name'] ?? '';
    final qtyRaw = j['qty'];
    final priceRaw = j['price'];
    return OrderItem(
      productId: pid,
      name: nameRaw.toString(),
      qty: qtyRaw is int ? qtyRaw : int.tryParse(qtyRaw.toString()) ?? 0,
      price: priceRaw is int
          ? priceRaw
          : int.tryParse(priceRaw.toString()) ?? 0,
    );
  }
}
