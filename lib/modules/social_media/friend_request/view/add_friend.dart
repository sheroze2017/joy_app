import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/drawer/user_drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/modules/social_media/chat/view/direct_chat.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_service.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';

class AddFriend extends StatelessWidget {
  AddFriend({super.key});
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();

  void _showAllFriendRequestsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeUtil.isDarkMode(context)
          ? Color(0xff121212)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff2A2A2A)
                          : Color(0xffE5E5E5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      SubHeading(title: 'All Friend Requests'),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: Obx(
                      () => _friendsController.friendRequest.length == 0
                          ? Center(
                              child: Text(
                                'No Friend Request',
                                style: CustomTextStyles.lightTextStyle(),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: _friendsController.friendRequest.length,
                              itemBuilder: ((context, index) {
                                final data =
                                    _friendsController.friendRequest[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
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
                                          .friendDetails!.mutualFriends != null
                                          ? data.friendDetails!.mutualFriends!
                                              .map((friend) =>
                                                  friend.mutualFriendImage ?? '')
                                              .toList()
                                          : [],
                                      mutualFriendsCount: data
                                          .friendDetails!.mutualFriends?.length ?? 0,
                                      friendsId: data.friendsId.toString(),
                                    ),
                                  ),
                                );
                              })),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAllFriendsSheet(BuildContext context) {
    final searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeUtil.isDarkMode(context)
          ? Color(0xff121212)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff2A2A2A)
                          : Color(0xffE5E5E5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      SubHeading(title: 'Friends'),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  RoundedSearchTextField(
                    hintText: 'Search friends...',
                    controller: searchController,
                    onChanged: (query) {
                      _friendsController.searchFriends(query);
                    },
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: Obx(
                      () => _friendsController.filteredFriends.length == 0
                          ? Center(
                              child: Text(
                                'No friends found',
                                style: CustomTextStyles.lightTextStyle(),
                              ),
                            )
                          : GridView.builder(
                              controller: scrollController,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: _friendsController.filteredFriends.length,
                              itemBuilder: (context, index) {
                                final data = _friendsController.filteredFriends[index];
                                return InkWell(
                                  onTap: () {
                                    // Only navigate if it's a valid user (not an institution)
                                    final userRole = data.userRole?.toUpperCase() ?? '';
                                    if (userRole == 'USER' || userRole.isEmpty) {
                                      Navigator.pop(context);
                                      Get.to(
                                          MyProfileScreen(
                                            myProfile: true,
                                            friendId: data.id.toString(),
                                          ),
                                          transition: Transition.native);
                                    } else {
                                      Navigator.pop(context);
                                      Get.snackbar(
                                        'Error',
                                        'Cannot view profile for ${data.userRole ?? "institution"}',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                  child: FriendWidget(
                                    profileImage: data.image ?? '',
                                    userName: data.name ?? '',
                                    friendId: data.id.toString(),
                                    userRole: data.userRole ?? '',
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAllSuggestionsSheet(BuildContext context) {
    final searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeUtil.isDarkMode(context)
          ? Color(0xff121212)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff2A2A2A)
                          : Color(0xffE5E5E5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      SubHeading(title: 'Suggestions'),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  RoundedSearchTextField(
                    hintText: 'Search suggestions...',
                    controller: searchController,
                    onChanged: (query) {
                      _friendsController.searchSuggestions(query);
                    },
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: Obx(
                      () => _friendsController.filteredSuggestions.length == 0
                          ? Center(
                              child: Text(
                                'No suggestions found',
                                style: CustomTextStyles.lightTextStyle(),
                              ),
                            )
                          : GridView.builder(
                              controller: scrollController,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: _friendsController.filteredSuggestions.length,
                              itemBuilder: (context, index) {
                                final data = _friendsController.filteredSuggestions[index];
                                return InkWell(
                                  onTap: () {
                                    // Only navigate if it's a valid user (not an institution)
                                    final userRole = data.userRole?.toUpperCase() ?? '';
                                    if (userRole == 'USER' || userRole.isEmpty) {
                                      Navigator.pop(context);
                                      Get.to(
                                          MyProfileScreen(
                                            myProfile: true,
                                            friendId: data.id.toString(),
                                          ),
                                          transition: Transition.native);
                                    } else {
                                      Navigator.pop(context);
                                      Get.snackbar(
                                        'Error',
                                        'Cannot view profile for ${data.userRole ?? "institution"}',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                  child: AddFriendWidget(
                                      profileImage: data.image ?? '',
                                      userName: data.name ?? '',
                                      mutualFriends: [],
                                      mutualFriendsCount: 0,
                                      onRemove: () {
                                        _friendsController.suggestions.removeAt(index);
                                      },
                                      onAddFriend: () {
                                        _friendsController.AddFriend(
                                            data.id, context);
                                        // Remove from local list immediately for better UX
                                        _friendsController.suggestions.removeAt(index);
                                      }),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(),
      appBar: HomeAppBar(
        isImage: true,
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
                    // Friends section (horizontal scroll at top)
                    countRequest(
                      title: 'Friends',
                      requestCount: '',
                      showCount: false,
                      isRequest: false,
                      onSeeAllTap: () => _showAllFriendsSheet(context),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      height: 60.w,
                      child: Obx(
                        () => _friendsController.friends.length == 0
                            ? Center(
                                child: Text(
                                  'No friends yet',
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _friendsController.friends.length,
                                padding: EdgeInsets.only(right: 16.0),
                                itemBuilder: (context, index) {
                                  final data = _friendsController.friends[index];
                                  return InkWell(
                                    onTap: () {
                                      // Only navigate if it's a valid user (not an institution)
                                      final userRole = data.userRole?.toUpperCase() ?? '';
                                      if (userRole == 'USER' || userRole.isEmpty) {
                                        Get.to(
                                            MyProfileScreen(
                                              myProfile: true,
                                              friendId: data.id.toString(),
                                            ),
                                            transition: Transition.native);
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'Cannot view profile for ${data.userRole ?? "institution"}',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    child: FriendWidget(
                                      profileImage: data.image ?? '',
                                      userName: data.name ?? '',
                                      friendId: data.id.toString(),
                                      friendsId: data.friendsId?.toString(),
                                      userRole: data.userRole ?? '',
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Requests section
                    Obx(
                      () => countRequest(
                        title: 'Requests',
                        requestCount: '(' +
                            _friendsController.friendRequest.length.toString() +
                            ')',
                        showCount: true,
                        isRequest: true,
                        onSeeAllTap: () => _showAllFriendRequestsSheet(context),
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
                                    _friendsController.getFriendRequestsAndSuggestions();
                                  },
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white))
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _friendsController.friendRequest.length > 2
                                ? 2
                                : _friendsController.friendRequest.length,
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
                                    profileImage: data.friendDetails!.image ?? '',
                                    userName:
                                        data.friendDetails!.name.toString(),
                                    mutualFriends: data
                                        .friendDetails!.mutualFriends != null
                                        ? data.friendDetails!.mutualFriends!
                                            .map((friend) =>
                                                friend.mutualFriendImage ?? '')
                                            .toList()
                                        : [],
                                    mutualFriendsCount: data
                                        .friendDetails!.mutualFriends?.length ?? 0,
                                    friendsId: data.friendsId.toString(),
                                  ),
                                ),
                              );
                            }))),
                    SizedBox(height: 2.h),
                    countRequest(
                      title: 'Suggestions',
                      requestCount: '',
                      showCount: false,
                      isRequest: false,
                      onSeeAllTap: () => _showAllSuggestionsSheet(context),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                        height: 60.w,
                        child: Obx(
                          () => _friendsController.suggestions.length == 0
                              ? Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'No suggestions found',
                                        style:
                                            CustomTextStyles.lightTextStyle(),
                                      ),
                                    ),
                                    Obx(() => RoundedButtonSmall(
                                        showLoader: _friendsController
                                            .fetchFriendRequest.value,
                                        text: 'refresh',
                                        onPressed: () {
                                          _friendsController.getFriendRequestsAndSuggestions();
                                        },
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white))
                                  ],
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _friendsController.suggestions.length,
                                  padding: EdgeInsets.only(right: 16.0),
                                  itemBuilder: (context, index) {
                                    final data =
                                        _friendsController.suggestions[index];
                                    return InkWell(
                                      onTap: () {
                                        // Only navigate if it's a valid user (not an institution)
                                        final userRole = data.userRole?.toUpperCase() ?? '';
                                        if (userRole == 'USER' || userRole.isEmpty) {
                                          Get.to(
                                              MyProfileScreen(
                                                myProfile: true,
                                                friendId: data.id.toString(),
                                              ),
                                              transition: Transition.native);
                                        } else {
                                          Get.snackbar(
                                            'Error',
                                            'Cannot view profile for ${data.userRole ?? "institution"}',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                  child: AddFriendWidget(
                                      profileImage: data.image ?? '',
                                      userName: data.name ?? '',
                                      mutualFriends: [],
                                      mutualFriendsCount: 0,
                                      onRemove: () {
                                        _friendsController.suggestions.removeAt(index);
                                      },
                                      onAddFriend: () {
                                        _friendsController.AddFriend(
                                            data.id, context);
                                        // Remove from local list immediately for better UX
                                        _friendsController.suggestions.removeAt(index);
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
  final VoidCallback? onSeeAllTap;

  countRequest(
      {super.key,
      required this.requestCount,
      required this.showCount,
      required this.title,
      this.isRequest = false,
      this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SubHeading(title: title),
        if (showCount)
          Text(
            ' $requestCount',
            style: CustomTextStyles.w600TextStyle(color: Colors.red, size: 14),
          ),
        Spacer(),
        InkWell(
          onTap: onSeeAllTap ?? () {
            // Fallback if no callback provided
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    mutualFriends[index], 10, context),
                              ),
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
            SizedBox(width: 2.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundedButtonSmall(
                    text: "Accept",
                    onPressed: () {
                      _friendsController.updateFriendRequest(
                          friendsId, 'ACCEPTED', context);
                    },
                    backgroundColor: ThemeUtil.isDarkMode(context)
                        ? Color(0xffC5D3E3)
                        : Color(0xff1C2A3A),
                    textColor: ThemeUtil.isDarkMode(context)
                        ? AppColors.blackColor
                        : Color(0xffFFFFFF)),
                SizedBox(height: 0.8.h),
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
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: onRemove,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff2A2A2A)
                                    : Color(0xffE5E5E5),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xffAAAAAA)
                                    : Color(0xff666666),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      _buildAvatarWidget(profileImage, 7.69.w, context),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color(0xff1C2A3A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (mutualFriendsCount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: List.generate(
                            mutualFriends.length > 2 ? 2 : mutualFriends.length,
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
                                      mutualFriends[index], 8, context),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '$mutualFriendsCount mutual friends',
                          style: CustomTextStyles.lightTextStyle(
                              size: 10, color: Color(0xff99A1BE)),
                        ),
                      ],
                    ),
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
                ])),
      ),
    );
  }
}

// New widget for friends with Chat and Unfollow buttons
class FriendWidget extends StatelessWidget {
  final String profileImage;
  final String userName;
  final String friendId;
  final String? friendsId; // Relationship ID for unfollow
  final String userRole;

  const FriendWidget({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.friendId,
    this.friendsId,
    required this.userRole,
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
    final FriendsSocialController _friendsController = Get.find<FriendsSocialController>();
    final ProfileController _profileController = Get.find<ProfileController>();

    // Determine peer type based on user role
    String getPeerType(String role) {
      final roleUpper = role.toUpperCase();
      if (roleUpper == 'DOCTOR') return 'doctor';
      if (roleUpper == 'PHARMACY') return 'pharmacy';
      if (roleUpper == 'HOSPITAL') return 'hospital';
      if (roleUpper == 'BLOODBANK' || roleUpper == 'BLOOD_BANK') return 'bloodbank';
      return 'user';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 50.w, // Slightly reduced height
        width: 46.15.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff121212)
                : Color(0xffFAFAFA)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // Better padding
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatarWidget(profileImage, 9.w, context), // Smaller avatar
                  SizedBox(height: 0.4.h),
                  Text(
                    userName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : Color(0xff19295C),
                        size: 10), // Smaller font
                  ),
                  SizedBox(height: 0.4.h),
                  // Chat and Unfollow buttons in a column (vertical)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chat button
                      SizedBox(
                        width: double.infinity,
                        child: RoundedButtonSmall(
                          isSmall: true, // Make button smaller
                          text: "Chat",
                          onPressed: () async {
                      try {
                        // Get current user ID
                        final currentUserId = _profileController.userId.value;
                        if (currentUserId.isEmpty) {
                          Get.snackbar('Error', 'User not logged in',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          return;
                        }

                        // Determine peer type
                        final peerType = getPeerType(userRole);

                        // Ensure conversation - use DioClient to get Dio with interceptors (Bearer token)
                        final dio = DioClient.createDio();
                        // Update base URL for chat API
                        dio.options.baseUrl = Endpoints.chatRestBase;
                        final chatService = ChatService(dio);

                        final conversationId = await chatService.ensureConversation(
                          userId: currentUserId, // Pass as string (MongoDB ObjectId)
                          userType: 'user',
                          peerId: friendId, // Pass as string (MongoDB ObjectId)
                          peerType: peerType,
                        );

                        print('✅ [FriendWidget] Conversation ID: $conversationId');

                        // Navigate to chat screen
                        Get.to(
                          DirectMessageScreen(
                            userName: userName,
                            friendId: friendId,
                            userId: currentUserId,
                            userAsset: profileImage,
                            senderType: 'user',
                            receiverType: peerType,
                          ),
                          transition: Transition.native,
                        );
                      } catch (e) {
                        print('❌ [FriendWidget] Error starting chat: $e');
                        Get.snackbar(
                          'Error',
                          'Failed to start chat: ${e.toString()}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                          backgroundColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xffC5D3E3)
                              : Color(0xff1C2A3A),
                          textColor: ThemeUtil.isDarkMode(context)
                              ? AppColors.blackColor
                              : Color(0xffFFFFFF),
                        ),
                      ),
                      SizedBox(height: 0.3.h), // Small spacing between buttons
                      // Unfollow button
                      SizedBox(
                        width: double.infinity,
                        child: RoundedButtonSmall(
                          isSmall: true, // Make button smaller
                          text: "Unfollow",
                          onPressed: () async {
                      // Show confirmation dialog
                      final confirmed = await Get.dialog<bool>(
                        AlertDialog(
                          title: Text('Unfollow Friend'),
                          content: Text('Are you sure you want to unfollow $userName?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Get.back(result: true),
                              child: Text('Unfollow', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        // Use friendsId (relationship ID) for unfollow, fallback to friendId if not available
                        final relationshipId = friendsId ?? friendId;
                        await _friendsController.unfollow(relationshipId, friendId, context);
                      }
                    },
                          backgroundColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xff191919)
                              : Color(0xffF1F4F5),
                          textColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xffC5D3E3)
                              : Color(0xff1C2A3A),
                        ),
                      ),
                    ],
                  ),
                ])),
      ),
    );
  }
}
