import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../styles/custom_textstyle.dart';
import 'add_friend.dart';

class AddNewFriend extends StatefulWidget {
  bool isRequests;
  AddNewFriend({super.key, this.isRequests = false});

  @override
  State<AddNewFriend> createState() => _AddNewFriendState();
}

class _AddNewFriendState extends State<AddNewFriend> {
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();

  @override
  void initState() {
    // _friendsController.getAllUserList();
    _friendsController.filteredList.assignAll(_friendsController.userList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: !widget.isRequests ? 'Add New Friends' : 'Friend Requests',
        leading: Text(''),
        showIcon: false,
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    !widget.isRequests
                        ? RoundedSearchTextField(
                            onChanged: _friendsController.searchByName,
                            hintText: 'Search users',
                            controller: TextEditingController())
                        : Container(),
                    !widget.isRequests
                        ? SizedBox(
                            height: 1.h,
                          )
                        : Container(),
                    widget.isRequests
                        ? Obx(() => _friendsController
                                    .friendRequest.value.length ==
                                0
                            ? Center(
                                child: Text(
                                  'No Friend Request',
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    _friendsController.friendRequest.length,
                                itemBuilder: ((context, index) {
                                  final data =
                                      _friendsController.friendRequest[index];

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                            MyProfileScreen(
                                              myProfile: true,
                                              friendId: data.userId.toString(),
                                            ),
                                            transition: Transition.native);
                                      },
                                      child: FriendRequestWidget(
                                        profileImage: data.friendDetails!.image ?? '',
                                        userName:
                                            data.friendDetails!.name.toString(),
                                        mutualFriends: data
                                            .friendDetails!.mutualFriends!
                                            .map((friend) =>
                                                friend.mutualFriendImage ?? '')
                                            .toList(),
                                        mutualFriendsCount: data.friendDetails!
                                            .mutualFriends!.length,
                                        friendsId: data.friendsId.toString(),
                                      ),
                                    ),
                                  );
                                })))
                        : Obx(
                            () => _friendsController.filteredList.value.isEmpty
                                ? Center(
                                    child: Text(
                                      'No users found',
                                      style: CustomTextStyles.lightTextStyle(),
                                    ),
                                  )
                                : Obx(
                                    () => ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _friendsController
                                          .filteredList.value.length,
                                      itemBuilder: ((context, index) {
                                        final data = _friendsController
                                            .filteredList.value[index];

                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(
                                                    transition:
                                                        Transition.native,
                                                    MyProfileScreen(
                                                      myProfile: true,
                                                      friendId: data.userId
                                                          .toString(),
                                                    ));
                                              },
                                              child: NewFriendRequestWidget(
                                                  onAddFriend: () {
                                                    _friendsController
                                                        .AddFriend(data.userId,
                                                            context);
                                                  },
                                                  profileImage: data.image ?? '',
                                                  userName:
                                                      data.name.toString(),
                                                  mutualFriends: [],
                                                  mutualFriendsCount: 0),
                                            ));
                                      }),
                                    ),
                                  ),
                          ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
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
        ),
      ),
    );
  }
}

class NewFriendRequestWidget extends StatelessWidget {
  final String profileImage;
  final String userName;
  final List<String> mutualFriends;
  final int mutualFriendsCount;
  final Function() onAddFriend;

  const NewFriendRequestWidget({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.mutualFriends,
    required this.mutualFriendsCount,
    required this.onAddFriend,
  }) : super(key: key);

  Widget _buildAvatarWidget(String? url, double radius, BuildContext context) {
    final isValidUrl = url != null &&
        url.trim().isNotEmpty &&
        url.trim().toLowerCase() != 'null' &&
        url.contains('http') &&
        !url.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

    if (isValidUrl) {
      return ClipOval(
        child: Image.network(
          url.trim(),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: radius,
                color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
              ),
            );
          },
        ),
      );
    }
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context) ? Color(0xff2A2A2A) : Color(0xffE5E5E5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: radius,
        color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff121212)
              : Color(0xffFAFAFA),
          borderRadius: BorderRadius.circular(22.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rounded Image
            _buildAvatarWidget(profileImage, 3.3.h, context),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    userName,
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : Color(0xff19295C),
                        size: 15),
                  ),

                  SizedBox(height: 0.5.h),
                  // Mutual Friends
                  if (mutualFriendsCount > 0)
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            mutualFriends.length > 3 ? 3 : mutualFriends.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(left: index > 0 ? -8.0 : 0),
                              child: ClipOval(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ThemeUtil.isDarkMode(context)
                                          ? Color(0xff121212)
                                          : Color(0xffFAFAFA),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _buildAvatarWidget(
                                      mutualFriends[index], 9.5, context),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: Text(
                            '$mutualFriendsCount mutual friends',
                            style: CustomTextStyles.lightTextStyle(
                                size: 9.4, color: Color(0xff99A1BE)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            RoundedButtonSmall(
                text: "Add Friend",
                onPressed: onAddFriend,
                backgroundColor: ThemeUtil.isDarkMode(context)
                    ? Color(0xffC5D3E3)
                    : Color(0xff1C2A3A),
                textColor: ThemeUtil.isDarkMode(context)
                    ? AppColors.blackColor
                    : Color(0xffFFFFFF)),
          ],
        ),
      ),
    );
  }
}

class RoundedCommentTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSendPressed;
  final bool isEnable;

  RoundedCommentTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.onSendPressed,
    this.isEnable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.25.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff171717)
              : Color(0xffF3F4F6)),
      child: Row(
        children: [
          SizedBox(width: 12.0),
          Expanded(
            child: TextField(
              enabled: isEnable,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  fillColor: Colors.transparent,
                  hintText: hintText,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: CustomTextStyles.lightSmallTextStyle(
                      color: Color(0xff9CA3AF), size: 14)),
            ),
          ),
          IconButton(
            onPressed: onSendPressed,
            icon: Icon(Icons.send), // Send icon
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 12.0), // Right padding
        ],
      ),
    );
  }
}

class RoundedSearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  bool isEnable;

  RoundedSearchTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.isEnable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.25.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff171717)
              : Color(0xffF3F4F6)
          // color: Colors.grey[200],
          ),
      child: Row(
        children: [
          SizedBox(width: 4.w),

          SvgPicture.asset('Assets/icons/search-icon.svg'),
          //  Icon(leadingIcon),
          SizedBox(width: 1.w),
          Expanded(
            child: TextField(
              enabled: isEnable,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  fillColor: Colors.transparent,
                  hintText: hintText,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: CustomTextStyles.lightSmallTextStyle(
                      color: Color(0xff9CA3AF), size: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedSearchTextFieldLarge extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  bool isEnable;

  RoundedSearchTextFieldLarge(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.isEnable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9.23.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff171717)
              : Color(0xffF9FAFB)
          // color: Colors.grey[200],
          ),
      child: Row(
        children: [
          SizedBox(width: 4.w),

          SvgPicture.asset('Assets/icons/search-icon.svg'),
          //  Icon(leadingIcon),
          Expanded(
            child: TextField(
              enabled: isEnable,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  fillColor: Colors.transparent,
                  hintText: hintText,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: CustomTextStyles.lightSmallTextStyle(
                      color: Color(0xff9CA3AF), size: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
