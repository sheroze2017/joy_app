import 'package:flutter/material.dart';

import '../styles/custom_textstyle.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final List<Widget> actions;

  HomeAppBar({
    required this.title,
    required this.leading,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: leading,
      centerTitle: true,
      title: Text(
        title,
        style: CustomTextStyles.darkTextStyle(color: Color(0xff374151)),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
