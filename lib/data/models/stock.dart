import 'dart:convert';

class Stock {
  String name;
  String code;
  String price;
  String img;
  Stock({
    required this.name,
    required this.code,
    required this.price,
    required this.img,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'price': price,
      'img': img,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      price: map['price'] ?? '',
      img: map['img'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Stock.fromJson(String source) => Stock.fromMap(json.decode(source));
}
