import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/custom_appbar.dart';
import '../../Widgets/rounded_button.dart';
import '../../styles/custom_textstyle.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 30),
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
              SizedBox(
                height: 2.h,
              ),
              NewFriendRequestWidget(
                profileImage:
                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600',
                userName: 'Jim Hopper',
                mutualFriends: [
                  'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600',
                  'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600',
                ],
                mutualFriendsCount: 3,
              ),
              SizedBox(
                height: 1.h,
              ),
              NewFriendRequestWidget(
                profileImage:
                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600',
                userName: 'Jim Hopper',
                mutualFriends: [
                  'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600',
                  'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600',
                  'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=600',
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
                onPressed: () {},
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
