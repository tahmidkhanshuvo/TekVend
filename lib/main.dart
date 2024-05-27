import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'product_page.dart';

void main() {
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
      initialRoute: '/signin',
      routes: {
        '/home': (context) =>  const ProductPage(),
        '/signin': (context) =>  const SignInScreen(),
        '/signup': (context) =>  const SignUpScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
