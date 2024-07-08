import '../pages.dart';

class CategoryProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String categoryName = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _fetchProductsByCategory(categoryName),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<Product> products = snapshot.data ?? [];
          return ProductsGrid(products: products);
        },
      ),
    );
  }

  Stream<List<Product>> _fetchProductsByCategory(String categoryName) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('searchKeywords', arrayContains: categoryName.toLowerCase())
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList());
  }
}
