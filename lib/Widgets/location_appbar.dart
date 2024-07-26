import 'package:flutter/material.dart';

class LocationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final bool showIcon;
  final Color? bgColor;
  bool? showBottom;
  bool isImage;

  LocationAppBar(
      {required this.title,
      required this.actions,
      required this.showIcon,
      this.showBottom = false,
      this.isImage = false,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: bgColor == null ? Colors.transparent : bgColor,
      elevation: 0,
      titleSpacing: isImage ? 0 : null,
      automaticallyImplyLeading: isImage ? !isImage : true,
      centerTitle: isImage ? false : true,
      title: title,
      actions: actions,
      bottom: showBottom == true
          ? PreferredSize(
              preferredSize: preferredSize,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  thickness: 0.2,
                  color: Color(0xffF1F4F5),
                ),
              ))
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
