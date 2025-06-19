import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:flutter_application_1/todolist_page.dart';
import 'settings_screen.dart';
import 'discussion_page.dart';
import 'package:flutter_application_1/todolist_page.dart';

class Note {
  String title;
  List<String> subNotes;

  Note({required this.title, List<String>? subNotes})
    : subNotes = subNotes ?? [];
}

class HomeScreen extends StatelessWidget {
  static const String id = '/homescreen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Notes',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 253, 231),
        useMaterial3: true,
      ),
      home: const NotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [];
  String _username = ''; // Variabel untuk menyimpan username

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Ambil data pengguna saat halaman dimuat
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User'; // Ambil username
    });
  }

  void _addNote() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Note'),
            content: SizedBox(
              height: 50,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter note title',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                maxLines: 1,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      _notes.add(Note(title: controller.text.toUpperCase()));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _notes.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/background_pattern.png'),
                fit: BoxFit.cover, // Ensures the image covers the entire screen
                colorFilter: ColorFilter.mode(
                  // ignore: deprecated_member_use
                  Colors.brown.withOpacity(
                    0.1,
                  ), // Makes the image slightly transparent
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF001489),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.person, size: 30),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Hi, User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          _notes[index].title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        tileColor: _getNoteColor(
                          index,
                        ), // Set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => NoteDetailPage(
                                    note: _notes[index],
                                    onUpdate: () => setState(() {}),
                                    onDelete: () {
                                      _deleteNote(index);
                                      Navigator.pop(context);
                                    },
                                  ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            _deleteNote(index); // Call the delete method
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                color: Color(0xFF001489),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(color: Colors.white, Icons.home),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.notes, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TodoPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF001489),
        onPressed: _addSubNote,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Future<void> saveUserData(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username); // Simpan username dari backend
}

