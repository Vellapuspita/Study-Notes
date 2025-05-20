import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  static const String id = '/signup'; //routing
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A72),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(label: 'Username'),
            const SizedBox(height: 40),
            _buildTextField(label: 'Email'),
            const SizedBox(height: 40),
            _buildTextField(label: 'Password', obscureText: true),
            const SizedBox(height: 40),
            _buildTextField(label: 'Confirm Password', obscureText: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //aksi saat tombol SIGN UP ditekan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCCB00), // warna kuning
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(
                    color: Color(0xFF001A72),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fredoka',
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          color: Color(0xFFFCCB00),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField({required String label, bool obscureText = false}) {
  return TextField(
    obscureText: obscureText,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
      filled: true,
      fillColor: const Color(0xFF0033A0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
