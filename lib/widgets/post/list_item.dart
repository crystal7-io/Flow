import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.leading,
    this.color,
  });
  final Color? color;
  final String title;
  final void Function() onTap;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      iconColor: color,
      onTap: onTap,
      titleTextStyle: GoogleFonts.googleSansFlex(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
