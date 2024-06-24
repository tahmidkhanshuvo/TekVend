import '../pages.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class ProductCartScreen extends StatefulWidget {
  const ProductCartScreen({Key? key}) : super(key: key);

  @override
  _ProductCartScreenState createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  final List<Product> _cartItems = [
    Product(name: 'Product 1', price: 10.0, imageUrl: 'lib/images/product1.png'),
    Product(name: 'Product 2', price: 15.0, imageUrl: 'lib/images/product2.png'),
    Product(name: 'Product 3', price: 20.0, imageUrl: 'lib/images/product3.png'),
  ];

  double get _totalAmount {
    return _cartItems.fold(0, (total, current) => total + (current.price * current.quantity));
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: _cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final product = _cartItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _decrementQuantity(index),
                          ),
                          Text(product.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _incrementQuantity(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeItem(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: \$${_totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add checkout logic here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.green,
                  ),
                  child: const Text('Proceed to Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
