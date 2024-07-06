import '../pages.dart';

class ProductCartScreen extends StatefulWidget {
  const ProductCartScreen({Key? key}) : super(key: key);

  @override
  _ProductCartScreenState createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  final CartController cartController = Get.put(CartController());

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 0:
          Get.toNamed('/categories');
          break;
        case 1:
          Get.toNamed('/home');
          break;
        case 2:
          break;
        case 3:
          Get.toNamed('/profile');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        return cartController.cartProducts.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/empty_cart.png', height: 200),
              const SizedBox(height: 20),
              const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontFamily: 'Roboto')),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartProducts.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartProducts[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item['imageUrl'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item['name'] ?? '',
                        style: const TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Price: \$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => cartController.updateProductQuantity(index, item['quantity'] - 1),
                            ),
                            Text(
                              item['quantity'].toString(),
                              style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () => cartController.updateProductQuantity(index, item['quantity'] + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => cartController.removeProduct(index),
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
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Discount Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      prefixIcon: const Icon(Icons.discount),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey),
                  Text(
                    'Total: \$${cartController.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
              color: _selectedIndex == 0 ? Colors.green : Colors.grey,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 1 ? Colors.green : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: _selectedIndex == 2 ? Colors.green : Colors.grey,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _selectedIndex == 3 ? Colors.green : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
