import '../pages.dart';

class SignOutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to login or home screen after sign-out
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Out'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signOut(context),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
