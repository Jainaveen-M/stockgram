import 'dart:convert';

class Order {
  final int id;
  final String orderType;
  final String price;
  final String qty;
  final String total;
  final String code;
  Order({
    required this.id,
    required this.orderType,
    required this.price,
    required this.qty,
    required this.total,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderType': orderType,
      'price': price,
      'qty': qty,
      'total': total,
      'code': code,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toInt() ?? 0,
      orderType: map['orderType'] ?? '',
      price: map['price'] ?? '',
      qty: map['qty'] ?? '',
      total: map['total'] ?? '',
      code: map['code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
