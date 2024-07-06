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
          child: ListView(
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
              const SizedBox(height: 20),
              const Text('Addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Obx(() {
                return Column(
                  children: userController.addresses.map((address) {
                    return ListTile(
                      leading: const Icon(Icons.home),
                      title: Text('${address['address']}, ${address['city']}, ${address['state']}, ${address['zip']}'),
                    );
                  }).toList(),
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
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit Profile'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              controller: userController.nameController,
                              decoration: const InputDecoration(labelText: 'Name'),
                            ),
                            TextField(
                              controller: userController.emailController,
                              decoration: const InputDecoration(labelText: 'Email'),
                            ),
                            TextField(
                              controller: userController.phoneController,
                              decoration: const InputDecoration(labelText: 'Phone'),
                            ),
                            TextField(
                              controller: userController.dobController,
                              decoration: const InputDecoration(labelText: 'Date of Birth'),
                            ),
                            TextField(
                              controller: userController.genderController,
                              decoration: const InputDecoration(labelText: 'Gender'),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            userController.updateUserData();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: userController.selectedIndex.value,
          onTap: userController.onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
                color: userController.selectedIndex.value == 0 ? Colors.green : Colors.grey,
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: userController.selectedIndex.value == 1 ? Colors.green : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: userController.selectedIndex.value == 2 ? Colors.green : Colors.grey,
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: userController.selectedIndex.value == 3 ? Colors.green : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
        );
      }),

    );
  }
}
