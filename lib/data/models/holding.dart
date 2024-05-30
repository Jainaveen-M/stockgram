import 'dart:convert';

class Holdings {
  final String code;
  final String qty;
  final String total;
  Holdings({
    required this.code,
    required this.qty,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'qty': qty,
      'total': total,
    };
  }

  factory Holdings.fromMap(Map<String, dynamic> map) {
    return Holdings(
      code: map['code'] ?? '',
      qty: map['qty'] ?? '',
      total: map['total'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Holdings.fromJson(String source) =>
      Holdings.fromMap(json.decode(source));
}
