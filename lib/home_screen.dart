import 'package:flutter/material.dart';
import 'package:flutter_application_1/todolist_page.dart';
import 'settings_screen.dart'; // Add this import

void main() {
  runApp(const HomeScreen());
}

// MODEL DATA NOTE
class Note {
  String title;
  List<String> subNotes;

  Note({required this.title, List<String>? subNotes})
    : subNotes = subNotes ?? [];
}

// APLIKASI UTAMA
class HomeScreen extends StatelessWidget {
  static const String id = '/homescreen'; //identifier route untuk navigasi
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

// HALAMAN UTAMA
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [];

  void _addNote() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Note'),
            content: SizedBox.fromSize(
              size: const Size(300, 50), // Fixed height for the input field
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter note title',
                  border:
                      OutlineInputBorder(), // Add a border for better visibility
                ),
                autofocus: true,
                maxLines: 1, // Single-line input
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      _notes.add(Note(title: _controller.text.toUpperCase()));
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
                onPressed: () => Navigator.pop(context), // Close the dialog
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _notes.removeAt(index);
                  });
                  Navigator.pop(context); // Close the dialog after deleting
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background_pattern.png'),
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Hi, Vella',
                      style: TextStyle(
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
                    icon: const Icon(Icons.settings, size: 30),
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
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          _deleteNote(index); // Call the delete method
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: _addNote,
        child: const Icon(Icons.add, color: Colors.black),
        shape: const CircleBorder(),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        shape: const CircularNotchedRectangle(),
        notchMargin: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.notes),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getNoteColor(int index) {
    List<Color> colors = [
      Colors.greenAccent,
      Colors.redAccent.shade100,
      Colors.pinkAccent.shade100,
      Colors.lightGreenAccent,
      Colors.orangeAccent.shade100,
      Colors.deepOrangeAccent.shade100,
      Colors.purpleAccent.shade100,
      Colors.tealAccent.shade100,
    ];
    return colors[index % colors.length];
  }
}

// HALAMAN DETAIL NOTE
class NoteDetailPage extends StatefulWidget {
  final Note note;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const NoteDetailPage({
    super.key,
    required this.note,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  void _addSubNote() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Detail Note'),
            content: SizedBox.fromSize(
              size: const Size(
                250,
                350,
              ), // Set a fixed height for the input field
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter detail',
                  border:
                      OutlineInputBorder(), // Add a border for better visibility
                ),
                autofocus: true,
                maxLines: null, // Allow the input field to expand vertically
                expands: true, // Enable vertical expansion
                textAlignVertical:
                    TextAlignVertical.top, // Align text to the top
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      widget.note.subNotes.add(_controller.text);
                    });
                    widget.onUpdate();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _deleteSubNote(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Detail Note'),
            content: const Text(
              'Are you sure you want to delete this detail note?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close the dialog
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.note.subNotes.removeAt(index);
                  });
                  widget.onUpdate();
                  Navigator.pop(context); // Close the dialog after deleting
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
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDelete();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_pattern2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.note.subNotes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(widget.note.subNotes[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteSubNote(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: _addSubNote,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
