import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;

  const CommonAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title != null ? Text(title!) : null,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
