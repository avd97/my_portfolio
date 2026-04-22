import 'package:flutter/material.dart';

class SkillsAndExperience extends StatelessWidget {
  const SkillsAndExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 50),
          child:
              isMobile
                  ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TechnicalSkills(),
                      SizedBox(height: 30),
                      WorkExperience(),
                    ],
                  )
                  : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TechnicalSkills()),
                      SizedBox(width: 20),
                      Expanded(child: WorkExperience()),
                    ],
                  ),
        );
      },
    );
  }
}

class TechnicalSkills extends StatelessWidget {
  const TechnicalSkills({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technical Skills',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        SizedBox(height: 12),
        Text(
          '• Languages & Frameworks: Dart, Flutter, Java, Kotlin, Node.js, Express.js\n'
          '• Architecture & Patterns: MVVM, Clean Architecture, Provider\n'
          '• Mobile Development: Android (Java/Kotlin), iOS (Flutter)\n'
          '• APIs & Integrations: REST APIs, Google Maps, Razorpay, CCAvenue, Firebase\n'
          '• Databases: MySQL, PostgreSQL, SQLite, Room, Sqflite\n'
          '• Authentication: JWT, OAuth, Firebase Auth\n'
          '• Tools & Collaboration: Git, GitHub, Bitbucket, Postman, Agile/Scrum\n'
          '• Deployment: CI/CD, Play Console, App Store Connect\n'
          '• Cloud & Services: Firebase, AWS, Secure Data Storage, Localization, TTS',
          style: TextStyle(fontSize: 15, height: 1.8, color: Colors.black87),
        ),
      ],
    );
  }
}

class WorkExperience extends StatelessWidget {
  const WorkExperience({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Work Experience',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 12),
          _ExperienceItem(
            title: 'Senior Flutter Developer (Knackbe Technologies, Pune)',
            duration: 'MAR 2022 - PRESENT',
            details:
                '• Designed and built advanced mobile applications for Android & iOS using Flutter.\n'
                '• Delivered production-ready apps with robustness and optimization.\n'
                '• Integrated Firebase, Google Maps, Razorpay, and CCAvenue.\n'
                '• Mentored 5 developers, reducing app development time by 15%.\n'
                '• Collaborated with cross-functional teams to define and ship new features.',
          ),
          const SizedBox(height: 12),
          _ExperienceItem(
            title: 'Android Developer (Knackbe Technologies, Pune)',
            duration: 'JUL 2020 - MAR 2022',
            details:
                '• Designed and developed native Android applications.\n'
                '• Integrated APIs and Android SDK components.\n'
                '• Collaborated with designers and QA teams.\n'
                '• Optimized performance and responsiveness.',
          ),
          const SizedBox(height: 12),
          _ExperienceItem(
            title: 'Android Developer (OmVSab IT Solution)',
            duration: 'DEC 2019 - JUN 2020',
            details:
                '• Developed Android apps with focus on usability.\n'
                '• Utilized Java & Kotlin following best practices.\n'
                '• Integrated Room, SQLite, and Shared Preferences.',
          ),
        ],
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final String title;
  final String? duration;
  final String details;

  const _ExperienceItem({
    required this.title,
    required this.duration,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        if (duration!.isNotEmpty)
          Text(
            duration!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.indigo.shade600,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          details,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
