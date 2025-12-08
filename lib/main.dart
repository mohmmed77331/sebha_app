import 'package:flutter/material.dart';

void main() {
  runApp(MyCVApp());
}

class MyCVApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My CV',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Montserrat',
      ),
      home: CVScreen(),
    );
  }
}

class CVScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with photo
            Container(
              color: Colors.deepPurple,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('images/file_000000002d606246adeaab98f3346e0e.png'),
                  ),
                  SizedBox(height: 15),
                  Text(
                    ' محمد أحمد حبيش ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'مهندس برمجيات | مطور Flutter',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.white70, size: 18),
                      SizedBox(width: 5),
                      Text(
                        'email@example.com',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.phone, color: Colors.white70, size: 18),
                      SizedBox(width: 5),
                      Text(
                        '+967 784XXXXXXX',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(title: 'نبذة عني'),
                  Text(
                    'أنا مطور تطبيقات Flutter مع خبرة في بناء تطبيقات جذابة وسريعة الأداء، أحب التعلم وتجربة التقنيات الجديدة، وأسعى دائماً لتحسين مهاراتي في التصميم والتطوير.',
                    style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 20),
                  SectionTitle(title: 'المهارات'),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SkillChip(label: 'Flutter'),
                      SkillChip(label: 'Dart'),
                      SkillChip(label: 'Firebase'),
                      SkillChip(label: 'UI/UX Design'),
                      SkillChip(label: 'Git & GitHub'),
                      SkillChip(label: 'REST API'),
                    ],
                  ),
                  SizedBox(height: 20),
                  SectionTitle(title: 'الخبرات العملية'),
                  ExperienceCard(
                    title: 'مطوّر Flutter',
                    company: 'شركة التقنية الحديثة',
                    duration: '2022 - الآن',
                    description:
                        'تطوير وصيانة تطبيقات الجوال باستخدام Flutter وDart مع التركيز على الأداء والتصميم الجميل وتجربة المستخدم الممتازة.',
                  ),
                  ExperienceCard(
                    title: 'مطور ويب مبتدئ',
                    company: 'شركة الويب الذكي',
                    duration: '2020 - 2022',
                    description:
                        'المشاركة في تطوير واجهات المستخدم والتفاعل مع APIs باستخدام HTML, CSS, JavaScript وتحسين تجربة المستخدم.',
                  ),
                  SizedBox(height: 20),
                  SectionTitle(title: 'التعليم'),
                  ExperienceCard(
                    title: 'بكالوريوس علوم الحاسوب',
                    company: 'جامعة التقنية',
                    duration: '2021 - 2025',
                    description: 'تخصص علوم الحاسوب مع التركيز على تطوير البرمجيات وتحليل الأنظمة.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;
  SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.deepPurple[900], fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.deepPurple[50],
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String title;
  final String company;
  final String duration;
  final String description;

  ExperienceCard(
      {required this.title,
      required this.company,
      required this.duration,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 2),
            Text(
              '$company | $duration',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(description,
                style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}

