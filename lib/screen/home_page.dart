import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    // 🔹 Create ScrollController and GlobalKeys
    final scrollController = ScrollController();
    final experienceKey = GlobalKey();
    final projectsKey = GlobalKey();
    final contactKey = GlobalKey();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;

          return SafeArea(
            child: Column(
              children: [
                // 🔹 Pass onNavItemTap callback to HeaderBar
                HeaderBar(
                  onNavItemTap: (section) {
                    switch (section) {
                      case 'Experience':
                        Scrollable.ensureVisible(
                          experienceKey.currentContext!,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                        break;
                      case 'Projects':
                        Scrollable.ensureVisible(
                          projectsKey.currentContext!,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                        break;
                      case 'Contact':
                        Scrollable.ensureVisible(
                          contactKey.currentContext!,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                        break;
                      case 'Home':
                        scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                        break;
                    }
                  },
                ),

                Expanded(
                  child: Container(
                    margin: !isMobile
                        ? EdgeInsets.symmetric(
                      horizontal: screen.width * 0.1,
                      vertical: 16,
                    )
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const ProfileSection(),
                        const SizedBox(height: 20),
                        ContactRow(key: contactKey),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 30),
                        SkillsAndExperience(key: experienceKey),
                        const SizedBox(height: 40),
                        ProjectsSection(key: projectsKey),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// HEADER BAR
/// HEADER BAR
class HeaderBar extends StatelessWidget {
  final Function(String section) onNavItemTap; // 👈 Accept callback

  const HeaderBar({
    super.key,
    required this.onNavItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 18,
        children: [
          _HeaderItem(title: 'Home', onTap: () => onNavItemTap('Home')),
          _HeaderItem(title: 'Experience', onTap: () => onNavItemTap('Experience')),
          _HeaderItem(title: 'Projects', onTap: () => onNavItemTap('Projects')),
          _HeaderItem(title: 'Contact', onTap: () => onNavItemTap('Contact')),
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _HeaderItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

/// PROFILE SECTION
class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    'https://media.licdn.com/dms/image/v2/D4D16AQFyobAAV9ALlw/profile-displaybackgroundimage-shrink_350_1400/profile-displaybackgroundimage-shrink_350_1400/0/1704461315572?e=1763596800&v=beta&t=bdounbzeYhVQCuPPYWGNz3_33VKMJLxDef5L91sDQzQ',
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                const Positioned(
                  top: 120,
                  left: 50,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 95,
                      backgroundImage: NetworkImage(
                        'https://media.licdn.com/dms/image/v2/D4D03AQFmYACBRKiQdA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1699343417875?e=1763596800&v=beta&t=VV5PBZe6TeuvI2TBM4iWQWM50WTIhtAu98h1xGGiKe4',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            const _ProfileInfo(),
          ],
        );
      },
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Abhishek Deshpande',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Mobile App Developer (Flutter | Kotlin | Java)',
            style: TextStyle(fontSize: 18),
          ),
          Text('Pune, Maharashtra', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

/// CONTACT ROW (Responsive)
class ContactRow extends StatelessWidget {
  const ContactRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          child: isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ContactButton(
                icon: Icons.call,
                label: '+91-********72',
                alignStart: true,
              ),
              _ContactButton(
                icon: Icons.mail,
                label: 'abhi.pande215@gmail.com',
                alignStart: true,
              ),
              _ContactButton(
                icon: Icons.insert_link_rounded,
                label: 'LinkedIn',
                alignStart: true,
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ContactButton(icon: Icons.call, label: '+91-********72'),
              _ContactButton(
                icon: Icons.mail,
                label: 'abhi.pande215@gmail.com',
              ),
              _ContactButton(
                icon: Icons.insert_link_rounded,
                label: 'LinkedIn',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool alignStart;

  const _ContactButton({
    required this.icon,
    required this.label,
    this.alignStart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignStart ? Alignment.centerLeft : Alignment.center,
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 22),
        label: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

/// SKILLS + EXPERIENCE
class SkillsAndExperience extends StatelessWidget {
  const SkillsAndExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: isMobile
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
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class WorkExperience extends StatelessWidget {
  const WorkExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Experience',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        SizedBox(height: 12),
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
        SizedBox(height: 12),
        _ExperienceItem(
          title: 'Android Developer (Knackbe Technologies, Pune)',
          duration: 'JUL 2020 - MAR 2022',
          details:
          '• Designed and developed native Android applications.\n'
              '• Integrated APIs and Android SDK components.\n'
              '• Collaborated with designers and QA teams.\n'
              '• Optimized performance and responsiveness.',
        ),
        SizedBox(height: 12),
        _ExperienceItem(
          title: 'Android Developer (OmVSab IT Solution)',
          duration: 'DEC 2019 - JUN 2020',
          details:
          '• Developed Android apps with focus on usability.\n'
              '• Utilized Java & Kotlin following best practices.\n'
              '• Integrated Room, SQLite, and Shared Preferences.',
        ),
      ],
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
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (duration!.isNotEmpty)
          Text(duration!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(details, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

/// PROJECTS SECTION
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          _ExperienceItem(
            title: '1. Marathi Vachan (Language Learning App)',
            duration: '',
            details:
            '• Developed a language learning app for nursery kids to learn Marathi, Hindi, and English through interactive games and quizzes.\n'
                '• Implemented balloon-popping games and quizzes for engaging language learning.\n'
                '• Integrated text-to-speech functionality for correct pronunciation and interactive learning.\n'
                '• Designed a kid-friendly UI with simple navigation and vibrant visuals.\n'
                '• Technical Skills: Flutter, Provider, Text-to-Speech.',
          ),
          SizedBox(height: 12),
          _ExperienceItem(
            title: '2. CA Food (Food Ordering App)',
            duration: '',
            details:
            '• Developed a cross-platform food ordering app for Android and iOS using Flutter.\n'
                '• Enabled real-time order tracking with Google Maps and integrated Razorpay for secure payments.\n'
                '• Ensured consistent user experience across both platforms.\n'
                '• Technical Skills: Flutter, Provider, Google Map, Firebase.',
          ),
          SizedBox(height: 12),
          _ExperienceItem(
            title: '3. Entie (Business Networking App)',
            duration: '',
            details:
            '• Spearheaded the development of a business networking app connecting Startups, Co-founders and Investors to create opportunities and foster business growth.\n'
                '• Implemented a real-time chat feature using Firebase Real-time Database.\n'
                '• Integrated Razorpay for secure payment processing.\n'
                '• Technical Skills: Android, Firebase.',
          ),
          SizedBox(height: 12),
          _ExperienceItem(
            title: '4. Flourpicker (E-Commerce App)',
            duration: '',
            details:
            '• Developed an e-commerce platform for ordering fresh flour with custom mixes.\n'
                '• Integrated Swagger, Firebase, and Razorpay.\n'
                '• Technical Skills: Android, Firebase, Google Map.',
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
