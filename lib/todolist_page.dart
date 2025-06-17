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
    final categoryController = TextEditingController();
    final taskControllers = [TextEditingController()];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF001A72),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Tambah Kategori & Task",
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: categoryController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nama Kategori',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...taskControllers.map(
                    (controller) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Nama Task',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          taskControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.yellow),
                      label: const Text(
                        "Tambah Task",
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final category = categoryController.text.trim();
                  if (category.isNotEmpty) {
                    final tasks =
                        taskControllers
                            .where(
                              (controller) => controller.text.trim().isNotEmpty,
                            )
                            .map(
                              (controller) => TaskItem(controller.text.trim()),
                            )
                            .toList();
                    if (tasks.isNotEmpty) {
                      setState(() {
                        categories[category] = tasks;
                      });
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCCB00),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Color(0xFF001A72)),
                ),
              ),
            ],
          ),
    );
  }

  void _editCategory(String oldName) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF001A72),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Edit Kategori",
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nama Baru',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.white),
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCCB00),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Color(0xFF001A72)),
                ),
              ),
            ],
          ),
    );
  }

  void _deleteCategory(String categoryName) {
    setState(() {
      categories.remove(categoryName);
    });
  }

  void _showAddTaskDialog(String category) {
    final taskController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF001A72),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Tambah Task ke $category",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            content: TextField(
              controller: taskController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nama Task',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newTask = taskController.text.trim();
                  if (newTask.isNotEmpty) {
                    setState(() {
                      categories[category]?.add(TaskItem(newTask));
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCCB00),
                ),
                child: const Text(
                  "Tambah",
                  style: TextStyle(color: Color(0xFF001A72)),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A72),
      appBar: AppBar(
        title: const Text(
          'My To-Do List',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: const Color(0xFF001A72),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:
            categories.entries.map((entry) {
              final completedCount =
                  entry.value.where((item) => item.done).length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${entry.key} ($completedCount/${entry.value.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.lightGreenAccent,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_task,
                          color: Colors.yellowAccent,
                        ),
                        tooltip: "Tambah Task",
                        onPressed: () => _showAddTaskDialog(entry.key),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFF0033A0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView.builder(
                      itemCount: entry.value.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        final task = entry.value[i];
                        return CheckboxListTile(
                          value: task.done,
                          onChanged: (value) {
                            setState(() {
                              task.done = value!;
                            });
                          },
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration:
                                  task.done ? TextDecoration.lineThrough : null,
                              color: task.done ? Colors.grey : Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.yellow,
                          checkColor: Colors.black,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        );
                      },
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
        label: const Text(
          "Tambah Task",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
