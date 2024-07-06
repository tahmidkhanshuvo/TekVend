import 'pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'TekVend',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ensure the UserController is initialized and fetch the initial route
  UserController userController = Get.put(UserController());
  String initialRoute = await userController.getInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TekVend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/home', page: () => ProductPage()),
        GetPage(name: '/signin', page: () => const SignInScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(name: '/chat', page: () => const ChatScreen()),
        GetPage(name: '/profile', page: () => UserProfileScreen()),
        GetPage(name: '/cart', page: () => const ProductCartScreen()),
        GetPage(name: '/checkout', page: () => CheckoutPage()),
        GetPage(name: '/upload', page: () => UploadProductPage()),
      ],
    );
  }
}
