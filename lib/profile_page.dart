import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF002885), // Biru gelap
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // kembali ke home_screen.dart
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "PROFILE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 60, color: Colors.black),
              ),
              const SizedBox(height: 20),

              // Username Field
              _buildTextField("Username", usernameController),
              const SizedBox(height: 12),

              // Gender Field
              _buildTextField("Gender", genderController),
              const SizedBox(height: 12),

              // Email Field
              _buildTextField("Email", emailController),
              const SizedBox(height: 12),

              // Phone Number Field
              _buildTextField("Phone Number", phoneController),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Simpan data
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    color: Color(0xFF002885),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
