import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String userName;
  final String mobileNumber;
  final String emailId;
  final String profilePic;
  final String bgImage;
  final bool isLoading;

  const ProfileSection({
    super.key,
    required this.userName,
    required this.mobileNumber,
    required this.emailId,
    required this.profilePic,
    required this.bgImage,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being fetched
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  child: bgImage.isNotEmpty && bgImage != 'Loading...'
                      ? CachedNetworkImage(
                          imageUrl: bgImage,
                          width: double.infinity,
                          height: bannerHeight,
                          fit: BoxFit.cover,
                          cacheManager: null,
                          placeholder: (context, url) => Container(
                            width: double.infinity,
                            height: bannerHeight,
                            color: Colors.teal.shade100,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            debugPrint('Background image error: $error for URL: $url');
                            return Container(
                              width: double.infinity,
                              height: bannerHeight,
                              color: Colors.teal.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Banner image unavailable',
                                    style: TextStyle(color: Colors.teal.shade600),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: bannerHeight,
                          color: Colors.teal.shade100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.teal,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No banner image',
                                style: TextStyle(color: Colors.teal.shade600),
                              ),
                            ],
                          ),
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
                      backgroundColor: Colors.grey.shade200,
                      child: profilePic.isNotEmpty && profilePic != 'Loading...'
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: profilePic,
                                fit: BoxFit.cover,
                                width: avatarRadius * 2,
                                height: avatarRadius * 2,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) {
                                  debugPrint('Profile image error: $error for URL: $url');
                                  return const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
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
