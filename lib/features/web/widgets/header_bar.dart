import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final Function(String section) onNavItemTap;

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
