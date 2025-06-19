import 'package:flutter/material.dart';
import 'package:flutter_application_1/graphql/mutations/register_mutation.dart'; // Ensure this file contains the registerMutation
import 'package:graphql_flutter/graphql_flutter.dart';
import 'services/auth_services.dart'; // Import AuthServices
import 'package:flutter_application_1/graphql/graphql_client.dart'; // Import GraphQL client setup
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class SignUpPage extends StatelessWidget {
  static const String id = '/signup'; // Routing
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A72),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
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
            _buildTextField(controller: usernameController, label: 'Username'),
            const SizedBox(height: 40),
            _buildTextField(controller: emailController, label: 'Email'),
            const SizedBox(height: 40),
            _buildTextField(controller: passwordController, label: 'Password', obscureText: true),
            const SizedBox(height: 40),
            _buildTextField(controller: confirmPasswordController, label: 'Confirm Password', obscureText: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _handleSignUp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCCB00),
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

  Future<void> _handleSignUp(BuildContext context) async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final client = await getGraphQLClient();

      // Log debug
      print('Sending GraphQL mutation: $registerMutation');
      print('Variables: ${{
        'input': {
          'name': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'confirmPassword': confirmPasswordController.text,
        }
      }}}');

      final result = await client.mutate(
        MutationOptions(
          document: gql(registerMutation),
          variables: {
            'input': {
              'name': usernameController.text,
              'email': emailController.text,
              'password': passwordController.text,
              'confirmPassword': confirmPasswordController.text,
            }
          },
        ),
      );

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.exception.toString()}')),
        );
      } else {
        final token = result.data?['register']['token'];
        final username = usernameController.text; // Ambil username dari input

        if (token != null) {
          await AuthServices.saveToken(token); // Simpan token
          await saveUserData(username); // Simpan username ke SharedPreferences
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushReplacementNamed(context, '/homescreen'); // Navigasi ke HomeScreen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed')),
          );
        }
      }
    } catch (e) {
      print('Unexpected Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  Future<void> saveUserData(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username); // Simpan username dari input
  }
}