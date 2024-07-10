import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:joy_app/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';

import 'components/blog_card.dart';

class AllPostScreen extends StatelessWidget {
  AllPostScreen({super.key});

  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        showIcon: false,
        title: 'All Post',
        leading: Icon(Icons.arrow_back),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.h,
              ),
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      _friendsController.userProfileData.value!.posts!.length,
                  itemBuilder: ((context, index) {
                    final data =
                        _friendsController.userProfileData.value!.posts![index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: MyCustomWidget(
                        postTime: '',
                        imgPath: data.image.toString(),
                        isLiked: true,
                        isReply: false,
                        showImg: (data.image == null || data.image!.isEmpty)
                            ? false
                            : true,
                        postName: _friendsController.userProfileData.value!.name
                            .toString(),
                        text: data.description.toString(),
                        id: _friendsController.userProfileData.value!.userId
                            .toString(),
                      ),
                    );
                  }))),
            ],
          ),
        ),
      ),
    );
  }
}
