import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/utils/constant/constant.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:sizer/sizer.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String status;
  final String userId;

  const ChatAppBar({
    Key? key,
    required this.username,
    required this.status,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,

      automaticallyImplyLeading: false, // Remove back arrow icon
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Get.back();
          // Add your navigation logic here
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.to(
                  MyProfileScreen(
                    isFriend: true,
                    myProfile: true,
                    friendId: userId,
                  ),
                  transition: Transition.native);
            },
            child: ClipOval(
              child: Image.network(
                CustomConstant.nullUserImage,
                width: 5.h,
                height: 5.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                username,
                style: CustomTextStyles.darkTextStyle(
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0xff374151)),
              ),
              Text('', style: CustomTextStyles.lightSmallTextStyle()),
            ],
          ),
        ],
      ),
      actions: [
        // InkWell(
        //   onTap: () {},
        //   child: Image(
        //     color: ThemeUtil.isDarkMode(context) ? Color(0XFFC5D3E3) : null,
        //     image: AssetImage(
        //       'Assets/icons/call.png',
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   width: 5.w,
        // ),
        // InkWell(
        //   onTap: () {},
        //   child: Image(
        //     color: ThemeUtil.isDarkMode(context) ? Color(0XFFC5D3E3) : null,
        //     image: AssetImage('Assets/icons/camera.png'),
        //   ),
        // ),
        // SizedBox(
        //   width: 3.w,
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
