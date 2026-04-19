import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_portfolio/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service Model
class ServiceItem {
  final IconData icon;
  final String title;
  final String description;

  const ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Services List (Dynamic - Used everywhere)
const List<ServiceItem> servicesList = [
  ServiceItem(
    icon: Icons.phone_android,
    title: 'Mobile App Development',
    description: 'Native Android & iOS apps using Flutter',
  ),
  ServiceItem(
    icon: Icons.storage,
    title: 'Database Design & Development',
    description: 'MySQL, PostgreSQL, SQLite, Firebase',
  ),
  ServiceItem(
    icon: Icons.api,
    title: 'API Development & Integration',
    description: 'REST APIs, GraphQL, Backend Services',
  ),
  ServiceItem(
    icon: Icons.map,
    title: 'Google Maps API Integration',
    description: 'Location services, Maps, Geocoding',
  ),
  ServiceItem(
    icon: Icons.payment,
    title: 'Payment Gateway Integration',
    description: 'Razorpay, CCAvenue, Stripe integration',
  ),
  ServiceItem(
    icon: Icons.cloud,
    title: 'Firebase Integration',
    description: 'Auth, Database, Storage, Analytics',
  ),
  ServiceItem(
    icon: Icons.design_services,
    title: 'UI/UX Design',
    description: 'Modern, responsive, user-friendly designs',
  ),
  ServiceItem(
    icon: Icons.publish,
    title: 'App Store Deployment',
    description: 'Play Store & App Store publishing',
  ),
  ServiceItem(
    icon: Icons.support,
    title: 'Maintenance & Support',
    description: 'Bug fixes, updates, ongoing support',
  ),
  ServiceItem(
    icon: Icons.lightbulb,
    title: 'Consultation',
    description: 'Technical advice, project planning',
  ),
  ServiceItem(
    icon: Icons.add_circle_outline,
    title: 'Others',
    description: 'Enter your custom service requirement',
  ),
];

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
  final servicesKey = GlobalKey();

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

    _userSubscription = ref.onValue.listen(
      (DatabaseEvent event) {
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
      },
      onError: (error) {
        debugPrint('Error listening to user details: $error');
        setState(() {
          userName = 'Error Loading Name';
        });
      },
    );
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
                case 'Services':
                  Scrollable.ensureVisible(
                    servicesKey.currentContext!,
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
                  SizedBox(height: 16),
                  ProfileSection(
                    userName: userName,
                    mobileNumber: mobileNumber,
                    emailId: emailId,
                    profilePic: profilePic,
                    bgImage: bgImage,
                  ), // 👈 Pass dynamic name
                  const SizedBox(height: 20),
                  ContactRow(
                    key: contactKey,
                    mobileNumber: mobileNumber,
                    emailId: emailId,
                    profilePic: profilePic,
                    bgImage: bgImage,
                  ),
                  const Divider(),
                  const SizedBox(height: 30),
                  SkillsAndExperience(key: experienceKey),
                  const SizedBox(height: 40),
                  ServicesSection(key: servicesKey),
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
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade400,
      width: screenSize.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
            _HeaderItem(title: 'Services', onTap: () => onNavItemTap('Services')),
          ],
        ),
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
        final double bannerHeight = isMobile ? 200 : 250;
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
                  child: CachedNetworkImage(
                    imageUrl: bgImage,
                    width: double.infinity,
                    height: bannerHeight,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.indigo.shade200,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Center(
                        child: Text(
                          'Error loading banner image: $error',
                          style: TextStyle(color: Colors.red.shade400),
                        ),
                      );
                    },
                    // child: Image.network(
                    //   bgImage,
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    //   height: bannerHeight,
                    // ),
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
            _ProfileInfo(userName: userName),
          ],
        );
      },
    );
  }
}

/// PROFILE INFO (can be styled freely)
class _ProfileInfo extends StatelessWidget {
  final String userName;

  const _ProfileInfo({required this.userName});

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

