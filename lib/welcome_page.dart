import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001489), // Warna biru sesuai desain
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            //judul
            const Text(
              'STUDI NOTES',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Fredoka',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            //gambar
            Image.asset(
              'assets/images/notes_list.png',
              height: 200,
            ),

            const SizedBox(height: 24),

            //subjudul
            const Text(
              'Siap belajar? Yuk, mulai mencatat dan buat belajar jadi lebih menyenangkan!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            //tombol SIGN UP
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //navigasi ke sign up page
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCCB00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:  Color(0xFF001489),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            //sign in text
            GestureDetector(
              onTap: () {
                //navigasi ke Sign In
                Navigator.pushNamed(context, '/signin');
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: RichText(
                  text: const TextSpan(
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          decoration: TextDecoration.none),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Color(0xFFFCCB00),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ]),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
