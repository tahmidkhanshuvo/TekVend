import '../pages.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category; // New field for category
  final String brand; // New field for brand
  double discountPrice;
  List<String> specs;
  int stock;
  List<String> reviews;
  List<String> questions;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.brand,
    this.discountPrice = 0,
    this.specs = const [],
    this.stock = 0,
    this.reviews = const [],
    this.questions = const [],
    this.quantity = 1,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      brand: data['brand'] ?? '',
      discountPrice: (data['discountPrice'] ?? 0.0).toDouble(),
      specs: List<String>.from(data['specs'] ?? []),
      stock: data['stock'] ?? 0,
      reviews: List<String>.from(data['reviews'] ?? []),
      questions: List<String>.from(data['questions'] ?? []),
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'brand': brand,
      'discountPrice': discountPrice,
      'specs': specs,
      'stock': stock,
      'reviews': reviews,
      'questions': questions,
      'quantity': quantity,
    };
  }
}

class ProductUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
      print('Product uploaded successfully');
    } catch (e) {
      print('Error uploading product: $e');
    }
  }
}

