import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/modules/auth/view/profileform_screen.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/home/components/blog_card.dart';
import 'package:joy_app/view/home/profile_screen.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/rounded_button.dart';
import 'all_photos_screen.dart';
import 'all_posts_screen.dart';
import 'editprofile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  bool myProfile;
  String? friendId;
  MyProfileScreen({required this.myProfile, this.friendId});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();
  @override
  void initState() {
    _friendsController.getSearchUserProfileData(
        widget.myProfile, !widget.myProfile ? '' : widget.friendId, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
          showIcon: false,
          title: widget.myProfile ? 'Profile' : 'My Profile',
          actions: [
            widget.myProfile
                ? Container()
                : InkWell(
                    onTap: () {
                      Get.to(FormScreen(
                          isEdit: true,
                          email: 'email',
                          password: 'password',
                          name: 'name'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SvgPicture.asset('Assets/icons/edit-2.svg'),
                    ),
                  ),
            widget.myProfile
                ? Container()
                : InkWell(
                    onTap: () {
                      Get.to(ProfileScreen(
                        isUser: true,
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SvgPicture.asset('Assets/icons/setting-2.svg'),
                    ),
                  )
          ],
          leading: InkWell(onTap: () {}, child: Icon(Icons.arrow_back)),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _friendsController.getSearchUserProfileData(widget.myProfile,
                !widget.myProfile ? '' : widget.friendId, context);
          },
          child: Stack(
            children: [
              Obx(
                () => _friendsController.profileScreenLoader.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : _friendsController.userProfileData.value == null
                        ? Center(
                            child: Text(
                              'Error Fetching User Profile',
                              style: CustomTextStyles.lightTextStyle(),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 45.w,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                width: 100.w,
                                                height: 23.58.w,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: ThemeUtil
                                                                .isDarkMode(
                                                                    context)
                                                            ? Colors.transparent
                                                            : Color(
                                                                0xffF3F4F6)),
                                                    color: ThemeUtil.isDarkMode(
                                                            context)
                                                        ? Color(0xff121212)
                                                        : Color(0xffFAFAFA),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          _friendsController
                                                              .userProfileData!
                                                              .value!
                                                              .posts!
                                                              .length
                                                              .toString(),
                                                          style: CustomTextStyles.darkHeadingTextStyle(
                                                              color: ThemeUtil
                                                                      .isDarkMode(
                                                                          context)
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : Color(
                                                                      0xff000000),
                                                              size: 15.41),
                                                        ),
                                                        Text(
                                                          'Posts',
                                                          style: CustomTextStyles.lightTextStyle(
                                                              color: ThemeUtil
                                                                      .isDarkMode(
                                                                          context)
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : Color(
                                                                      0xff000000),
                                                              size: 13.21),
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          _friendsController
                                                              .getAllUserNames()
                                                              .length
                                                              .toString(),
                                                          style: CustomTextStyles.darkHeadingTextStyle(
                                                              color: ThemeUtil
                                                                      .isDarkMode(
                                                                          context)
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : Color(
                                                                      0xff000000),
                                                              size: 15.41),
                                                        ),
                                                        Text(
                                                          'Friends',
                                                          style: CustomTextStyles.lightTextStyle(
                                                              color: ThemeUtil
                                                                      .isDarkMode(
                                                                          context)
                                                                  ? AppColors
                                                                      .whiteColor
                                                                  : Color(
                                                                      0xff000000),
                                                              size: 13.21),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                    radius: 65,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      _friendsController
                                                              .userProfileData
                                                              .value!
                                                              .image!
                                                              .contains('http')
                                                          ? _friendsController
                                                              .userProfileData
                                                              .value!
                                                              .image!
                                                          : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                                    )),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Text(
                                                  _friendsController
                                                      .userProfileData
                                                      .value!
                                                      .name
                                                      .toString(),
                                                  style: CustomTextStyles
                                                      .darkHeadingTextStyle(
                                                          color: ThemeUtil
                                                                  .isDarkMode(
                                                                      context)
                                                              ? Color(
                                                                  0xffC8D3E0)
                                                              : null,
                                                          size: 14),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    widget.myProfile == true
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: RoundedButtonSmall(
                                                      isSmall: true,
                                                      text: "Message",
                                                      onPressed: () {},
                                                      backgroundColor: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? Color(0XFF1F2228)
                                                          : Color(0xffE5E7EB),
                                                      textColor: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? Color(0XFFC5D3E3)
                                                          : Color(0xff1C2A3A)),
                                                ),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Expanded(
                                                  child: RoundedButtonSmall(
                                                      isSmall: true,
                                                      text: "Add Friend",
                                                      onPressed: () {
                                                        _friendsController
                                                            .AddFriend(
                                                                widget.friendId,
                                                                context);
                                                      },
                                                      backgroundColor: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? Color(0XFFC5D3E3)
                                                          : Color(0xff1C2A3A),
                                                      textColor: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? AppColors.blackColor
                                                          : Color(0xffFFFFFF)),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    // widget.myProfile == true
                                    //     ? SizedBox(height: 2.h)
                                    //     : Container(),
                                    // Heading(
                                    //   title: 'About me',
                                    // ),
                                    // SizedBox(height: 1.h),
                                    // Text(
                                    //   "I’m Alexa David, diagnosed with Cancer last year. Starting getting chemotherapeutic treatment and now i’m getting better day by day.",
                                    //   textAlign: TextAlign.justify,
                                    //   style: CustomTextStyles.lightTextStyle(
                                    //       color: ThemeUtil.isDarkMode(context)
                                    //           ? Color(0xffAAAAAA)
                                    //           : null),
                                    // ),

                                    SizedBox(height: 2.h),
                                    Heading(
                                      title: widget.myProfile
                                          ? '${_friendsController.userProfileData.value!.name.toString()} Friends'
                                          : 'My Friends',
                                    ),
                                    SizedBox(height: 1.h),
                                    UserSlider(
                                        userNames: _friendsController
                                            .getAllUserNames(),
                                        userAssets: _friendsController
                                            .getAllUserAssets()),
                                    Row(
                                      children: [
                                        Text(
                                          widget.myProfile
                                              ? 'Photos'
                                              : 'My Photos',
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(
                                                  color: ThemeUtil.isDarkMode(
                                                          context)
                                                      ? Color(0xffC5D3E3)
                                                      : null),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Get.to(AllPhotoScreen());
                                          },
                                          child: Text(
                                            'See All',
                                            style: CustomTextStyles
                                                .lightSmallTextStyle(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    MyPhotosWidget(
                                      imgList: _friendsController
                                          .getAllProfileImagesUser(),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.myProfile
                                              ? 'Posts'
                                              : 'My Posts',
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(
                                                  color: ThemeUtil.isDarkMode(
                                                          context)
                                                      ? Color(0xffC5D3E3)
                                                      : null),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Get.to(AllPostScreen());
                                          },
                                          child: Text(
                                            'See All',
                                            style: CustomTextStyles
                                                .lightSmallTextStyle(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Obx(() => ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _friendsController
                                            .userProfileData
                                            .value!
                                            .posts!
                                            .length,
                                        itemBuilder: ((context, index) {
                                          final data = _friendsController
                                              .userProfileData
                                              .value!
                                              .posts![index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: MyCustomWidget(
                                              userImage: data.image.toString(),
                                              cm: [],
                                              postIndex: index,
                                              postId: data.postId.toString(),
                                              imgPath: data.image.toString(),
                                              isLiked: true,
                                              isReply: false,
                                              showImg: (data.image == null ||
                                                      data.image!.isEmpty)
                                                  ? false
                                                  : true,
                                              postName: _friendsController
                                                  .userProfileData.value!.name
                                                  .toString(),
                                              text: data.description.toString(),
                                              postTime: '',
                                              id: data.createdBy.toString(),
                                            ),
                                          );
                                        }))),
                                  ],
                                ),
                              ),
                            ),
                          ),
              ),
              Obx(() => _friendsController.updateRequestLoader.value
                  ? Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )))
                  : Container())
            ],
          ),
        ));
  }
}

