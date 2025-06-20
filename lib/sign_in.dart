import 'package:flutter/material.dart';
import 'package:flutter_application_1/graphql/graphql_client.dart';
import 'package:flutter_application_1/graphql/mutations/login_mutation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'services/auth_services.dart'; // Import AuthServices
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
// Import HomeScreen

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

  Future<void> _handleSignIn(BuildContext context) async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields')),
    );
    return;
  }

  try {
    final client = await getGraphQLClient();

    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');

    final result = await client.mutate(
      MutationOptions(
        document: gql(loginMutation),
        variables: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      ),
    );

    if (result.hasException) {
      print('GraphQL Error: ${result.exception.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result.exception?.graphqlErrors?.first.message ?? 'Unknown error'}')),
      );
      return;
    }

    final loginData = result.data?['login'];
    final token = loginData?['token'];
    final username = loginData?['user']?['name'];

    if (token != null && username != null) {
      await AuthServices.saveToken(token);
      await saveUserData(username);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      Navigator.pushReplacementNamed(context, '/homescreen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid login credentials')),
      );
    }
  } catch (e) {
    print('Unexpected Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unexpected error: $e')),
    );
  }
}

  
  Future<void> saveUserData(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username); // Simpan username dari backend
  }
}
