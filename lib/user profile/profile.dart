import '../pages.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    _nameController.text = 'John Doe';
    _emailController.text = 'johndoe@example.com';
    _phoneController.text = '+1234567890';
    _dobController.text = '01/01/1990';
    _genderController.text = 'Male';
    _addressController.text = '123 Main St, Springfield';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
              ),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Shipping Address'),
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
              // Save changes
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/images/profile_picture.png'), // Replace with your profile picture path
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _nameController.text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _emailController.text,
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
              subtitle: Text(_nameController.text),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(_emailController.text),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(_phoneController.text),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date of Birth'),
              subtitle: Text(_dobController.text),
            ),
            ListTile(
              leading: const Icon(Icons.wc),
              title: const Text('Gender'),
              subtitle: Text(_genderController.text),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Shipping Address'),
              subtitle: Text(_addressController.text),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editProfile,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
