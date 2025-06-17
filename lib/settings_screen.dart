import 'package:flutter/material.dart';
import 'edit_profile_page.dart'; // Add this import
import 'change_password_page.dart';
import 'welcome_page.dart'; // Import ChangePasswordPage

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Menambah tinggi AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 50.0), // Tambahkan jarak dari atas
          child: Text(
            'SETTINGS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff001995),
      ),
      body: Container(
        color: const Color(0xff001995),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACCOUNTS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              HoverableListTile(
                title: 'Edit Profile',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    ),
              ),
              HoverableListTile(
                title: 'Change Password',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage(),
                      ),
                    ),
              ),
              const SizedBox(height: 20),
              const Text(
                'PREFERENCES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              HoverableListTile(title: 'Language', onTap: () {}),
              HoverableListTile(title: 'Notifications', onTap: () {}),
              HoverableListTile(title: 'Delete Account', onTap: () {}),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(), // Navigate to WelcomePage
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCCB00),
                  ),
                  child: const Text(
                    'LOGOUT',
                    style: TextStyle(
                      color: Color(0xFF001995),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverableListTile extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const HoverableListTile({Key? key, required this.title, required this.onTap})
    : super(key: key);

  @override
  _HoverableListTileState createState() => _HoverableListTileState();
}

class _HoverableListTileState extends State<HoverableListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ListTile(
        title: Text(
          widget.title,
          style: TextStyle(
            color: _isHovered ? const Color(0xFFFCCB00) : Colors.white,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: _isHovered ? const Color(0xFFFCCB00) : Colors.white,
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
