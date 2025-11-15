import 'package:flutter/material.dart';

class RegularAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const RegularAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 35,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
        ),
        padding: const EdgeInsets.only(left: 16),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
