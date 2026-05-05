import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/features/web/bloc/home_page_bloc.dart';
import 'package:my_portfolio/features/web/bloc/services_bloc.dart';
import 'package:my_portfolio/features/web/models/service_item.dart';
import 'package:my_portfolio/features/web/widgets/services_dialog.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  void _showServicesDialog(BuildContext context) {
    final servicesBloc = context.read<ServicesBloc>();
    final phoneNumber = context.read<HomePageBloc>().state.mobileNumber;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Services Dialog",
      barrierColor: Colors.white.withOpacity(0.2), // light white overlay
      transitionDuration: const Duration(milliseconds: 400),

      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: servicesBloc,
          child: ServicesDialog(adminPhoneNumber: phoneNumber),
        );
      },

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Stack(
          children: [
            // 🔹 Blur background
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6,
                sigmaY: 6,
              ),
              child: Container(
                color: Color(0xFF6C6C6C).withOpacity(0.1),
              ),
            ),

            // 🔹 Animated dialog
            FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: child,
              ),
            ),
          ],
        );
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00FF22), // green
                      Color(0xFF99FF00), // light green
                      Color(0xFFFFF100), // light green
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showServicesDialog(context),
                  icon: const Icon(Icons.contact_mail),
                  label: const Text('Request For Services'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // ✅ Important
                    shadowColor: Colors.transparent,     // ✅ Remove default shadow
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight(600)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
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
