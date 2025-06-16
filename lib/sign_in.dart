import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static const String id = '/signin'; //identifier route untuk navigasi
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A72),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fredoka',
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(label: 'Email'), //membuat field email
            const SizedBox(height: 40),
            _buildTextField(
              label: 'Password',
              obscureText: true,
            ), //membuat field password, dengan teks tertutup
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  //forgot password
                  Navigator.pushNamed(
                    context,
                    '/forgotpassword',
                  ); //navigasi ke halaman forgot password
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            //tombol sign in
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/homescreen',
                  ); // navigasi ke halaman home
                  //aksi saat tombol SIGN IN ditekan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCCB00),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SIGN IN',
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
            //"don't have an account? sign up"
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/signup',
                  ); //membawa ke halaman signup
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Poppins',
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

  Widget _buildTextField({required String label, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        filled: true,
        fillColor: const Color(0xFF0033A0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
