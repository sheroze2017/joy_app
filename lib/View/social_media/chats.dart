import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/social_media/direct_chat.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/custom_appbar.dart';
import 'add_friend.dart';
import 'new_friend.dart';

class AllChats extends StatelessWidget {
  const AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Chats',
        leading: Text(''),
        showIcon: false,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              RoundedSearchTextFieldLarge(
                hintText: 'Search',
                controller: TextEditingController(),
                onChanged: (value) {
                  print('Search text changed: $value');
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              StoryWidget(
                stories: [
                  'https://via.placeholder.com/150',
                  'https://via.placeholder.com/151',
                  'https://via.placeholder.com/152',
                  'https://via.placeholder.com/153',
                  'https://via.placeholder.com/154',
                  'https://via.placeholder.com/155',
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(DirectMessageScreen());
                },
                child: ChatBox(
                  profileImageUrl:
                      'https://s3-alpha-sig.figma.com/img/45ca/b6f1/c6e732109a3a88876b3f2d11f70ae16b?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Lxn--DS955tIcK4nuEHnI3Nf97VOICuiRYSTk7kw4iILDp~ndRGp--fUQ2GoNVtj1QzNJ1vmz8F4vbAWfeV1w5NObLhkP0986RcpJg2GQueSeyvuTIXDKe8LHhV-PwZBUQAUIT5fXj2wSXMbeZ38PtSZbsYvwwpll1QxALkMmr3ys~bOJD5NHXDFagkMsC1Iiqm2HlSNnvjbuSdJdHcbo~f1ll7cFP9lW-gIl2T9U~R1RKJpCYUCyz~IOiVHmt5WyRoWvlgdhyRBNl0LGoN-LodJvddSNKTJEq6hmKuGK4iHOQKjdHySEzjMsC1HTIgc3rtwsfvK10jqJW-JpuMCTw__',
                  personName: 'John Doe',
                  lastMessage: 'Hello there!',
                  dateTime: '2:30 PM',
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(DirectMessageScreen());
                },
                child: ChatBox(
                  profileImageUrl:
                      'https://s3-alpha-sig.figma.com/img/45ca/b6f1/c6e732109a3a88876b3f2d11f70ae16b?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Lxn--DS955tIcK4nuEHnI3Nf97VOICuiRYSTk7kw4iILDp~ndRGp--fUQ2GoNVtj1QzNJ1vmz8F4vbAWfeV1w5NObLhkP0986RcpJg2GQueSeyvuTIXDKe8LHhV-PwZBUQAUIT5fXj2wSXMbeZ38PtSZbsYvwwpll1QxALkMmr3ys~bOJD5NHXDFagkMsC1Iiqm2HlSNnvjbuSdJdHcbo~f1ll7cFP9lW-gIl2T9U~R1RKJpCYUCyz~IOiVHmt5WyRoWvlgdhyRBNl0LGoN-LodJvddSNKTJEq6hmKuGK4iHOQKjdHySEzjMsC1HTIgc3rtwsfvK10jqJW-JpuMCTw__',
                  personName: 'John Doe',
                  lastMessage: 'Hello there!',
                  dateTime: '2:30 PM',
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryWidget extends StatelessWidget {
  final List<String> stories;

  const StoryWidget({Key? key, required this.stories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        itemCount: stories.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  // Handle "Add Story" tap
                  print('Add Story tapped');
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 30,
                      child: SvgPicture.asset('Assets/images/addStory.svg'),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Your Story',
                      style: CustomTextStyles.lightTextStyle(
                          color: Color(0xff99A1BE), size: 9.4),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Friend's story circle
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  // Handle friend's story tap
                  print('Friend ${index} tapped');
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(stories[
                          index - 1]), // -1 to adjust index for stories list
                      radius: 30,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Friend ${index}',
                      style: CustomTextStyles.lightTextStyle(
                          color: Color(0xff99A1BE), size: 9.4),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  final String profileImageUrl;
  final String personName;
  final String lastMessage;
  final String dateTime;

  const ChatBox({
    Key? key,
    required this.profileImageUrl,
    required this.personName,
    required this.lastMessage,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                personName,
                style: CustomTextStyles.darkHeadingTextStyle(
                    size: 17,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0Xff000000)),
              ),
              SizedBox(height: 0.2.h),
              Container(
                width: 60.w,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lastMessage + ' · ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.lightTextStyle(
                          size: 14, color: Colors.grey),
                    ),
                    Text(
                      dateTime,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Icon(Icons.check, size: 16),
      ],
    );
  }
}
