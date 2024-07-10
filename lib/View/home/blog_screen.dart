import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/network/utils/extra.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/view/bottom_modal_post.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/user/user_hospital/bloc/user_hospital_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/common/utils/file_selector.dart';
import 'package:joy_app/view/home/components/blog_card.dart';
import 'package:joy_app/view/social_media/chats.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import '../../modules/user/user_doctor/bloc/user_doctor_bloc.dart';

class UserBlogScreen extends StatelessWidget {
  UserBlogScreen({super.key});

  final mediaController = Get.find<MediaPostController>();
  final TextEditingController imageurl = TextEditingController();
  ProfileController _profileController = Get.put(ProfileController());
  UserBloodBankController _userBloodBankController =
      Get.put(UserBloodBankController());
  UserHospitalController _userHospitalController =
      Get.put(UserHospitalController());
  UserDoctorController _userDoctorController = Get.put(UserDoctorController());

  FriendsSocialController _friendSocialController =
      Get.put(FriendsSocialController());

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
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => CreatePostModal(),
                            );
                          },
                          child: TextField(
                            enabled: false,
                            maxLines: null,
                            cursorColor: AppColors.borderColor,
                            style: CustomTextStyles.lightTextStyle(
                                color: AppColors.borderColor),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              fillColor: Colors.transparent,
                              hintText: "What's on your mind?",
                              hintStyle: CustomTextStyles.lightTextStyle(
                                  color: AppColors.borderColor),
                            ),
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
                Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: mediaController.allPost.length,
                    itemBuilder: ((context, index) {
                      final data = mediaController.allPost[index];
                      return Column(
                        children: [
                          MyCustomWidget(
                            postTime: data.createdAt.toString(),
                            id: data.createdBy.toString(),
                            imgPath: data.image.toString(),
                            isLiked: true,
                            isReply: false,
                            showImg: (data.image == null || data.image!.isEmpty)
                                ? false
                                : true,
                            postName: data.name.toString(),
                            text: data.description.toString(),
                          ),
                          (data.comments!.length > 0)
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data.comments!.length,
                                  itemBuilder: ((context, index) {
                                    final commen = data.comments![index];
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                            radius: 13,
                                            backgroundImage: NetworkImage(
                                              "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                            )),
                                        SizedBox(
                                            width: 2.w), // Adjust as needed

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              commen.commentId.toString(),
                                              style: CustomTextStyles
                                                  .w600TextStyle(
                                                      letterspacing: 0.5,
                                                      size: 13.21,
                                                      color: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? AppColors.whiteColor
                                                          : Color(0xff19295C)),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  commen.comment.toString(),
                                                  style: CustomTextStyles
                                                      .lightTextStyle(
                                                          size: 11.28),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Row(
                                              children: [
                                                Text('Like',
                                                    style: CustomTextStyles
                                                        .darkHeadingTextStyle(
                                                            size: 10,
                                                            color: ThemeUtil
                                                                    .isDarkMode(
                                                                        context)
                                                                ? Color(
                                                                    0xffC9C9C9)
                                                                : Color(
                                                                    0xff60709D))),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 30.0),
                                                  child: Text('Reply',
                                                      style: CustomTextStyles
                                                          .darkHeadingTextStyle(
                                                              size: 10,
                                                              color: ThemeUtil
                                                                      .isDarkMode(
                                                                          context)
                                                                  ? Color(
                                                                      0xffC9C9C9)
                                                                  : Color(
                                                                      0xff60709D))),
                                                ),
                                                Text(
                                                    getElapsedTime(commen
                                                        .createdAt
                                                        .toString()),
                                                    style: CustomTextStyles
                                                        .lightTextStyle(
                                                            size: 10,
                                                            color: ThemeUtil
                                                                    .isDarkMode(
                                                                        context)
                                                                ? Color(
                                                                    0xffC9C9C9)
                                                                : Color(
                                                                    0xff60709D)))
                                              ],
                                            ),
                                            SizedBox(height: 1.h),
                                          ],
                                        )
                                      ],
                                    );
                                  }))
                              : Container(),
                          SizedBox(height: 2.h),
                        ],
                      );
                    }))),
              ],
            ),
          ),
        ));
  }
}
