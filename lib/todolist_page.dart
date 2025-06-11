import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.edit),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categories.entries.map((entry) {
          final completedCount =
              entry.value.where((item) => item.done).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${entry.key} (${completedCount} of ${entry.value.length} Tasks)',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
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
                                decoration: task.done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task.done ? Colors.grey : Colors.black,
                              ),
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic menambah kategori / task bisa ditambahkan
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem {
  String title;
  bool done;
  TaskItem(this.title, {this.done = false});
}

