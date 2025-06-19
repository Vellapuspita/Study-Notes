// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:flutter_application_1/todolist_page.dart';
import 'settings_screen.dart';
import 'discussion_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HomeScreen());
}

class Note {
  String title;
  List<String> subNotes;
  Color color; // Warna untuk notes utama
  List<Color> detailColors; // Warna untuk setiap detail notes

  Note({
    required this.title,
    List<String>? subNotes,
    this.color = Colors.white,
    List<Color>? detailColors,
  })  : subNotes = subNotes ?? [],
        detailColors = detailColors ?? [];
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
  Map<String, List<Note>> _userNotes = {}; // Catatan berdasarkan username
  List<Note> _notes = []; // Catatan untuk pengguna yang login
  String _username = ''; // Variabel untuk menyimpan username

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Muat catatan dari SharedPreferences
    _loadUserData(); // Muat data pengguna
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User'; // Ambil username
      _notes = _userNotes[_username] ?? []; // Ambil catatan untuk pengguna yang login
    });
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('userNotes');
    if (jsonString != null) {
      Map<String, dynamic> jsonNotes = jsonDecode(jsonString);
      _userNotes = jsonNotes.map((key, value) {
        return MapEntry(key, (value as List).map((note) {
          return Note(
            title: note['title'],
            subNotes: List<String>.from(note['subNotes']),
            color: Color(note['color']), // Muat warna notes utama
            detailColors: (note['detailColors'] as List).map((color) => Color(color)).toList(), // Muat warna detail notes
          );
        }).toList());
      });
    }
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonNotes = _userNotes.map((key, value) {
      return MapEntry(key, value.map((note) => {
        'title': note.title,
        'subNotes': note.subNotes,
        'color': note.color.value, // Simpan warna notes utama
        'detailColors': note.detailColors.map((color) => color.value).toList(), // Simpan warna detail notes
      }).toList());
    });
    await prefs.setString('userNotes', jsonEncode(jsonNotes)); // Simpan sebagai JSON
  }

  void _addNote() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  final newNote = Note(title: controller.text.toUpperCase());
                  if (_userNotes[_username] == null) {
                    _userNotes[_username] = [];
                  }
                  _userNotes[_username]!.add(newNote); // Tambahkan catatan
                  _notes = _userNotes[_username]!; // Perbarui daftar catatan
                  _saveNotes(); // Save notes to SharedPreferences
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

  void _addSubNote(Note note) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Detail Note'),
        content: SizedBox(
          height: 150,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter detail',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            maxLines: null,
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
                  note.subNotes.add(controller.text); // Tambahkan detail notes
                  note.detailColors.add(Colors.white); // Tambahkan warna default
                  _userNotes[_username] = _notes; // Perbarui data pengguna
                  _saveNotes(); // Simpan ke SharedPreferences
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
                _userNotes[_username]?.removeAt(index); // Hapus catatan
                _notes = _userNotes[_username] ?? []; // Perbarui daftar catatan
                _saveNotes(); // Simpan ke SharedPreferences
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _changeNoteColor(Note note, Color color) {
    setState(() {
      note.color = color; // Perbarui warna catatan
      _userNotes[_username] = _notes; // Perbarui data pengguna
      _saveNotes(); // Simpan ke SharedPreferences
    });
  }

  void _changeDetailNoteColor(Note note, int index, Color color) {
    setState(() {
      note.detailColors[index] = color; // Perbarui warna detail notes
      _userNotes[_username] = _notes; // Perbarui data pengguna
      _saveNotes(); // Simpan ke SharedPreferences
    });
  }

  void _setDetailNoteColor(Note note, int index, Color color) {
    setState(() {
      note.detailColors[index] = color; // Tetapkan warna detail notes
      _userNotes[_username] = _notes; // Perbarui data pengguna
      _saveNotes(); // Simpan ke SharedPreferences
    });
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
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.brown.withOpacity(0.1),
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
                        'Hi, $_username', // Tampilkan username
                        style: const TextStyle(
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
                        tileColor: _notes[index].color,
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
                                    onSaveNotes: _saveNotes, // Pass the save notes callback
                                  ),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                _deleteNote(index); // Call the delete method
                              },
                            ),
                            PopupMenuButton<Color>(
                              icon: const Icon(
                                Icons.color_lens,
                                color: Colors.purple,
                              ),
                              tooltip: 'Change Note Color',
                              onSelected: (color) => _changeNoteColor(_notes[index], color),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: Colors.greenAccent,
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                ),
                                PopupMenuItem(
                                  value: Colors.redAccent.shade100,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.redAccent.shade100,
                                  ),
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
              Container(
                color: const Color(0xFF001489),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF001489),
          onPressed: _addNote,
          shape: const CircleBorder(),
          elevation: 10,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
