import '../pages.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var currentUser = Rx<User?>(null);
  var userData = Rx<DocumentSnapshot?>(null);
  var profileImageUrl = 'default_image_url'.obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var dobController = TextEditingController();
  var genderController = TextEditingController();
  var addressController = TextEditingController();

  // Observable for selectedIndex
  var selectedIndex = 3.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (currentUser.value != null) {
      DocumentSnapshot userDataSnapshot = await _firestore.collection('users').doc(currentUser.value!.uid).get();
      userData.value = userDataSnapshot;
      nameController.text = '${userDataSnapshot['firstName']} ${userDataSnapshot['lastName']}';
      emailController.text = userDataSnapshot['email'];
      phoneController.text = userDataSnapshot['phoneNumber'];
      dobController.text = userDataSnapshot['dob'] ?? '';
      genderController.text = userDataSnapshot['gender'] ?? '';
      addressController.text = userDataSnapshot['address'] ?? '';
      profileImageUrl.value = userDataSnapshot['profileImageUrl'] ?? 'default_image_url';
    }
  }

  Future<void> updateUserData() async {
    if (currentUser.value != null) {
      await _firestore.collection('users').doc(currentUser.value!.uid).update({
        'firstName': nameController.text.split(' ')[0],
        'lastName': nameController.text.split(' ').length > 1 ? nameController.text.split(' ')[1] : '',
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'dob': dobController.text,
        'gender': genderController.text,
        'address': addressController.text,
        'profileImageUrl': profileImageUrl.value,
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/signin');
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = '${currentUser.value!.uid}.png';

      try {
        // Upload image to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child('profile_images/$fileName').putFile(imageFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with new image URL
        profileImageUrl.value = downloadUrl;
        await updateUserData();
      } catch (e) {
        print('Failed to upload image: $e');
      }
    }
  }

  void onItemTapped(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      switch (index) {
        case 0:
          Get.offAllNamed('/categories');
          break;
        case 1:
          Get.offAllNamed('/home');
          break;
        case 2:
          Get.offAllNamed('/cart');
          break;
        case 3:
        // Already on profile screen
          break;
      }
    }
  }

  Future<String> getInitialRoute() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate some delay
    if (currentUser.value != null) {
      return '/home';
    } else {
      return '/signin';
    }
  }
}
