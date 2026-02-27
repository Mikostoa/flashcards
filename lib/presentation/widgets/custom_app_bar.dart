
import 'package:flutter/material.dart';
import '/presentation/views/constants/custom_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: const TextStyle(
          color: CustomColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: CustomColors.surface.withOpacity(0.0),
      elevation: 0,
      iconTheme: const IconThemeData(color: CustomColors.textPrimary),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

