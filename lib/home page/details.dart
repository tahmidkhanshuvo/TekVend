import '../pages.dart';
class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(product.imageUrl),
            const SizedBox(height: 16.0),
            Text(
              'Price: \$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            if (product.discountPrice < product.price)
              Text(
                'Discount Price: \$${product.discountPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16.0, color: Colors.red),
              ),
            const SizedBox(height: 16.0),
            const Text(
              'Specifications:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            for (var spec in product.specs)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(spec),
              ),
            const SizedBox(height: 16.0),
            Text(
              'Stock: ${product.stock}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(product.description),
            const SizedBox(height: 16.0),
            const Text(
              'Reviews:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            for (var review in product.reviews)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(review),
              ),
            const SizedBox(height: 16.0),
            const Text(
              'Questions:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            for (var question in product.questions)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(question),
              ),
          ],
        ),
      ),
    );
  }
}
