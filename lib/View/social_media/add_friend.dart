import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/custom_appbar.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({super.key});

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
        child: Container(
          child: Column(
            children: [
              countRequest(
                title: 'Requests',
                requestCount: ' (331)',
                showCount: true,
              ),
              FriendRequestWidget(
                profileImage: 'https://via.placeholder.com/150',
                userName: 'John Doeeeeee',
                mutualFriends: [
                  'https://via.placeholder.com/50',
                  'https://via.placeholder.com/51',
                  'https://via.placeholder.com/52',
                ],
                mutualFriendsCount: 3,
              ),
              SizedBox(
                height: 1.h,
              ),
              FriendRequestWidget(
                profileImage: 'https://via.placeholder.com/150',
                userName: 'John Doeeeeee',
                mutualFriends: [
                  'https://via.placeholder.com/50',
                  'https://via.placeholder.com/51',
                  'https://via.placeholder.com/52',
                ],
                mutualFriendsCount: 3,
              ),
              SizedBox(
                height: 2.h,
              ),
              countRequest(
                title: 'People you may know',
                requestCount: '',
                showCount: false,
              ),
              Container(
                child: Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return AddFriendWidget(
                          profileImage: 'https://via.placeholder.com/50',
                          userName: 'Sheroze Rehman',
                          mutualFriends: [
                            'https://via.placeholder.com/50',
                            'https://via.placeholder.com/51',
                            'https://via.placeholder.com/52',
                          ],
                          mutualFriendsCount: 5,
                          onRemove: () {},
                          onAddFriend: () {});
                    },
                  ),
                ),
              )
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

  const countRequest(
      {super.key,
      required this.requestCount,
      required this.showCount,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: CustomTextStyles.lightSmallTextStyle(
              color: Color(0xff19295C), size: 18),
        ),
        Text(
          showCount ? ' ${requestCount}' : '',
          style: CustomTextStyles.w600TextStyle(color: Colors.red, size: 14),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Get.to(AddNewFriend());
          },
          child: Text(
            'See all',
            style: CustomTextStyles.w600TextStyle(
                color: Color(0xff1C2A3A), size: 14),
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

  const FriendRequestWidget({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.mutualFriends,
    required this.mutualFriendsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffFAFAFA), borderRadius: BorderRadius.circular(22.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    userName,
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: Color(0xff19295C), size: 15),
                  ),

                  SizedBox(height: 0.5.h),
                  // Mutual Friends
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          mutualFriends.length,
                          (index) => ClipOval(
                            child: Image.network(
                              mutualFriends[index],
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Text(
                      //   '$mutualFriendsCount mutual friends',
                      //   style: CustomTextStyles.lightTextStyle(
                      //       size: 9.4, color: Color(0xff99A1BE)),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  RoundedButtonSmall(
                      text: "Accept",
                      onPressed: () {},
                      backgroundColor: Color(0xff1C2A3A),
                      textColor: Color(0xffFFFFFF)),
                  SizedBox(
                    width: 4.w,
                  ),
                  RoundedButtonSmall(
                      text: "Reject",
                      onPressed: () {},
                      backgroundColor: Color(0xffF1F4F5),
                      textColor: Color(0xff1C2A3A))
                ],
              ),
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
    return Container(
      height: 30.h,
      width: 46.15.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Color(0xffFAFAFA)),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(children: [
            Positioned(
              top: -10,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 1.5.h,
                ),
                onPressed: onRemove,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: Image.network(
                        profileImage,
                        width: 6.6.h,
                        height: 6.6.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Positioned(
                    //     bottom: 5,
                    //     right: -10,
                    //     child: Container(
                    //       width: 8.w,
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: Center(
                    //           child: Text(
                    //             'NEW',
                    //             style: CustomTextStyles.w600TextStyle(
                    //                 color: Colors.white, size: 6),
                    //           ),
                    //         ),
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: Color(0xff1C2A3A),
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //     ))
                  ],
                ),
                Center(
                  child: Text(
                    userName,
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: Color(0xff19295C), size: 15),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: List.generate(
                        mutualFriends.length,
                        (index) => ClipOval(
                          child: Image.network(
                            mutualFriends[index],
                            width: 1.9.h,
                            height: 1.9.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      '$mutualFriendsCount mutual friends',
                      style: CustomTextStyles.lightTextStyle(
                          size: 9.4, color: Color(0xff99A1BE)),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButtonSmall(
                          text: 'Add Friend',
                          onPressed: () {},
                          backgroundColor: Color(0xff1C2A3A),
                          textColor: Color(0xFFFFFFFF)),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
              ],
            ),
          ])),
    );
  }
}