  const ContactRow({
    super.key,
    required this.mobileNumber,
    required this.emailId,
    required this.profilePic,
    required this.bgImage,
  });

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkedInUrl =
        'https://www.linkedin.com/in/abhishek-deshpande-7b86b1114';
    final mobileUrl = 'tel:+$mobileNumber';
    final mailUrl = 'mailto:$emailId';

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 50,
            vertical: 8,
          ),
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
                      _ContactButton(
                        icon: Icons.call,
                        label: mobileNumber,
                        onTap: () async {
                          openUrl(mobileUrl);
                        },
                      ),
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
    this.onTap,
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

/// PROJECTS SECTION
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Projects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),
              _ProjectCard(
                title: '1. Marathi Vachan (Language Learning App)',
                details:
                    '• Developed a language learning app for nursery kids to learn Marathi, Hindi, and English through interactive games and quizzes.\n'
                    '• Implemented balloon-popping games and quizzes for engaging language learning.\n'
                    '• Integrated text-to-speech functionality for correct pronunciation and interactive learning.\n'
                    '• Designed a kid-friendly UI with simple navigation and vibrant visuals.\n'
                    '• Technical Skills: Flutter, Provider, Text-to-Speech.',
              ),
              const SizedBox(height: 16),
              _ProjectCard(
                title: '2. CA Food (Food Ordering App)',
                details:
                    '• Developed a cross-platform food ordering app for Android and iOS using Flutter.\n'
                    '• Enabled real-time order tracking with Google Maps and integrated Razorpay for secure payments.\n'
                    '• Ensured consistent user experience across both platforms.\n'
                    '• Technical Skills: Flutter, Provider, Google Map, Firebase.',
              ),
              const SizedBox(height: 16),
              _ProjectCard(
                title: '3. Entie (Business Networking App)',
                details:
                    '• Spearheaded the development of a business networking app connecting Startups, Co-founders and Investors to create opportunities and foster business growth.\n'
                    '• Implemented a real-time chat feature using Firebase Real-time Database.\n'
                    '• Integrated Razorpay for secure payment processing.\n'
                    '• Technical Skills: Android, Firebase.',
              ),
              const SizedBox(height: 16),
              _ProjectCard(
                title: '4. Flourpicker (E-Commerce App)',
                details:
                    '• Developed an e-commerce platform for ordering fresh flour with custom mixes.\n'
                    '• Integrated Swagger, Firebase, and Razorpay.\n'
                    '• Technical Skills: Android, Firebase, Google Map.',
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String details;

  const _ProjectCard({required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
              const SizedBox(height: 12),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SERVICES SECTION
class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  void _showServicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ServicesDialog(adminPhoneNumber: "+0919975362272");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'I offer a comprehensive range of mobile app development and software solutions to help bring your ideas to life. Here are the services I provide:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  childAspectRatio: isMobile ? 0.8 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: servicesList.length,
                itemBuilder: (context, index) {
                  return _ServiceCard(
                    service: servicesList[index],
                    isMobile: false,
                  );
                },
              ),
              const SizedBox(height: 30),
              Align(
                alignment: AlignmentGeometry.centerEnd,
                child: ElevatedButton.icon(
                  onPressed: () => _showServicesDialog(context),
                  icon: const Icon(Icons.contact_mail),
                  label: const Text('Request Services'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final bool isMobile;

  const _ServiceCard({required this.service, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.indigo.shade50,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(service.icon, size: 32, color: Colors.indigo),
            const SizedBox(height: 10),
            Text(
              service.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// SERVICES DIALOG
class ServicesDialog extends StatefulWidget {
  final String? adminPhoneNumber;

  const ServicesDialog({super.key, this.adminPhoneNumber});

  @override
  State<ServicesDialog> createState() => _ServicesDialogState();
}

class _ServicesDialogState extends State<ServicesDialog> {
  final Set<String> selectedServices = {};
  final TextEditingController nameController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController costingController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController otherServiceController = TextEditingController();

  bool showForm = false;
  bool isOthersSelected = false;
  bool _isFormSubmitted = false;
  String? _otherServiceError;

  @override
  void dispose() {
    nameController.dispose();
    projectController.dispose();
    costingController.dispose();
    deadlineController.dispose();
    otherServiceController.dispose();
    super.dispose();
  }

  void _toggleService(String service) {
    setState(() {
      if (service == 'Others') {
        isOthersSelected = !isOthersSelected;
        if (!isOthersSelected) {
          selectedServices.remove(service);
          otherServiceController.clear();
        } else {
          selectedServices.add(service);
        }
      } else {
        if (selectedServices.contains(service)) {
          selectedServices.remove(service);
        } else {
          selectedServices.add(service);
        }
      }
    });
  }

  void _proceedToForm() {
    if (selectedServices.isNotEmpty) {
      setState(() {
        showForm = true;
        _isFormSubmitted = false;
        _otherServiceError = null;
      });
    }
  }

  String _buildSelectedServicesText() {
    List<String> finalServicesList = List.from(selectedServices);
    if (isOthersSelected) {
      finalServicesList.remove('Others');
      if (otherServiceController.text.trim().isNotEmpty) {
        finalServicesList.add(otherServiceController.text.trim());
      }
    }
    return '• ' + finalServicesList.join('\n• ');
  }

  void _sendRequest() {
    final name = nameController.text.trim();
    final project = projectController.text.trim();

    setState(() {
      _isFormSubmitted = true;
      _otherServiceError = null;
    });

    // Check if Others is selected but no custom service name entered
    if (isOthersSelected && otherServiceController.text.trim().isEmpty) {
      setState(() {
        _otherServiceError = 'Please enter custom service name';
      });
      return;
    }

    // If validation passes, proceed with email sending
    if (name.isEmpty || project.isEmpty) {
      return; // Validation will be displayed in the form
    }

    final costing = costingController.text.trim().isEmpty ? 'NA' : costingController.text.trim();
    final deadline = deadlineController.text.trim().isEmpty ? 'NA' : deadlineController.text.trim();

    // Build services list
    List<String> finalServicesList = List.from(selectedServices);
    if (isOthersSelected) {
      finalServicesList.remove('Others');
      finalServicesList.add(otherServiceController.text.trim());
    }

    final servicesText = finalServicesList.join(', ');
    final subject = 'Service Request from $name';
    final body = '''
═══════════════════════════════════════════
          SERVICE REQUEST INQUIRY
═══════════════════════════════════════════

Dear Admin,

I hope you are doing well.

I am writing to submit a formal service request for your consideration.

───────────────────────────────────────────
CLIENT INFORMATION
───────────────────────────────────────────

Name:                    $name
Date:                    ${DateTime.now().toString().split('.')[0]}

───────────────────────────────────────────
PROJECT DETAILS
───────────────────────────────────────────

Project Description:     $project
Budget/Costing:          $costing
Expected Deadline:       $deadline

───────────────────────────────────────────
REQUESTED SERVICES
───────────────────────────────────────────

$servicesText

───────────────────────────────────────────

Thank you for considering this service request. I look forward to discussing the project details and exploring how we can collaborate to achieve the desired outcomes.

Please feel free to reach out if you require any additional information or clarification regarding this request.

Best regards,
$name

═══════════════════════════════════════════
''';

    final emailUri = Uri(
      scheme: 'mailto',
      path: 'abhi.pande215@gmail.com',
      queryParameters: {'subject': subject, 'body': body},
    );

    launchUrl(emailUri, mode: LaunchMode.externalApplication);
    Navigator.of(context).pop();
  }

  void _sendViaWhatsApp() {
    final name = nameController.text.trim();
    final project = projectController.text.trim();

    setState(() {
      _isFormSubmitted = true;
      _otherServiceError = null;
    });

    // Check if Others is selected but no custom service name entered
    if (isOthersSelected && otherServiceController.text.trim().isEmpty) {
      setState(() {
        _otherServiceError = 'Please enter custom service name';
      });
      return;
    }

    // If validation passes, proceed with WhatsApp sending
    if (name.isEmpty || project.isEmpty) {
      return; // Validation will be displayed in the form
    }

    if (widget.adminPhoneNumber == null || widget.adminPhoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp number not available'),
        ),
      );
      return;
    }

    final costing = costingController.text.trim().isEmpty ? 'NA' : costingController.text.trim();
    final deadline = deadlineController.text.trim().isEmpty ? 'NA' : deadlineController.text.trim();

    // Build services list
    List<String> finalServicesList = List.from(selectedServices);
    if (isOthersSelected) {
      finalServicesList.remove('Others');
      finalServicesList.add(otherServiceController.text.trim());
    }

    final servicesText = finalServicesList.join(', ');
    final message = '''
*═══════════════════════════════════════════*
*          SERVICE REQUEST INQUIRY*
*═══════════════════════════════════════════*

Hi Abhishek,\n
I wanted to reach out regarding a service request. Please find the details below.

*───────────────────────────────────────────*
*CLIENT INFORMATION*
*───────────────────────────────────────────*

*Name:* $name\n
*Date:* ${DateTime.now().toString().split('.')[0]}

*───────────────────────────────────────────*
*PROJECT DETAILS*
*───────────────────────────────────────────*

*Project Description:* $project\n
*Budget/Costing:* $costing\n
*Expected Deadline:* $deadline\n

*───────────────────────────────────────────*
*REQUESTED SERVICES*
*───────────────────────────────────────────*

$servicesText\n

*───────────────────────────────────────────*

Thanks for considering this request. Looking forward to hearing from you!\n

Best regards,\n
$name

*═══════════════════════════════════════════*
''';

    String phoneNumber = widget.adminPhoneNumber!.replaceAll(RegExp(r'[^0-9+]'), '');
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91$phoneNumber';
    }

    final whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.build, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  showForm ? 'Project Requirements' : 'Select Services',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!showForm) ...[
              const Text(
                'Choose the services you\'re interested in:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: servicesList.length,
                  itemBuilder: (context, index) {
                    final service = servicesList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: Row(
                            children: [
                              Icon(service.icon, size: 20, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  service.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          value: selectedServices.contains(service.title),
                          onChanged: (bool? value) => _toggleService(service.title),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        // Show text field for Others service
                        if (service.title == 'Others' && isOthersSelected)
                          Padding(
                            padding: const EdgeInsets.only(left: 32, right: 8, bottom: 8),
                            child: TextField(
                              controller: otherServiceController,
                              decoration: InputDecoration(
                                hintText: 'Enter custom service name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed:
                        selectedServices.isNotEmpty ? _proceedToForm : null,
                    child: const Text('Proceed'),
                  ),
                ],
              ),
            ]
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please provide your project details:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      // Display selected services
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Services:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _buildSelectedServicesText(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(),
                          errorText: _isFormSubmitted && nameController.text.trim().isEmpty
                              ? 'Name is required'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: projectController,
                        decoration: InputDecoration(
                          labelText: 'Project Description',
                          border: OutlineInputBorder(),
                          errorText: _isFormSubmitted && projectController.text.trim().isEmpty
                              ? 'Project description is required'
                              : null,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: costingController,
                        decoration: const InputDecoration(
                          labelText: 'Budget/Costing (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: deadlineController,
                        decoration: const InputDecoration(
                          labelText: 'Deadline (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isOthersSelected)
                        TextField(
                          controller: otherServiceController,
                          decoration: InputDecoration(
                            labelText: 'Custom Service Name',
                            border: OutlineInputBorder(),
                            errorText: _otherServiceError,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isFormSubmitted = false;
                                _otherServiceError = null;
                              });
                              setState(() => showForm = false);
                            },
                            child: const Text('Back'),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: _sendViaWhatsApp,
                            icon: const Icon(Icons.call),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _sendRequest,
                            child: const Icon(Icons.mail),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
