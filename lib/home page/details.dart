import '../pages.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = prefs.getStringList('cartItems') ?? [];

    final productMap = {
      'name': widget.product.name,
      'price': widget.product.price,
      'quantity': _quantity,
      'imageUrl': widget.product.imageUrl,
      'description': widget.product.description,
      'stock': widget.product.stock,
      'brand': widget.product.brand,
      'discountPrice': widget.product.discountPrice,
      'specs': widget.product.specs,
      'reviews': widget.product.reviews,
      'questions': widget.product.questions,
    };

    cartItems.add(json.encode(productMap));
    await prefs.setStringList('cartItems', cartItems);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.contain,
                  height: 250.0,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Product Name
            Center(
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Price, Discount Price, Stock, and Brand
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \$${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        if (widget.product.discountPrice < widget.product.price)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.red[100],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Discount Price: \$${widget.product.discountPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock: ${widget.product.stock}',
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Brand: ${widget.product.brand}',
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quantity and Buy Now Button
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Quantity Counter
                Row(
                  children: [
                    IconButton(
                      onPressed: _decrementQuantity,
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    IconButton(
                      onPressed: _incrementQuantity,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),

                // Buy Now Button
                ElevatedButton(
                  onPressed: _addToCart,
                  child: const Text('Buy Now'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),

            // Specifications
            const SizedBox(height: 32.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Specifications:',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var spec in widget.product.specs)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '- $spec',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Description
            ExpansionTile(
              title: const Text(
                'Description:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(widget.product.description),
                ),
              ],
            ),

            // Reviews
            ExpansionTile(
              title: const Text(
                'Reviews:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var review in widget.product.reviews)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(review),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Questions
            ExpansionTile(
              title: const Text(
                'Questions:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var question in widget.product.questions)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(question),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
