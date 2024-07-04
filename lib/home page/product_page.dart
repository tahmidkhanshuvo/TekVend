import '../pages.dart';

class ProductPage extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'Product 1',
      description: 'Description of Product 1',
      price: 100.0,
      discountPrice: 80.0,
      specs: ['Spec 1: Value', 'Spec 2: Value'],
      stock: 10,
      reviews: ['Review 1: Good product!', 'Review 2: Excellent!'],
      questions: ['Question 1: How many colors?', 'Question 2: Waterproof?'],
    ),
    // Add more products as needed
  ];

   ProductPage({super.key}) {
     // TODO: implement ProductPage
     throw UnimplementedError();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to chat screen
          Navigator.pushNamed(context, '/chat');
        },
        child: const Icon(Icons.chat),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: products[index]),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('lib/images/product${index + 1}.jpg'),
                  ),
                  title: Text(products[index].name),
                  subtitle: Text('Price: \$${products[index].price.toStringAsFixed(2)}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
