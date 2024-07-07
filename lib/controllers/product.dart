import '../pages.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;
  final String brand;
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
      'searchKeywords': _generateSearchKeywords(),
    };
  }

  List<String> _generateSearchKeywords() {
    List<String> keywords = [];
    keywords.addAll(_getKeywordsFromString(name));
    keywords.addAll(_getKeywordsFromString(description));
    keywords.addAll(_getKeywordsFromString(category));
    keywords.addAll(_getKeywordsFromString(brand));
    return keywords.toSet().toList(); // Removing duplicates by converting to Set and back to List
  }

  List<String> _getKeywordsFromString(String input) {
    List<String> keywords = [];
    for (int i = 0; i < input.length; i++) {
      for (int j = i + 1; j <= input.length; j++) {
        keywords.add(input.substring(i, j).toLowerCase());
      }
    }
    return keywords;
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
