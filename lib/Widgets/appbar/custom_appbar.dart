import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final List<Widget> actions;
  final bool showIcon;
  final Color? bgColor;
  bool? showBottom;
  bool isImage;

  HomeAppBar(
      {required this.title,
      required this.leading,
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
      leading: isImage
          ? null
          : showIcon
              ? InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: leading,
                )
              : null,
      centerTitle: isImage ? false : true,
      title: isImage
          ? Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.56),
                    child: SvgPicture.asset('Assets/icons/joy-icon-small.svg'),
                  ),
                );
              },
            )
          : Text(
              title,
              style: CustomTextStyles.darkTextStyle(
                  color: ThemeUtil.isDarkMode(context)
                      ? AppColors.whiteColor
                      : Color(0xff374151)),
            ),
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
