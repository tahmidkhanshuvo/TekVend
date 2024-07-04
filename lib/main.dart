import 'pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'TekVend',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TekVend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) =>   ProductPage(),
        '/signin': (context) =>  const SignInScreen(),
        '/signup': (context) =>  const SignUpScreen(),
        '/chat': (context) => const ChatScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/cart': (context) => const ProductCartScreen(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}
