import 'package:flutter/material.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  CustomAppBar({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
          ),
          Text(
            title,
            style: CustomTextStyles.darkTextStyle(color: Color(0xff374151)),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
