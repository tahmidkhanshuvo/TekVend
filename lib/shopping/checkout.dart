import '../pages.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  int _selectedIndex = 2; // Initial index for the Cart page
  String? _selectedAddressId;
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _selectedAddressId = userController.addresses.isNotEmpty ? userController.addresses.first.id : null;
  }

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
          Get.toNamed('/checkout');
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
      body: Column(
        children: [
          // Address Selection
          ListTile(
            title: const Text('Shipping Address'),
            subtitle: Obx(() {
              return DropdownButton<String>(
                value: _selectedAddressId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAddressId = newValue;
                  });
                },
                items: userController.addresses.map((Address address) {
                  return DropdownMenuItem<String>(
                    value: address.id,
                    child: Text('${address.street}, ${address.city}, ${address.state}, ${address.zip}'),
                  );
                }).toList(),
              );
            }),
          ),
          // Other checkout details (e.g., payment method, order summary, etc.)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
