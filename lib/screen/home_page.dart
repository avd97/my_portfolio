import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_portfolio/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  final experienceKey = GlobalKey();
  final projectsKey = GlobalKey();
  final contactKey = GlobalKey();

  String userName = 'Loading...'; // 👈 Default until data fetched
  String mobileNumber = 'Loading...'; // 👈 Default until data fetched
  String emailId = 'Loading...'; // 👈 Default until data fetched
  String profilePic = ''; // 👈 Default until data fetched
  String bgImage = ''; // 👈 Default until data fetched

  @override
  void initState() {
    super.initState();
    _listenToUserDetails();
  }

  /// 🔹 Fetch user name from Firebase Realtime Database
  StreamSubscription? _userSubscription;

  void _listenToUserDetails() {
    final ref = FirebaseDatabase.instance
        .ref(Constants.userDetails)
        .child('admin_info');

    _userSubscription = ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          userName = data['name'] ?? 'Unknown User';
          mobileNumber = data['mobileNumber'] ?? '';
          emailId = data['emailId'] ?? '';
          profilePic = data['profilePic'] ?? '';
          bgImage = data['bgImage'] ?? '';
        });
      } else {
        setState(() {
          userName = 'No Name Found';
        });
      }
    }, onError: (error) {
      debugPrint('Error listening to user details: $error');
      setState(() {
        userName = 'Error Loading Name';
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    bool isMobile = screen.width < 800;

    return Scaffold(
      body: Column(
        children: [
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
              // color: Colors.pink.shade100,
              margin:
                  !isMobile
                      ? EdgeInsets.symmetric(
                        horizontal: screen.width * 0.1,
                        // vertical: screen.height * 0.05,
                      )
                      : EdgeInsets.zero,
              child: ListView(
                controller: scrollController,
                children: [
                  ProfileSection(
                    userName: userName,
                    mobileNumber: mobileNumber,
                    emailId: emailId,
                    profilePic: profilePic,
                    bgImage: bgImage,
                  ), // 👈 Pass dynamic name
                  const SizedBox(height: 20),
                  ContactRow(key: contactKey,
                    mobileNumber: mobileNumber,
                    emailId: emailId,
                    profilePic: profilePic,
                    bgImage: bgImage,),
                  const Divider(),
                  const SizedBox(height: 30),
                  SkillsAndExperience(key: experienceKey),
                  const SizedBox(height: 40),
                  ProjectsSection(key: projectsKey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}

/// HEADER BAR
class HeaderBar extends StatelessWidget {
  final Function(String section) onNavItemTap; // 👈 Accept callback

  const HeaderBar({super.key, required this.onNavItemTap});

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
          _HeaderItem(
            title: 'Experience',
            onTap: () => onNavItemTap('Experience'),
          ),
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

  const _HeaderItem({required this.title, required this.onTap});

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
  final String userName;
  final String mobileNumber;
  final String emailId;
  final String profilePic;
  final String bgImage;

  const ProfileSection({
    super.key,
    required this.userName,
    required this.mobileNumber,
    required this.emailId,
    required this.profilePic,
    required this.bgImage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive size logic
        final bool isMobile = constraints.maxWidth < 800;
        final double bannerHeight = isMobile ? 200 : 300;
        final double avatarRadius = isMobile ? 70 : 100;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background banner
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    bgImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: bannerHeight,
                  ),
                ),

                // Profile photo overlay
                Positioned(
                  top: bannerHeight - avatarRadius,
                  left: isMobile ? 20 : 50,
                  child: CircleAvatar(
                    radius: avatarRadius + 5,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: NetworkImage(profilePic),
                    ),
                  ),
                ),
              ],
            ),

            // Add spacing equal to the half of avatar radius to push next content below it
            SizedBox(height: avatarRadius + 30),

            // User info section
            _ProfileInfo(
              userName: userName,

            ),
          ],
        );
      },
    );
  }
}

/// PROFILE INFO (can be styled freely)
class _ProfileInfo extends StatelessWidget {
  final String userName;


  const _ProfileInfo({
    required this.userName,

  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter Developer | Android | iOS | Firebase | REST APIs',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

/// CONTACT ROW (Responsive)
class ContactRow extends StatelessWidget {

  final String mobileNumber;
  final String emailId;
  final String profilePic;
  final String bgImage;


  const ContactRow({super.key,
    required this.mobileNumber,
    required this.emailId,
    required this.profilePic,
    required this.bgImage,});

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    final linkedInUrl = 'https://www.linkedin.com/in/abhishek-deshpande-7b86b1114';
    final mobileUrl = 'tel:+$mobileNumber';
    final mailUrl = 'mailto:$emailId';

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          child:
              isMobile
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContactButton(
                        icon: Icons.call,
                        label: mobileNumber,
                        alignStart: true,
                        onTap: () async {
                          openUrl(mobileUrl);
                        },
                      ),
                      _ContactButton(
                        icon: Icons.mail,
                        label: emailId,
                        alignStart: true,
                        onTap: () async {
                          openUrl(mailUrl);
                        },
                      ),
                      _ContactButton(
                        icon: Icons.insert_link_rounded,
                        label: 'LinkedIn',
                        alignStart: true,
                        onTap: () async {
                          openUrl(linkedInUrl);
                        },
                      ),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ContactButton(icon: Icons.call, label: mobileNumber,
                        onTap: () async {
                          openUrl(mobileUrl);
                        },),
                      _ContactButton(
                        icon: Icons.mail,
                        label: emailId,
                        onTap: () async {
                          openUrl(mailUrl);
                        },
                      ),
                      _ContactButton(
                        icon: Icons.insert_link_rounded,
                        label: 'LinkedIn',
                        onTap: () async {
                          openUrl(linkedInUrl);
                        },
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
  final VoidCallback? onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    this.alignStart = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignStart ? Alignment.centerLeft : Alignment.center,
      child: TextButton.icon(
        onPressed: onTap,
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
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (duration!.isNotEmpty)
          Text(
            duration!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
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
