import 'package:adapty_flutter/adapty_flutter.dart';

typedef Coins = int;

class Product {
  Product({required this.adaptyProduct});

  final AdaptyPaywallProduct adaptyProduct;

  String get id => adaptyProduct.vendorProductId;
  double get price => adaptyProduct.price.amount;

  bool get isHighlighted => price == 19.99;

  @override
  String toString() => 'Product(id: $id, price: $price)';
}
