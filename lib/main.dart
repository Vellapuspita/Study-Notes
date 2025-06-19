import 'package:flutter/material.dart';
import 'package:flutter_application_1/forgot_password.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/reset_password.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Notes',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Fredoka'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        //routing aplikasi
        '/': (context) => const WelcomePage(),
        '/signup': (context) => SignUpPage(),
        '/signin': (context) => SignInPage(),
        '/homescreen': (context) => const HomeScreen(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
        '/resetpassword': (context) => const ResetPasswordPage(),
      },
    );
  }
}
