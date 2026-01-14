import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/auth/view/profileform_screen.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_bloc.dart';
import 'package:joy_app/modules/social_media/chat/view/direct_chat.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_post_id.dart';
import 'package:joy_app/modules/social_media/media_post/model/media_post.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/home/components/blog_card.dart';
import 'package:joy_app/modules/doctor/view/profile_screen.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:sizer/sizer.dart';

import '../../../modules/home/all_posts_screen.dart';
import '../../../widgets/appbar/custom_appbar.dart';
import '../../../common/navbar/controller/navbar_controller.dart';
import '../../../widgets/drawer/user_drawer.dart';

class MyProfileScreen extends StatefulWidget {
  bool myProfile;
  String? friendId;
  bool isFriend;
  MyProfileScreen(
      {required this.myProfile, this.friendId, this.isFriend = false});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();
  ProfileController _profileController = Get.put(ProfileController());

  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    // Don't load data in initState - wait until screen is actually visible
    // This prevents API calls when screen is in IndexedStack but not visible
  }

  void _checkAndLoadData() {
    if (!_hasLoadedData && mounted) {
      if (widget.myProfile) {
        // Friend profile - load immediately
        _hasLoadedData = true;
        _friendsController.getSearchUserProfileData(
            widget.myProfile, widget.friendId ?? '', context);
      } else {
        // Own profile - check if we're on the profile tab
        try {
          final navbarController = Get.find<NavBarController>();
          // Profile screen is at index 4 for users (0: Blog, 1: AddFriend, 2: Home, 3: Notifications, 4: Profile)
          if (navbarController.tabIndex == 4) {
            _hasLoadedData = true;
            _friendsController.getSearchUserProfileData(
                widget.myProfile, '', context);
          }
        } catch (e) {
          // If NavBarController not found, load anyway (might be navigating directly)
          _hasLoadedData = true;
          _friendsController.getSearchUserProfileData(
              widget.myProfile, '', context);
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndLoadData();
  }

  @override
  void dispose() {
    _hasLoadedData = false;
    super.dispose();
  }

  final _chatController = Get.find<ChatController>();

  Widget _buildProfileAvatar(String? imageUrl, double radius) {
    final isValidUrl = imageUrl != null &&
        imageUrl.trim().isNotEmpty &&
        imageUrl.trim().toLowerCase() != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'); // Exclude default broken image URL
    
    if (isValidUrl) {
      return ClipOval(
        child: Image.network(
          imageUrl.trim(),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Silently handle error without logging
            return CircleAvatar(
              radius: radius,
              backgroundColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xff2A2A2A)
                  : Color(0xffE5E5E5),
              child: Icon(
                Icons.person,
                size: radius,
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff5A5A5A)
                    : Color(0xffA5A5A5),
              ),
            );
          },
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: ThemeUtil.isDarkMode(context)
          ? Color(0xff2A2A2A)
          : Color(0xffE5E5E5),
      child: Icon(
        Icons.person,
        size: radius,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff5A5A5A)
            : Color(0xffA5A5A5),
      ),
    );
  }

  static Widget _buildFriendAvatarStatic(BuildContext context, String imageUrl, double radius) {
    final isValidUrl = imageUrl.trim().isNotEmpty &&
        imageUrl.trim().toLowerCase() != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'); // Exclude default broken image URL
    
    if (isValidUrl) {
      return ClipOval(
        child: Image.network(
          imageUrl.trim(),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff2A2A2A)
                    : Color(0xffE5E5E5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: radius,
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff5A5A5A)
                    : Color(0xffA5A5A5),
              ),
            );
          },
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: ThemeUtil.isDarkMode(context)
          ? Color(0xff2A2A2A)
          : Color(0xffE5E5E5),
      child: Icon(
        Icons.person,
        size: radius,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff5A5A5A)
            : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if we should load data (only once)
    if (!_hasLoadedData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndLoadData();
      });
    }
    
    return Scaffold(
        drawer: widget.myProfile ? null : UserDrawer(),
        appBar: HomeAppBar(
          isImage: widget.myProfile ? false : true,
          showIcon: false,
          title: widget.myProfile ? 'Profile' : 'My Profile',
          leading: widget.myProfile ? Icon(Icons.arrow_back) : Text(''),
          actions: [
            widget.myProfile
                ? Container()
                : InkWell(
                    onTap: () {
                      Get.to(
                          FormScreen(
                              isEdit: true,
                              email: 'email',
                              password: 'password',
                              name: 'name'),
                          transition: Transition.native);
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
                      Get.to(
                          ProfileScreen(
                            isUser: true,
                          ),
                          transition: Transition.native);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SvgPicture.asset('Assets/icons/setting-2.svg'),
                    ),
                  )
          ],
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
                                              bottom: 2.h,
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
                                                          (_friendsController.userProfileData.value?.posts?.length ?? _friendsController.userPostById.length).toString(),
                                                          style: CustomTextStyles.w600TextStyle(
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
                                                          style: CustomTextStyles.w600TextStyle(
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
                                                _buildProfileAvatar(
                                                    _friendsController
                                                        .userProfileData
                                                        .value!
                                                        .image,
                                                    65),
                                                SizedBox(
                                                  height: 1.5.h,
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
                                                      onPressed: () {
                                                        Get.to(
                                                            DirectMessageScreen(
                                                          userName:
                                                              _friendsController
                                                                  .userProfileData
                                                                  .value!
                                                                  .name
                                                                  .toString(),
                                                          friendId:
                                                              _friendsController
                                                                  .userProfileData
                                                                  .value!
                                                                  .userId
                                                                  .toString(),

                                                          userId:
                                                              _profileController
                                                                  .userId.value,
                                                          userAsset:
                                                              _profileController
                                                                  .image
                                                                  .toString(),
                                                          // Adjust types when chatting with non-user entities
                                                          senderType: 'user',
                                                          receiverType: 'user',
                                                          // conversationId:
                                                          //     result.data!.sId.toString(),
                                                        ));

                                                        // _chatController.createConvo(
                                                        //     _friendsController
                                                        //             .userProfileData
                                                        //             .value!
                                                        //             .userId ??
                                                        //         0,
                                                        //     _friendsController
                                                        //         .userProfileData
                                                        //         .value!
                                                        //         .name
                                                        //         .toString());
                                                      },
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
                                                      text: widget.isFriend
                                                          ? 'Friend'
                                                          : "Add Friend",
                                                      onPressed: () {
                                                        widget.isFriend
                                                            ? print('')
                                                            : _friendsController
                                                                .AddFriend(
                                                                    widget
                                                                        .friendId,
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
                                    // About me section - show above My Friends
                                    Obx(() => _friendsController.userProfileData.value?.aboutMe != null &&
                                            _friendsController.userProfileData.value!.aboutMe!.isNotEmpty
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SubHeading(
                                                title: 'About me',
                                              ),
                                              SizedBox(height: 1.h),
                                              Text(
                                                _friendsController.userProfileData.value!.aboutMe!,
                                                textAlign: TextAlign.justify,
                                                style: CustomTextStyles.lightTextStyle(
                                                    color: ThemeUtil.isDarkMode(context)
                                                        ? Color(0xffAAAAAA)
                                                        : null),
                                              ),
                                              SizedBox(height: 2.h),
                                            ],
                                          )
                                        : SizedBox.shrink()),
                                    SubHeading(
                                      title: widget.myProfile
                                          ? '${_friendsController.userProfileData.value!.name.toString()} Friends'
                                          : 'My Friends',
                                    ),
                                    SizedBox(height: 1.h),
                                    UserSlider(
                                      userNames:
                                          _friendsController.getAllUserNames(),
                                      userAssets:
                                          _friendsController.getAllUserAssets(),
                                      userIds:
                                          _friendsController.getAllUserId(),
                                    ),
                                    SizedBox(height: 2.h),
                                    SubHeading(
                                      title: widget.myProfile
                                          ? 'Posts'
                                          : 'My Posts',
                                    ),
                                    SizedBox(height: 1.h),
                                    Obx(() => ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _friendsController
                                            .userPostById.value.length,
                                        itemBuilder: ((context, index) {
                                          final data = _friendsController
                                              .userPostById.value[index];
                                          final creatorName = data
                                                  .createdByUser?.name ??
                                              _friendsController
                                                  .userProfileData.value!.name
                                                  .toString();
                                          final creatorImage = data
                                                  .createdByUser?.image ??
                                              data.userImage ??
                                              _friendsController
                                                  .userProfileData
                                                  .value!
                                                  .image
                                                  .toString();
                                          final creatorId = data
                                                  .createdByUser?.userId ??
                                              data.createdBy?.toString() ??
                                              data.userId ??
                                              _friendsController
                                                  .userProfileData
                                                  .value!
                                                  .userId
                                                  .toString();
                                          return Padding(
                                            padding: EdgeInsets.only(top: 12.0),
                                            child: MyCustomWidget(
                                              userImage: creatorImage,
                                              cm: data.comments ?? [],
                                              postIndex: index,
                                              postId: data.postId.toString(),
                                              imgPath: data.image.toString(),
                                              isLiked: false, // TODO: Add isMyLike to Post model if needed
                                              isReply: false,
                                              showImg: (data.image == null ||
                                                      data.image!.isEmpty)
                                                  ? false
                                                  : true,
                                              postName: creatorName,
                                              text: data.description.toString(),
                                              postTime:
                                                  data.createdAt.toString(),
                                              id: creatorId,
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
  double size;

  Heading({super.key, required this.title, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: CustomTextStyles.w600TextStyle(
          size: size,
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
      style: CustomTextStyles.w600TextStyle(
          size: 20,
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
  final List<String> userIds;

  const UserSlider({
    Key? key,
    required this.userNames,
    required this.userAssets,
    required this.userIds,
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
                      _MyProfileScreenState._buildFriendAvatarStatic(context, userAssets[index], 28),
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
