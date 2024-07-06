import '../pages.dart';

class CheckoutPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

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
            // Add your order summary details here
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle order placement
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}