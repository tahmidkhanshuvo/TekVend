import '../pages.dart';

class UpdateKeywordsPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final int batchSize = 1; // Adjust batch size as needed

  Future<void> updateExistingProducts() async {
    try {
      QuerySnapshot productsSnapshot = await firestore.collection('products').get();
      List<Product> productsToUpdate = [];

      for (QueryDocumentSnapshot doc in productsSnapshot.docs) {
        try {
          Product product = Product.fromFirestore(doc);
          List<String> searchKeywords = product._generateSearchKeywords();
          productsToUpdate.add(product.copyWithSearchKeywords(searchKeywords));

          // Update in batches or individually
          if (productsToUpdate.length >= batchSize) {
            await updateBatchProducts(productsToUpdate);
            productsToUpdate.clear(); // Clear batch
            print('Updated ${batchSize} products.');
          }
        } catch (e) {
          print('Error updating product with id ${doc.id}: $e');
        }
      }

      // Update any remaining products
      if (productsToUpdate.isNotEmpty) {
        await updateBatchProducts(productsToUpdate);
        print('Updated ${productsToUpdate.length} products.');
      }

      print('All products updated with search keywords.');
    } catch (e) {
      print('Error fetching or updating products: $e');
    }
  }

  Future<void> updateBatchProducts(List<Product> products) async {
    WriteBatch batch = firestore.batch();

    for (Product product in products) {
      DocumentReference docRef = firestore.collection('products').doc(product.id);
      batch.update(docRef, {'searchKeywords': product.searchKeywords});
    }

    // Commit the batch
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Keywords'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await updateExistingProducts();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Existing products updated with search keywords.')),
            );
          },
          child: Text('Update Keywords'),
        ),
      ),
    );
  }
}

class Product {
  final String id;
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
  List<String> searchKeywords;

  Product({
    required this.id,
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
    required this.searchKeywords,
  });

  factory Product.fromFirestore(QueryDocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Product(
        id: doc.id,
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
        searchKeywords: List<String>.from(data['searchKeywords'] ?? []),
      );
    } catch (e) {
      print('Error parsing product document: $e');
      throw e; // rethrow the error after logging it
    }
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
      'searchKeywords': searchKeywords,
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

  Product copyWithSearchKeywords(List<String> newSearchKeywords) {
    return Product(
      id: this.id,
      name: this.name,
      price: this.price,
      imageUrl: this.imageUrl,
      description: this.description,
      category: this.category,
      brand: this.brand,
      discountPrice: this.discountPrice,
      specs: this.specs,
      stock: this.stock,
      reviews: this.reviews,
      questions: this.questions,
      quantity: this.quantity,
      searchKeywords: newSearchKeywords,
    );
  }
}