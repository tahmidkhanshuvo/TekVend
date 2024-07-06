import '../pages.dart';

class UserProfileScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: userController.signOut,
          ),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: userController.pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userController.profileImageUrl.value == 'default_image_url'
                        ? const AssetImage('lib/images/default_profile.png')
                        : NetworkImage(userController.profileImageUrl.value) as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  userController.nameController.text,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  userController.emailController.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Name'),
                subtitle: Text(userController.nameController.text),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(userController.emailController.text),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: Text(userController.phoneController.text),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date of Birth'),
                subtitle: Text(userController.dobController.text),
              ),
              ListTile(
                leading: const Icon(Icons.wc),
                title: const Text('Gender'),
                subtitle: Text(userController.genderController.text),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Shipping Address'),
                subtitle: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...userController.addresses.map((address) => ListTile(
                        title: Text(address.street),
                        subtitle: Text('${address.city}, ${address.state}, ${address.zip}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                userController.editAddress(address);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                userController.deleteAddress(address.id);
                              },
                            ),
                          ],
                        ),
                      )),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          userController.addNewAddress();
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: userController.selectedIndex.value,
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
          onTap: userController.onItemTapped,
        );
      }),
    );
  }
}
