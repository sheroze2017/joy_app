import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../../../Widgets/custom_appbar.dart';
import '../../../../view/home/my_profile.dart';

class AddFriend extends StatelessWidget {
  AddFriend({super.key});
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Friend Requests',
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
                    Obx(
                      () => countRequest(
                        title: 'Requests',
                        requestCount: '(' +
                            _friendsController.friendRequest.length.toString() +
                            ')',
                        showCount: true,
                        isRequest: true,
                      ),
                    ),
                    Obx(() => _friendsController.friendRequest.length == 0
                        ? Column(
                            children: [
                              Center(
                                child: Text(
                                  'No Friend Request',
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                              ),
                              Obx(() => RoundedButtonSmall(
                                  showLoader: _friendsController
                                      .fetchFriendRequest.value,
                                  text: 'refresh',
                                  onPressed: () {
                                    _friendsController.getAllFriendRequest();
                                  },
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white))
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _friendsController.friendRequest.length,
                            itemBuilder: ((context, index) {
                              final data =
                                  _friendsController.friendRequest[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
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
                                    profileImage: data.friendDetails!.image!
                                            .contains('http')
                                        ? data.friendDetails!.image.toString()
                                        : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                    userName:
                                        data.friendDetails!.name.toString(),
                                    mutualFriends: data
                                        .friendDetails!.mutualFriends!
                                        .map((friend) =>
                                            friend.mutualFriendImage!)
                                        .toList(),
                                    mutualFriendsCount: data
                                        .friendDetails!.mutualFriends!.length,
                                    friendsId: data.friendsId.toString(),
                                  ),
                                ),
                              );
                            }))),
                    countRequest(
                      title: 'People you may know',
                      requestCount: '',
                      showCount: false,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                        height: 60.w,
                        child: Obx(
                          () => _friendsController.userList.length == 0
                              ? Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'No user found',
                                        style:
                                            CustomTextStyles.lightTextStyle(),
                                      ),
                                    ),
                                    Obx(() => RoundedButtonSmall(
                                        showLoader: _friendsController
                                            .fetchAllUser.value,
                                        text: 'refresh',
                                        onPressed: () {
                                          _friendsController.getAllUserList();
                                        },
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white))
                                  ],
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      _friendsController.userList.length > 3
                                          ? 3
                                          : _friendsController.userList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        _friendsController.userList[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                            MyProfileScreen(
                                              myProfile: true,
                                              friendId: data.userId.toString(),
                                            ),
                                            transition: Transition.native);
                                      },
                                      child: AddFriendWidget(
                                          profileImage: data.image!
                                                  .contains('http')
                                              ? data.image.toString()
                                              : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                          userName: data.name.toString(),
                                          mutualFriends: [],
                                          mutualFriendsCount: 0,
                                          onRemove: () {
                                            _friendsController
                                                .removeUser(data.userId);
                                          },
                                          onAddFriend: () {
                                            _friendsController.AddFriend(
                                                data.userId, context);
                                          }),
                                    );
                                  },
                                ),
                        ))
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

class countRequest extends StatelessWidget {
  final String requestCount;
  final bool showCount;
  final String title;
  bool isRequest;

  countRequest(
      {super.key,
      required this.requestCount,
      required this.showCount,
      required this.title,
      this.isRequest = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: CustomTextStyles.lightSmallTextStyle(
            size: 18,
            color: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : Color(0xff19295C),
          ),
        ),
        Text(
          showCount ? ' ${requestCount}' : '',
          style: CustomTextStyles.w600TextStyle(color: Colors.red, size: 14),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Get.to(
                AddNewFriend(
                  isRequests: isRequest,
                ),
                transition: Transition.native);
          },
          child: Text(
            'See all',
            style: CustomTextStyles.w600TextStyle(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xffC5D3E3)
                    : Color(0xff1C2A3A),
                size: 14),
          ),
        )
      ],
    );
  }
}

class FriendRequestWidget extends StatelessWidget {
  final String profileImage;
  final String userName;
  final List<String> mutualFriends;
  final int mutualFriendsCount;
  final String friendsId;

  FriendRequestWidget(
      {Key? key,
      required this.profileImage,
      required this.userName,
      required this.mutualFriends,
      required this.mutualFriendsCount,
      required this.friendsId})
      : super(key: key);
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff121212)
              : Color(0xffFAFAFA),
          borderRadius: BorderRadius.circular(22.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rounded Image
            ClipOval(
              child: Image.network(
                profileImage,
                width: 6.6.h,
                height: 6.6.h,
                fit: BoxFit.cover,
              ),
            ),
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
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          mutualFriends.length > 3 ? 3 : mutualFriends.length,
                          (index) => ClipOval(
                            child: Image.network(
                              mutualFriends[index].contains('http')
                                  ? mutualFriends[index]
                                  : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 1.w),
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
            Column(
              children: [
                RoundedButtonSmall(
                    text: "Accept",
                    onPressed: () {
                      _friendsController.updateFriendRequest(
                          friendsId, 'Accepted', context);
                    },
                    backgroundColor: ThemeUtil.isDarkMode(context)
                        ? Color(0xffC5D3E3)
                        : Color(0xff1C2A3A),
                    textColor: ThemeUtil.isDarkMode(context)
                        ? AppColors.blackColor
                        : Color(0xffFFFFFF)),
                SizedBox(
                  width: 4.w,
                ),
                RoundedButtonSmall(
                    text: "Reject",
                    onPressed: () {
                      _friendsController.updateFriendRequest(
                          friendsId, 'Rejected', context);
                    },
                    backgroundColor: ThemeUtil.isDarkMode(context)
                        ? Color(0xff191919)
                        : Color(0xffF1F4F5),
                    textColor: ThemeUtil.isDarkMode(context)
                        ? Color(0xffC5D3E3)
                        : Color(0xff1C2A3A))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddFriendWidget extends StatelessWidget {
  final String profileImage;
  final String userName;
  final List<String> mutualFriends;
  final int mutualFriendsCount;
  final Function() onRemove;
  final Function() onAddFriend;

  const AddFriendWidget({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.mutualFriends,
    required this.mutualFriendsCount,
    required this.onRemove,
    required this.onAddFriend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 54.61.w,
        width: 46.15.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff121212)
                : Color(0xffFAFAFA)),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: onRemove,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.close,
                              size: 16,
                            )),
                      )),
                  ClipOval(
                    child: Image.network(
                      profileImage,
                      width: 15.38.w,
                      height: 15.38.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Text(
                      userName,
                      style: CustomTextStyles.darkHeadingTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : Color(0xff19295C),
                          size: 16),
                      maxLines: 1,
                    ),
                  ),
                  // SizedBox(height: 0.5.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Row(
                  //       children: List.generate(
                  //         mutualFriends.length,
                  //         (index) => ClipOval(
                  //           child: Image.network(
                  //             mutualFriends[index],
                  //             width: 1.9.h,
                  //             height: 1.9.h,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 2.w,
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         '$mutualFriendsCount mutual friends',
                  //         style: CustomTextStyles.lightTextStyle(
                  //             size: 10, color: Color(0xff99A1BE)),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButtonSmall(
                            text: 'Add Friend',
                            onPressed: onAddFriend,
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC5D3E3)
                                : Color(0xff1C2A3A),
                            textColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.blackColor
                                : AppColors.whiteColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                ])),
      ),
    );
  }
}