class MyPhotosWidget extends StatelessWidget {
  List<String> imgList;
  MyPhotosWidget({
    required this.imgList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imgList.first.isEmpty
              ? Container()
              : Container(
                  width: 49.52.w,
                  height: 47.9.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      imgList[0],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          Column(
            children: [
              imgList[1].isEmpty
                  ? Container()
                  : Container(
                      width: 35.5.w,
                      height: 22.8.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          imgList[1],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              SizedBox(
                height: 1.h,
              ),
              imgList[2].isEmpty
                  ? Container()
                  : Container(
                      width: 35.5.w,
                      height: 22.8.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          imgList[2],
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }
}

class ReactionCount extends StatelessWidget {
  final String comment;
  final String share;

  const ReactionCount({
    super.key,
    required this.comment,
    required this.share,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${comment} Comments . ${share} Shares',
      style: CustomTextStyles.lightTextStyle(size: 8.25),
    );
  }
}

class LikeCount extends StatelessWidget {
  final String name;
  final String like;

  const LikeCount({
    super.key,
    required this.name,
    required this.like,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${name} & ${like} others',
          style: CustomTextStyles.lightTextStyle(size: 8.25),
        ),
        SizedBox(
          width: 1.w,
        ),
        SvgPicture.asset('Assets/icons/likereact.svg')
      ],
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyF78CgXqp5uX0g-SvGy4uLB2Qlg8Up3fhYYVlx9Vag&s'),
        ),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sheroze',
              style: CustomTextStyles.w600TextStyle(
                  size: 13.21,
                  color: ThemeUtil.isDarkMode(context)
                      ? Color(0xffFFFFFF)
                      : Color(0xff19295C)),
            ),
            Row(
              children: [
                SvgPicture.asset('Assets/icons/world.svg'),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  '2 Hours ago',
                  style: CustomTextStyles.lightTextStyle(size: 8.25),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class Heading extends StatelessWidget {
  final String title;

  const Heading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: CustomTextStyles.w600TextStyle(
          size: 20,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xffC8D3E0)
              : Color(0xff1F2A37)),
    );
  }
}

class SubHeading extends StatelessWidget {
  final String title;

  const SubHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: CustomTextStyles.lightSmallTextStyle(
          size: 14,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xffC8D3E0)
              : Color(0xff1F2A37)),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff4B5563), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          '1 New',
          style: CustomTextStyles.w600TextStyle(
              color: Color(0xffFFFFFF), size: 14),
        ),
      ),
    );
  }
}

class UserSlider extends StatelessWidget {
  final List<String> userNames;
  final List<String> userAssets;

  const UserSlider({
    Key? key,
    required this.userNames,
    required this.userAssets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14.h,
      child: userNames.isEmpty
          ? Center(
              child: Text(
                "No friends found",
                style: CustomTextStyles.lightTextStyle(),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(userAssets[index]
                                .contains('http')
                            ? userAssets[index]
                            : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png'),
                      ),
                      SizedBox(height: 1.h),
                      Text(userNames[index],
                          style: CustomTextStyles.lightSmallTextStyle(
                              size: 9.4, color: Color(0xff99A1BE))),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;
  final String img;
  bool isActive;
  bool isLikeButton;

  CircleButton(
      {Key? key,
      required this.color,
      this.onPressed,
      required this.img,
      this.isActive = false,
      this.isLikeButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              img,
              color: isLikeButton
                  ? (isActive || !isLikeButton)
                      ? Color(0xff1C2A3A)
                      : Color(0xFFC5D3E3)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
