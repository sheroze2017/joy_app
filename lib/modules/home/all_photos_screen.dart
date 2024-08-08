import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:sizer/sizer.dart';

class AllPhotoScreen extends StatelessWidget {
  AllPhotoScreen({super.key});

  FriendsSocialController _friendsController =
      Get.find<FriendsSocialController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'All Photos',
          leading: Icon(Icons.arrow_back),
          actions: [],
          showIcon: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.5.h,
              ),
              Obx(
                () => GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount:
                      _friendsController.getAllProfileImagesUser().length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        height: 40.h,
                        fit: BoxFit.cover,
                        imageUrl:
                            _friendsController.getAllProfileImagesUser()[index],
                        placeholder: (context, url) => Center(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: LoadingWidget(),
                        )),
                        errorWidget: (context, url, error) => Center(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ErorWidget(),
                        )),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
