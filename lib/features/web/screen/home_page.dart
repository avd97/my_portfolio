import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/features/web/bloc/home_page_bloc.dart';
import 'package:my_portfolio/features/web/widgets/contact_row.dart';
import 'package:my_portfolio/features/web/widgets/header_bar.dart';
import 'package:my_portfolio/features/web/widgets/profile_section.dart';
import 'package:my_portfolio/features/web/widgets/projects_section.dart';
import 'package:my_portfolio/features/web/widgets/services_section.dart';
import 'package:my_portfolio/features/web/widgets/skills_and_experience.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final experienceKey = GlobalKey();
    final projectsKey = GlobalKey();
    final contactKey = GlobalKey();
    final servicesKey = GlobalKey();

    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
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
                  margin: !isMobile
                      ? EdgeInsets.symmetric(
                          horizontal: screen.width * 0.1,
                        )
                      : EdgeInsets.zero,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      const SizedBox(height: 16),
                      ProfileSection(
                        userName: state.userName,
                        mobileNumber: state.mobileNumber,
                        emailId: state.emailId,
                        profilePic: state.profilePic,
                        bgImage: state.bgImage,
                        isLoading: state.isLoading,
                      ),
                      const SizedBox(height: 20),
                      ContactRow(
                        key: contactKey,
                        mobileNumber: state.mobileNumber,
                        emailId: state.emailId,
                        profilePic: state.profilePic,
                        bgImage: state.bgImage,
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
      },
    );
  }
}
