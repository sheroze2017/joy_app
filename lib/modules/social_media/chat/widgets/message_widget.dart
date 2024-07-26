import 'package:flutter/material.dart';
import 'package:joy_app/core/utils/constant/constant.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class MyMessage extends StatelessWidget {
  final String message;

  const MyMessage({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Row(
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
        Container(
          width: 56.4.w,
          decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff151515)
                  : Color.fromRGBO(0, 0, 0, 0.06),
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(message,
                  style: CustomTextStyles.lightTextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? AppColors.whiteColor
                          : Colors.black,
                      size: 16))),
        )
      ],
    );
  }
}

class YourMessage extends StatelessWidget {
  final String message;
  final String name;

  const YourMessage({super.key, required this.message, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Spacer(),
        Container(
          width: 56.4.w,
          decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xffC5D3E3)
                  : Color(0xff1C2A3A),
              borderRadius: BorderRadius.circular(18)),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(message,
                  style: CustomTextStyles.lightTextStyle(
                      heigh: 0.6,
                      color: ThemeUtil.isDarkMode(context)
                          ? AppColors.blackColor
                          : Colors.white,
                      size: 16))),
        ),
        SizedBox(
          width: 2.w,
        ),
        Image(
          image: AssetImage(
            'Assets/icons/read.png',
          ),
          color: ThemeUtil.isDarkMode(context) ? Color(0xffC5D3E3) : null,
        )
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;
  final bool sending;
  final String date;
  MessageBubble(
      {required this.msgText,
      required this.msgSender,
      required this.user,
      this.sending = false,
      this.date = ""});

  @override
  Widget build(BuildContext context) {
    return user
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Spacer(),
              Container(
                width: 56.4.w,
                decoration: BoxDecoration(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xffC5D3E3)
                        : Color(0xff1C2A3A),
                    borderRadius: BorderRadius.circular(18)),
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(msgText,
                        style: CustomTextStyles.lightTextStyle(
                            heigh: 1,
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.blackColor
                                : Colors.white,
                            size: 16))),
              ),
              SizedBox(
                width: 2.w,
              ),
              Image(
                image: AssetImage(
                  'Assets/icons/read.png',
                ),
                color: ThemeUtil.isDarkMode(context) ? Color(0xffC5D3E3) : null,
              )
            ],
          )
        : Row(
            children: [
              ClipOval(
                child: Image.network(
                  CustomConstant.nullUserImage,
                  width: 5.h,
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                width: 56.4.w,
                decoration: BoxDecoration(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff151515)
                        : Color.fromRGBO(0, 0, 0, 0.06),
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(msgText,
                        style: CustomTextStyles.lightTextStyle(
                            heigh: 1,
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : Colors.black,
                            size: 16))),
              )
            ],
          );
  }
}
