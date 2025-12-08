import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'قائمة المهام',
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFFFF9E6), // بيج فاتح
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _tasks = [];

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(_controller.text.trim());
      _controller.clear();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController editController =
            TextEditingController(text: _tasks[index]);
        return AlertDialog(
          title: const Text("تعديل المهمة"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: "اكتب المهمة الجديدة"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index] = editController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 قائمة المهام'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'أضف مهمة جديدة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: _addTask,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد مهام حالياً',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: ListTile(
                            title: Text(_tasks[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () => _editTask(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteTask(index),
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
      ),
    );
  }
}