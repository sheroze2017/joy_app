import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/custom_appbar.dart';
import '../../Widgets/rounded_button.dart';
import '../../styles/custom_textstyle.dart';
import 'add_friend.dart';

class AddNewFriend extends StatelessWidget {
  const AddNewFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Add New Friends',
        leading: Text(''),
        showIcon: false,
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          child: Column(
            children: [
              RoundedSearchTextField(
                hintText: 'Search',
                controller: TextEditingController(),
                onChanged: (value) {
                  print('Search text changed: $value');
                },
              ),
              NewFriendRequestWidget(
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
              NewFriendRequestWidget(
                profileImage: 'https://via.placeholder.com/150',
                userName: 'John Doeeeeee',
                mutualFriends: [
                  'https://via.placeholder.com/50',
                  'https://via.placeholder.com/51',
                  'https://via.placeholder.com/52',
                ],
                mutualFriendsCount: 3,
              ),
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

  const NewFriendRequestWidget({
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
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  RoundedButtonSmall(
                      text: "Add Friend",
                      onPressed: () {},
                      backgroundColor: Color(0xff1C2A3A),
                      textColor: Color(0xffFFFFFF)),
                  SizedBox(
                    width: 4.w,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoundedSearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const RoundedSearchTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(width: 5.w),

            SvgPicture.asset('Assets/icons/search-icon.svg'),
            //  Icon(leadingIcon),
            SizedBox(width: 1.w),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: CustomTextStyles.lightSmallTextStyle(
                        color: Color(0xff9CA3AF), size: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
