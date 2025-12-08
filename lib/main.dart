import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TextFieldTask(),
    );
  }
}

class TextFieldTask extends StatefulWidget {
  const TextFieldTask({super.key});

  @override
  State<TextFieldTask> createState() => _TextFieldTaskState();
}

class _TextFieldTaskState extends State<TextFieldTask> {
  TextEditingController field1 = TextEditingController();
  TextEditingController field2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TextField Assignment"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // TextField 1
            TextField(
              controller: field1,
              decoration: const InputDecoration(
                labelText: "Enter Text",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // TextField 2
            TextField(
              controller: field2,
              decoration: const InputDecoration(
                labelText: "Result",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // زر النسخ
            ElevatedButton(
              onPressed: () {
                setState(() {
                  field2.text = field1.text;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 237, 91),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text("Copy Text"),
            ),

            const SizedBox(height: 30),

            // زر الانتقال لصفحة جديدة وتمرير البيانات
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(
                      textValue: field1.text,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text("Go To Next Page"),
            ),
          ],
        ),
      ),
    );
  }
}


class SecondPage extends StatelessWidget {
  final String textValue;

  const SecondPage({super.key, required this.textValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Page"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "Received Text:\n$textValue",
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}