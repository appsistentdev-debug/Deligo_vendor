import 'package:flutter/material.dart';

class BuildListTile extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback? onTap;

  BuildListTile({required this.image, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      leading: Image.asset(
        image,
        height: 24,
      ),
      title: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      onTap: onTap,
    );
  }
}
