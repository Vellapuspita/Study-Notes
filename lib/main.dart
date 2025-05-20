import 'package:flutter/material.dart';
import 'package:study_notes_project/sign_in.dart';
import 'package:study_notes_project/sign_up.dart';
import 'package:study_notes_project/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Fredoka',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: { //routing aplikasi 
        '/': (context) => const WelcomePage(),
        SignUpPage.id: (context) => const SignUpPage(),
        SignInPage.id: (context) => const SignInPage(),
      },
    );
  }
}
