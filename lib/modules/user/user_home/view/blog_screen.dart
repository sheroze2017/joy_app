import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/view/bottom_modal_post.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/user/user_hospital/bloc/user_hospital_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/home/components/blog_card.dart';
import 'package:joy_app/modules/social_media/chat/view/chats.dart';
import 'package:sizer/sizer.dart';
import '../../../social_media/media_post/bloc/medai_posts_bloc.dart';
import '../../user_doctor/bloc/user_doctor_bloc.dart';

class UserBlogScreen extends StatelessWidget {
  UserBlogScreen({super.key});

  final mediaController = Get.put(MediaPostController());
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
                  Get.to(AllChats(), transition: Transition.native);
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
        body: RefreshIndicator(
          onRefresh: () async {
            mediaController.getAllPost();
          },
          child: SingleChildScrollView(
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
                                fillColor: const Color.fromRGBO(0, 0, 0, 0),
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
                  Obx(() => mediaController.fetchPostLoader.value
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: ((context, index) {
                            return ShimmerWidget();
                          }))
                      : mediaController.allPost.isEmpty
                          ? Center(
                              child: Text(
                                "No posts found",
                                style: CustomTextStyles.lightTextStyle(),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: mediaController.allPost.length,
                              itemBuilder: ((context, index) {
                                final data = mediaController.allPost.reversed
                                    .toList()[index];
                                return Column(
                                  children: [
                                    Obx(() => MyCustomWidget(
                                          cm: mediaController.allPost.reversed
                                                  .toList()[index]
                                                  .comments ??
                                              [],
                                          postIndex: index,
                                          postId: data.postId.toString(),
                                          postTime: data.createdAt.toString(),
                                          id: data.createdBy.toString(),
                                          imgPath: data.image.toString(),
                                          isLiked: data.isMyLike ?? false, // Use is_my_like from API response
                                          isReply: false,
                                          showImg: (data.image == null ||
                                                  data.image!.isEmpty)
                                              ? false
                                              : true,
                                          postName: data.name.toString(),
                                          text: data.description.toString(),
                                          userImage: data.user_image.toString(),
                                        )),
                                  ],
                                );
                              }))),
                ],
              ),
            ),
          ),
        ));
  }
}
