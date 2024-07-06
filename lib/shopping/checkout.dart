import '../pages.dart';

class CheckoutPage extends StatelessWidget {
  final UserController userController = Get.find();

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Get.toNamed('/categories');
          break;
        case 1:
          Get.toNamed('/home');
          break;
        case 2:
        // Optional: Add logic for the current screen (CheckoutPage)
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
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownButton<Map<String, String>>(
                isExpanded: true,
                value: userController.addresses.isEmpty ? null : userController.addresses.first,
                items: userController.addresses.map((address) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: address,
                    child: Text('${address['address']}, ${address['city']}, ${address['state']}, ${address['zip']}'),
                  );
                }).toList(),
                onChanged: (newAddress) {
                  // Handle address selection
                },
              );
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Add New Address'),
                    content: AddressForm(onSave: (newAddress) {
                      userController.addNewAddress(newAddress);
                      Navigator.of(context).pop();
                    }),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Add New Address'),
            ),
            const SizedBox(height: 20),
            const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Placeholder for order summary details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Replace with your order summary details here
                    ListTile(
                      title: Text('Product 1'),
                      subtitle: Text('Quantity: 2'),
                      trailing: Text('\$20'),
                    ),
                    ListTile(
                      title: Text('Product 2'),
                      subtitle: Text('Quantity: 1'),
                      trailing: Text('\$15'),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text('Total'),
                      trailing: Text('\$35'),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            PaymentMethods(
              onPaymentConfirmed: (selectedPaymentMethod) {
                // Handle order placement with selectedPaymentMethod
              },
            ),
          ],
        ),
      ),
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
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }
}
