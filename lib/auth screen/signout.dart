import '../pages.dart';

class SignOutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to login or home screen after sign-out
      Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }
