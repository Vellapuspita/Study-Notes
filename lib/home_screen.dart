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
                  Colors.brown.withOpacity(0.1), // Makes the image slightly transparent
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF001489),
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
                        tileColor: _getNoteColor(index), // Set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteDetailPage(
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
                color: 
                Color(0xFF001489),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(icon: const Icon(
                                  color: Colors.white,
                                  Icons.home,
                                  ), onPressed: () {}),
                                IconButton(
                    icon: const Icon(
                      Icons.notes,
                      color: Colors.white,
                      ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TodoPage()),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF001489),
          onPressed: _addNote,
          child: const Icon(Icons.add, color: Colors.white),
          shape: const CircleBorder(),
          elevation: 10,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
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
  final Map<int, Color> _noteColors = {}; // Store background colors for each sub-note

  void _addSubNote() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Detail Note'),
        content: SizedBox(
          height: 150, 
          width: 100,// Fixed height for the input field
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter detail',
              border: OutlineInputBorder(), // Add a border for better visibility
            ),
            autofocus: true,
            maxLines: null, // Allow the input field to expand vertically
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
                  _noteColors[widget.note.subNotes.length - 1] = Colors.white; // Default color
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

  void _editSubNote(int index) {
    TextEditingController _controller =
        TextEditingController(text: widget.note.subNotes[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Detail Note'),
        content: SizedBox(
          height: 150, // Fixed height for the input field
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Edit detail',
              border: OutlineInputBorder(), // Add a border for better visibility
            ),
            autofocus: true,
            maxLines: null, // Allow the input field to expand vertically
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
                  widget.note.subNotes[index] = _controller.text;
                });
                widget.onUpdate();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _changeNoteColor(int index, Color color) {
    setState(() {
      _noteColors[index] = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001489),
        title: Text(widget.note.title),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              widget.onDelete();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Grid layout for sub-notes
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.note.subNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: _noteColors[index] ?? Colors.white, // Use the stored color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.note.subNotes[index],
                          maxLines: 3, // Limit preview to 3 lines
                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editSubNote(index),
                            ),
                            PopupMenuButton<Color>(
                              icon: const Icon(Icons.color_lens, color: Colors.purple),
                              onSelected: (color) => _changeNoteColor(index, color),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: const Color(0xFFFFD1DC), // Pastel pink
                                  child: const CircleAvatar(
                                    backgroundColor: Color(0xFFFFD1DC),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: const Color(0xFFB3E5FC), // Pastel blue
                                  child: const CircleAvatar(
                                    backgroundColor: Color(0xFFB3E5FC),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: const Color(0xFFCCFF90), // Pastel green
                                  child: const CircleAvatar(
                                    backgroundColor: Color(0xFFCCFF90),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: const Color(0xFFFFFF8D), // Pastel yellow
                                  child: const CircleAvatar(
                                    backgroundColor: Color(0xFFFFFF8D),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: const Color(0xFFE1BEE7), // Pastel purple
                                  child: const CircleAvatar(
                                    backgroundColor: Color(0xFFE1BEE7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
