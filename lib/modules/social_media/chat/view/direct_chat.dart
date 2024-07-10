import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/chat_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class DirectMessageScreen extends StatelessWidget {
  const DirectMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(username: 'Awais Arshad', status: 'Offline'),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              ListView.builder(
                itemCount: 2, // Example message count
                itemBuilder: (context, index) {
                  // Replace this with your chat message widget
                  return Column(
                    children: [
                      MyMessage(
                        message: 'Do you know what time is it?',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: YourMessage(message: "It’s morning in Tokyo 😎"),
                      ),
                    ],
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset('Assets/icons/camera-2.svg'),
                      SizedBox(
                        width: 2.w,
                      ),
                      SvgPicture.asset('Assets/icons/gallery.svg'),
                      SizedBox(
                        width: 2.w,
                      ),
                      SvgPicture.asset('Assets/icons/microphone-2.svg'),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                        decoration: BoxDecoration(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xff121212)
                              : Color(0x05000000),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    border: InputBorder.none,
                                    hintText: 'Aa',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.transparent),
                              ),
                            ),
                            Icon(
                              Icons.emoji_emotions,
                              color: Color(0xffA5ABB3),
                            )
                          ],
                        ),
                      )),
                      SizedBox(width: 3.w),
                      SvgPicture.asset('Assets/icons/send-2.svg'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Stack(
      //   alignment: new FractionalOffset(.5, 1.0),
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      //       child: Row(
      //         children: [
      //           SvgPicture.asset('Assets/icons/camera-2.svg'),
      //           SvgPicture.asset('Assets/icons/gallery.svg'),
      //           SvgPicture.asset('Assets/icons/microphone-2.svg'),
      //           SvgPicture.asset('Assets/icons/microphone-2.svg'),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

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

  const YourMessage({super.key, required this.message});

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
