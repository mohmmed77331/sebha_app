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
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  // Titles of pages
  final List<String> titles = [
    "Home",
    "Search",
    "Settings",
    "Account",
  ];

  // Content pages
  late final List<Widget> pages = [
    HomePageContent(),
    SearchPageContent(),
    const SettingsPageContent(),
    const AccountPageContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pages[currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////
//                 PAGE 1 – HOME
//////////////////////////////////////////////////////

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  TextEditingController field1 = TextEditingController();
  TextEditingController field2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: field1,
          decoration: const InputDecoration(
            labelText: "Enter Text",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: field2,
          decoration: const InputDecoration(
            labelText: "Result",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 25),

        ElevatedButton(
          onPressed: () {
            setState(() {
              field2.text = field1.text;
            });
          },
          child: const Text("Copy Text"),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////
//              PAGE 2 – SEARCH LISTVIEW
//////////////////////////////////////////////////////

class SearchPageContent extends StatelessWidget {
  SearchPageContent({super.key});

  final List<String> items = [
    "Apple",
    "Banana",
    "Orange",
    "Grapes",
    "Mango",
    "Watermelon",
    "Strawberry",
    "Kiwi",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.list),
          title: Text(items[index]),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        );
      },
    );
  }
}

//////////////////////////////////////////////////////
//               PAGE 3 – SETTINGS
//////////////////////////////////////////////////////

class SettingsPageContent extends StatelessWidget {
  const SettingsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Settings Page",
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}

//////////////////////////////////////////////////////
//               PAGE 4 – ACCOUNT
//////////////////////////////////////////////////////

class AccountPageContent extends StatelessWidget {
  const AccountPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Account Page",
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}