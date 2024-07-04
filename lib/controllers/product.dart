import '../pages.dart' show Product;

class Product {
  final String name;
  final String description;
  final double price;
  final double discountPrice;
  final List<String> specs;
  final int stock;
  final List<String> reviews;
  final List<String> questions;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.specs,
    required this.stock,
    required this.reviews,
    required this.questions,
  });
}
