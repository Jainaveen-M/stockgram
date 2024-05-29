import 'dart:convert';

class OrderBookRecord {
  final String price;
  final String qty;
  OrderBookRecord({
    required this.price,
    required this.qty,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'qty': qty,
    };
  }

  factory OrderBookRecord.fromMap(Map<String, dynamic> map) {
    return OrderBookRecord(
      price: map['price'] ?? '',
      qty: map['qty'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderBookRecord.fromJson(String source) =>
      OrderBookRecord.fromMap(json.decode(source));
}
