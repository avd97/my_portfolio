import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
