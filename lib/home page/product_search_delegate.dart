import '../pages.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: _searchProducts(query),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: _searchProducts(query),
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
    );
  }

  Stream<List<Product>> _searchProducts(String query) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('searchKeywords', arrayContains: query.toLowerCase())
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }
}
