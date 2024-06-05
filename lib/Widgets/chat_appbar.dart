import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String status;

  const ChatAppBar({
    Key? key,
    required this.username,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          ClipOval(
            child: Image.network(
              'https://via.placeholder.com/50',
              width: 5.h,
              height: 5.h,
              fit: BoxFit.cover,
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
                style: CustomTextStyles.darkTextStyle(color: Color(0xff374151)),
              ),
              Text(status, style: CustomTextStyles.lightSmallTextStyle()),
            ],
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {},
          child: Image(
            image: AssetImage('Assets/icons/call.png'),
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        InkWell(
          onTap: () {},
          child: Image(
            image: AssetImage('Assets/icons/camera.png'),
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
