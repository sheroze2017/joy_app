import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/home/components/blog_card.dart';
import 'package:joy_app/view/social_media/chats.dart';
import 'package:sizer/sizer.dart';

class UserBlogScreen extends StatelessWidget {
  const UserBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
          isImage: true,
          leading: Text(''),
          showBottom: true,
          title: '',
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff191919)
                    : Color(0xffF3F4F6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: SvgPicture.asset('Assets/icons/search-normal.svg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 22.56, left: 8),
              child: InkWell(
                onTap: () {
                  Get.to(AllChats());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff191919)
                        : Color(0xffF3F4F6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: SvgPicture.asset('Assets/icons/sms.svg'),
                    ),
                  ),
                ),
              ),
            )
          ],
          showIcon: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.56),
                  child: Divider(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff1F2228)
                        : AppColors.lightGreyColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6.56),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: AppColors.borderColor,
                          style: CustomTextStyles.lightTextStyle(
                              color: AppColors.borderColor),
                          decoration: InputDecoration(
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            fillColor: Colors.transparent,
                            hintText: "What's on your mind, Hashem?",
                            hintStyle: CustomTextStyles.lightTextStyle(
                                color: AppColors.borderColor),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(54),
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xff121212)
                              : AppColors.whiteColorf9f,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: Row(
                            children: [
                              SvgPicture.asset('Assets/icons/camera.svg'),
                              SizedBox(width: 2.w),
                              Text(
                                "Photo",
                                style: CustomTextStyles.lightTextStyle(
                                  color: AppColors.borderColor,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                MyCustomWidget(
                  isLiked: true,
                  isReply: true,
                  postName: 'Sheroze',
                  text:
                      'Hey pals ! Had my third day of chemo. feeling much better.',
                ),
                SizedBox(
                  height: 3.h,
                ),
                MyCustomWidget(
                  isLiked: false,
                  showImg: false,
                  isReply: false,
                  postName: 'Mille Brown',
                  text: 'Feeling depressed today.',
                )
              ],
            ),
          ),
        ));
  }
}
