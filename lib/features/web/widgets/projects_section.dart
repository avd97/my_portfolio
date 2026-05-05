import 'package:flutter/material.dart';

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
