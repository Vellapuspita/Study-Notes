import 'package:flutter/material.dart';
import 'package:flutter_application_1/graphql/graphql_client.dart';
import 'package:flutter_application_1/graphql/mutations/login_mutation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'services/auth_services.dart'; 


class SignInPage extends StatelessWidget {
  static const String id = '/signin'; //identifikasi untuk rute SignInPage
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

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
            //sign in
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
            //text field email & password
            const SizedBox(height: 40),
            _buildTextField(controller: emailController, label: 'Email'), // Email field
            const SizedBox(height: 40),
            _buildTextField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ), //password field
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  //forgot password navigation
                  Navigator.pushNamed(
                    context,
                    '/forgotpassword',
                  );
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
            //sign in button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _handleSignIn(context);
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
            // "Don't have an account? Sign up"
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/signup',
                  );
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
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

  Future<void> _handleSignIn(BuildContext context) async { //mengirim mutasi login ke server GraphQL dan simpan token JWT
    try {
      final client = await getGraphQLClient(); //untuk mendapatkan GraphQL client

      //mencatat perubahan dan variabel
      print('Sending GraphQL mutation: $loginMutation');
      print('Variables: ${{
        'email': emailController.text,
        'password': passwordController.text,
      }}}');

      final result = await client.mutate( //menjalankan mutasi login
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'email': emailController.text,
            'password': passwordController.text,
          },
        ),
      );

      if (result.hasException) {
        //mengelola GraphQL errors
        print('GraphQL Error: ${result.exception.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.exception.toString()}')),
        );
      } else {
        //mengelola login yang berhasil
        final token = result.data?['login']['token'];
        if (token != null) {
          await AuthServices.saveToken(token); //menyimpan token menggunakan AuthServices
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.pushReplacementNamed(context, '/homescreen'); //navigasi ke halaman utama
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid login credentials')),
          );
        }
      }
    } catch (e) {
      //menangani errors yang tidak terduga
      print('Unexpected Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }
}
