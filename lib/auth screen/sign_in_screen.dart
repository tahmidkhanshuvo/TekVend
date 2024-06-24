import '../pages.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      print('Failed to sign in: $e');
      // Handle sign-in failures, e.g., display error message
      String errorMessage = 'Failed to sign in';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Failed to sign in';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User cancelled Google sign-in
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e) {
      print('Failed to sign in with Google: $e');
      // Handle sign-in failures, e.g., display error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset(
                  'lib/images/chatlogo.png', // Replace with your logo path
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signInWithEmailAndPassword();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                icon: Image.asset(
                  'lib/images/googlelogo.png', // Replace with your Google logo path
                  height: 24.0,
                ),
                label: const Text('Sign In with Google'),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/signup');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
