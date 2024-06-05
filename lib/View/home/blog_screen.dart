import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/home/components/blog_card.dart';
import 'package:joy_app/view/social_media/chats.dart';
import 'package:sizer/sizer.dart';

class UserBlogScreen extends StatelessWidget {
  const UserBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
            showBottom: true,
            title: '',
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SvgPicture.asset('Assets/icons/joy-icon-small.svg'),
            ),
            actions: [
              SvgPicture.asset('Assets/icons/searchbg.svg'),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 8),
                child: InkWell(
                    onTap: () {
                      Get.to(AllChats());
                    },
                    child: SvgPicture.asset('Assets/icons/messagebg.svg')),
              )
            ],
            showIcon: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: AppColors.borderColor,
                        style: CustomTextStyles.lightTextStyle(
                            color: AppColors.borderColor),
                        decoration: InputDecoration(
                          hintText: "What's on your mind, Hashem?",
                          hintStyle: CustomTextStyles.lightTextStyle(
                              color: AppColors.borderColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(54),
                        color: AppColors.whiteColorf9f,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
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
