import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
