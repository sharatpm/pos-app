class Cart {
  final int id;
  final String title;
  final double price;
  final int barcode;
  int quantity;

  Cart({
    required this.id,
    required this.title,
    required this.price,
    required this.barcode,
    required this.quantity,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'barcode': barcode,
      'quantity': quantity,
    };
  }

  String _getQuantity() {
    return '$quantity';
  }

  void _setQuantity(int i) {
    quantity += i;
  }

  @override
  String toString() {
    return '$quantity'; //'Cart{id: $id, title: $title, price: $price, barcode: $barcode, quantity: $quantity}';
  }
}
