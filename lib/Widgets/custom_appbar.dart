import 'package:flutter/material.dart';

import '../styles/custom_textstyle.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final List<Widget> actions;
  final bool showIcon;
  final Color? bgColor;

  HomeAppBar(
      {required this.title,
      required this.leading,
      required this.actions,
      required this.showIcon,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor == null ? Colors.transparent : bgColor,
      elevation: 0,
      leading: showIcon ? leading : null,
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
