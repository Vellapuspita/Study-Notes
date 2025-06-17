import 'package:flutter/material.dart';
import 'package:flutter_application_1/edit_profile_page.dart';
import 'profile_page.dart';
import 'package:flutter_application_1/todolist_page.dart';
import 'settings_screen.dart';

void main() {
  runApp(const HomeScreen());
}

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

  void _addNote() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Note'),
        content: SizedBox(
          height: 50,
          child: TextField(
            controller: _controller,
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
      builder: (context) => AlertDialog(
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
<<<<<<< HEAD
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_pattern.png'),
            fit: BoxFit.cover,
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
=======
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
>>>>>>> 3ff52d1a63112b659edbdd42f1657dcaaa1c31bf
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
<<<<<<< HEAD
                      tileColor: _getNoteColor(index),
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
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () => _deleteNote(index),
                      ),
=======
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
>>>>>>> 3ff52d1a63112b659edbdd42f1657dcaaa1c31bf
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
      builder: (context) => AlertDialog(
        title: const Text('Add Detail Note'),
        content: SizedBox(
          height: 350,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter detail',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
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
      builder: (context) => AlertDialog(
        title: const Text('Delete Detail Note'),
        content: const Text('Are you sure you want to delete this detail note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.note.subNotes.removeAt(index);
              });
              widget.onUpdate();
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
      appBar: AppBar(
        backgroundColor: Color(0xFF001489),
        title: Text(widget.note.title),
        actions: [
          IconButton(
<<<<<<< HEAD
            icon: const Icon(Icons.delete),
            onPressed: widget.onDelete,
=======
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
              ),
            onPressed: () {
              widget.onDelete();
            },
>>>>>>> 3ff52d1a63112b659edbdd42f1657dcaaa1c31bf
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
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
        backgroundColor: Color(0xFF001489),
        onPressed: _addSubNote,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
