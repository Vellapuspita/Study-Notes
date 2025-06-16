import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class TaskItem {
  String title;
  bool done;
  TaskItem(this.title, {this.done = false});
}

class _TodoPageState extends State<TodoPage> {
  final Map<String, List<TaskItem>> categories = {
    'Groceries': [
      TaskItem('Avocados'),
      TaskItem('Onions'),
      TaskItem('Tomatoes', done: true),
      TaskItem('Green Leaves', done: true),
      TaskItem('Bread'),
      TaskItem('Mushrooms', done: true),
    ],
  };

  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();
    final List<TextEditingController> taskControllers = [TextEditingController()];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF001A72),
        title: const Text("Tambah Kategori & Task", style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: categoryController,
                style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ...taskControllers.map((controller) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  decoration: const InputDecoration(
                    labelText: 'Nama Task',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              )),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    taskControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(Icons.add, color: Colors.yellow),
                label: const Text("Tambah Task", style: TextStyle(color: Colors.yellow)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
            },
            child: const Text("Batal", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              final String categoryName = categoryController.text.trim();
              if (categoryName.isNotEmpty) {
                final List<TaskItem> tasks = taskControllers
                    .where((controller) => controller.text.trim().isNotEmpty)
                    .map((controller) => TaskItem(controller.text.trim()))
                    .toList();
                if (tasks.isNotEmpty) {
                  setState(() {
                    categories[categoryName] = tasks;
                  });
                  Navigator.pop(context); // jangan kembali ke home
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCCB00)),
            child: const Text("Simpan", style: TextStyle(color: Color(0xFF001A72))),
          )
        ],
      ),
    );
  }

  void _editCategory(String oldName) {
    final TextEditingController controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF001A72),
        title: const Text("Edit Nama Kategori", style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Nama Baru', labelStyle: TextStyle(color: Colors.white)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != oldName) {
                setState(() {
                  categories[newName] = categories.remove(oldName)!;
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCCB00)),
            child: const Text("Simpan", style: TextStyle(color: Color(0xFF001A72))),
          )
        ],
      ),
    );
  }

  void _deleteCategory(String categoryName) {
    setState(() {
      categories.remove(categoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A72),
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: const Color(0xFF001A72),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categories.entries.map((entry) {
          final completedCount = entry.value.where((item) => item.done).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${entry.key} ($completedCount of ${entry.value.length} Tasks)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _editCategory(entry.key),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteCategory(entry.key),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0033A0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: entry.value
                      .map((task) => CheckboxListTile(
                            value: task.done,
                            onChanged: (value) {
                              setState(() {
                                task.done = value!;
                              });
                            },
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.done ? TextDecoration.lineThrough : TextDecoration.none,
                                color: task.done ? Colors.grey : Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            activeColor: Colors.yellow,
                            checkColor: Colors.black,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFCCB00),
        foregroundColor: const Color(0xFF001A72),
        onPressed: _showAddCategoryDialog,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Task", style: TextStyle(fontFamily: 'Poppins')),
      ),
    );
  }
}
