import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

/// ----------------------
///  APP ROOT
/// ----------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignInPage(),
    );
  }
}


Future<File> getFile() async {
  final dir = await getApplicationSupportDirectory();
  final file = File("${dir.path}/sign_file.txt");
  if (!await file.exists()) {
    await file.create(recursive: true);
  }
  return file;
}



/// SAVE()  ➜ إضافة مستخدم جديد أو تحديث كلمة المرور
Future<void> save(String username, String password, String department) async {
  final f = await getFile();
  final line = "username_$username, password_$password, department_$department\n";
  await f.writeAsString(line, mode: FileMode.append);
}

/// CHECKVALUE()  ➜ فحص المستخدم داخل الملف
Future<bool> checkValue(String username, String password) async {
  final f = await getFile();
  final lines = await f.readAsLines();

  for (var line in lines) {
    if (line.contains("username_$username") &&
        line.contains("password_$password")) {
      return true;
    }
  }
  return false;
}

/// CHANGE PASSWORD  ➜ يعتمد على checkValue + save
Future<bool> changePassword(
    String username, String oldPass, String newPass) async {
  final f = await getFile();
  final lines = await f.readAsLines();

  bool found = false;
  List<String> newData = [];

  for (var line in lines) {
    if (line.contains("username_$username") &&
        line.contains("password_$oldPass")) {
      found = true;

      // استخراج التخصص
      final dep = line.split(",")[2].trim().replaceAll("department_", "");

      // السطر الجديد
      final updated =
          "username_$username, password_$newPass, department_$dep";
      newData.add(updated);
    } else {
      newData.add(line);
    }
  }

  if (found) {
    await f.writeAsString(newData.join("\n"));
  }

  return found;
}


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final user = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: user, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: pass, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                bool ok = await checkValue(user.text, pass.text);
                if (ok) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => HomePage(username: user.text)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User Not Found")));
                }
              },
              child: const Text("Sign In"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()));
              },
              child: const Text("Create Account"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ResetPasswordPage()));
              },
              child: const Text("Reset Password"),
            )
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////
///
///
///                SIGN UP PAGE
///
////////////////////////////////////////////////////////////////////

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final user = TextEditingController();
  final pass = TextEditingController();
  final dep = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: user, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: pass, decoration: const InputDecoration(labelText: "Password")),
            TextField(controller: dep, decoration: const InputDecoration(labelText: "Department")),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                await save(user.text, pass.text, dep.text);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User Saved")));
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////
///
///
///                RESET PASSWORD PAGE
///
////////////////////////////////////////////////////////////////////

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final user = TextEditingController();
  final oldPass = TextEditingController();
  final newPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: user, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: oldPass, decoration: const InputDecoration(labelText: "Old Password")),
            TextField(controller: newPass, decoration: const InputDecoration(labelText: "New Password")),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  bool ok = await changePassword(
                      user.text, oldPass.text, newPass.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(ok ? "Password Updated" : "Wrong Old Password")));
                },
                child: const Text("Update"))
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////
///
///
///                HOME PAGE
///
////////////////////////////////////////////////////////////////////

class HomePage extends StatelessWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Text("Welcome, $username",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ),
    );
  }
}