import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/social_media/chat/view/direct_chat.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:sizer/sizer.dart';

import '../../../../Widgets/custom_appbar.dart';
import '../../friend_request/bloc/friends_bloc.dart';
import '../../friend_request/view/add_friend.dart';
import '../../friend_request/view/new_friend.dart';

class AllChats extends StatelessWidget {
  AllChats({super.key});
  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();

  ChatController _chatController = Get.put(ChatController());

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
          child: Stack(
            children: [
              RoundedSearchTextFieldLarge(
                  hintText: 'Search',
                  controller: TextEditingController(),
                  onChanged: _friendsController.searchChat),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
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
                    Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _friendsController.getAllUserNames().length,
                        itemBuilder: (context, index) {
                          final img =
                              _friendsController.getAllUserAssets()[index];
                          final name =
                              _friendsController.getAllUserNames()[index];
                          final id = _friendsController.getAllUserId()[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _chatController.createConvo(id, name);
                                },
                                child: ChatBox(
                                  profileImageUrl: img,
                                  personName: name,
                                  lastMessage: 'Hello there!',
                                  dateTime: '2:30 PM',
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          );
                        }))
                  ],
                ),
              ),
              Obx(() => _friendsController.showlist.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        constraints: BoxConstraints(maxHeight: 50.h),
                        child: Obx(
                          () => ListView.builder(
                            //shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount:
                                _friendsController.filteredList.value.length,
                            itemBuilder: ((context, index) {
                              final data =
                                  _friendsController.filteredList.value[index];

                              return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(
                                      onTap: () {
                                        _friendsController.showlist.value =
                                            false;
                                        _chatController.createConvo(
                                            data.userId ?? 0,
                                            data.name.toString());
                                      },
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: Image.network(
                                              data.image!.contains('http')
                                                  ? data.image.toString()
                                                  : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                              width: 6.6.h,
                                              height: 6.6.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.name.toString(),
                                              style: CustomTextStyles
                                                  .darkHeadingTextStyle(
                                                      color: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? AppColors.whiteColor
                                                          : Color(0xff19295C),
                                                      size: 15),
                                            ),
                                          ),
                                        ],
                                      )));
                            }),
                          ),
                        ),
                      ),
                    )
                  : Container()),
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
