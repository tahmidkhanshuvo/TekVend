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

  User? _currentUser;
  DocumentSnapshot? _userData;
  String _profileImageUrl = 'default_image_url'; // Default image URL

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
      setState(() {
        _userData = userData;
        _nameController.text = '${userData['firstName']} ${userData['lastName']}';
        _emailController.text = userData['email'];
        _phoneController.text = userData['phoneNumber'];
        _dobController.text = userData['dob'] ?? ''; // Assuming 'dob' is stored in Firestore
        _genderController.text = userData['gender'] ?? ''; // Assuming 'gender' is stored in Firestore
        _addressController.text = userData['address'] ?? ''; // Assuming 'address' is stored in Firestore
        _profileImageUrl = userData['profileImageUrl'] ?? 'default_image_url';
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).update({
        'firstName': _nameController.text.split(' ')[0],
        'lastName': _nameController.text.split(' ').length > 1 ? _nameController.text.split(' ')[1] : '',
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'dob': _dobController.text,
        'gender': _genderController.text,
        'address': _addressController.text,
        'profileImageUrl': _profileImageUrl,
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/signin'); // Assuming '/login' is the route for the login screen
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = '${_currentUser!.uid}.png';

      try {
        // Upload image to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child('profile_images/$fileName').putFile(imageFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with new image URL
        setState(() {
          _profileImageUrl = downloadUrl;
        });
        await _updateUserData();
      } catch (e) {
        print('Failed to upload image: $e');
      }
    }
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
              _updateUserData();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageUrl == 'default_image_url'
                      ? const AssetImage('lib/images/default_profile.png') // Default profile image path
                      : NetworkImage(_profileImageUrl) as ImageProvider,
                ),
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