class NoteDetailPage extends StatefulWidget {
  final Note note;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onSaveNotes; // Callback for saving notes
  const NoteDetailPage({
    super.key,
    required this.note,
    required this.onUpdate,
    required this.onDelete,
    required this.onSaveNotes, // Ensure proper initialization
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  void _setDetailNoteColor(Note note, int index, Color color) {
    setState(() {
      note.detailColors[index] = color; // Tetapkan warna detail notes
      widget.onSaveNotes(); // Simpan ke SharedPreferences
      widget.onUpdate(); // Perbarui UI
    });
  }

  void _addSubNote(Note note) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Detail Note'),
        content: SizedBox(
          height: 150,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter detail',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            maxLines: null,
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
                  note.subNotes.add(controller.text); // Tambahkan detail notes
                  note.detailColors.add(Colors.white); // Tambahkan warna default
                  widget.onSaveNotes(); // Simpan ke SharedPreferences
                  widget.onUpdate(); // Perbarui UI
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              widget.onDelete();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.note.subNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: widget.note.detailColors[index], // Gunakan warna detail notes
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
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
                              tooltip: 'Edit Detail Note',
                              onPressed: () {
                                TextEditingController _controller = TextEditingController(
                                  text: widget.note.subNotes[index],
                                );

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Edit Detail Note'),
                                    content: SizedBox(
                                      height: 150,
                                      child: TextField(
                                        controller: _controller,
                                        decoration: const InputDecoration(
                                          hintText: 'Edit detail',
                                          border: OutlineInputBorder(),
                                        ),
                                        autofocus: true,
                                        maxLines: null,
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
                                              widget.note.subNotes[index] = _controller.text; // Perbarui detail note
                                              widget.onSaveNotes(); // Simpan ke SharedPreferences
                                            });
                                            widget.onUpdate(); // Perbarui UI
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat, color: Colors.green),
                              tooltip: 'Diskusi',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiscussionPage(
                                      subNoteContent: widget.note.subNotes[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.color_lens, color: Colors.purple),
                              tooltip: 'Ganti Warna',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Pilih Warna'),
                                    content: Wrap(
                                      spacing: 10,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _setDetailNoteColor(widget.note, index, const Color(0xFFFFD1DC)),
                                          child: const CircleAvatar(backgroundColor: Color(0xFFFFD1DC)),
                                        ),
                                        GestureDetector(
                                          onTap: () => _setDetailNoteColor(widget.note, index, const Color(0xFFB3E5FC)),
                                          child: const CircleAvatar(backgroundColor: Color(0xFFB3E5FC)),
                                        ),
                                        GestureDetector(
                                          onTap: () => _setDetailNoteColor(widget.note, index, const Color(0xFFCCFF90)),
                                          child: const CircleAvatar(backgroundColor: Color(0xFFCCFF90)),
                                        ),
                                        GestureDetector(
                                          onTap: () => _setDetailNoteColor(widget.note, index, const Color(0xFFFFFF8D)),
                                          child: const CircleAvatar(backgroundColor: Color(0xFFFFFF8D)),
                                        ),
                                        GestureDetector(
                                          onTap: () => _setDetailNoteColor(widget.note, index, const Color(0xFFE1BEE7)),
                                          child: const CircleAvatar(backgroundColor: Color(0xFFE1BEE7)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
        onPressed: () => _addSubNote(widget.note),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Future<void> saveUserData(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username); // Simpan username dari backend
}

