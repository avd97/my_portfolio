import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/theme_cubit.dart';

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({super.key});

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.watch<ThemeCubit>().state == ThemeMode.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.read<ThemeCubit>().toggleTheme();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 72,
          height: 36,
          padding: const EdgeInsets.all(4),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                const Color(0xFF434343),
                const Color(0xFF000000),
              ]
                  : [
                const Color(0xFF56CCF2),
                const Color(0xFF2F80ED),
              ],
            ),

            borderRadius: BorderRadius.circular(30),

            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? Colors.black.withOpacity(0.25)
                    : Colors.black.withOpacity(0.12),
                blurRadius: isHovered ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment:
            isDark
                ? Alignment.centerRight
                : Alignment.centerLeft,

            child: Container(
              width: 28,
              height: 28,

              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: Icon(
                isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 18,
                color: isDark
                    ? Colors.black
                    : Colors.orange,
              ),
            ),
          ),
        ),
      ),
    );
  }
}