import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/home/components/blog_card.dart';
import 'package:joy_app/widgets/appbar/custom_appbar.dart';

import '../../social_media/media_post/bloc/medai_posts_bloc.dart';

class DoctorAllPost extends StatelessWidget {
  DoctorAllPost({super.key});
  final mediaController = Get.find<MediaPostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomeAppBar(
          showIcon: true,
          title: 'All Post',
          actions: [],
          leading: Icon(Icons.arrow_back),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mediaController.postsByUserId.length,
              itemBuilder: ((context, index) {
                final data = mediaController.postsByUserId[index];
                final creatorName =
                    data.createdByUser?.name ?? data.name ?? '';
                final creatorImage =
                    data.createdByUser?.image ?? data.user_image ?? '';
                final creatorId = data.createdByUser?.userId ??
                    data.createdBy?.toString() ??
                    data.userId ??
                    '';
                return Column(
                  children: [
                    Obx(() => MyCustomWidget(
                          isHospital: true,
                          cm: mediaController.postsByUserId[index].comments!,
                          postIndex: index,
                          postId: data.postId.toString(),
                          postTime: data.createdAt.toString(),
                          id: creatorId,
                          imgPath: data.image.toString(),
                          isLiked: true,
                          isReply: false,
                          showImg: (data.image == null || data.image!.isEmpty)
                              ? false
                              : true,
                          postName: creatorName,
                          text: data.description.toString(),
                          userImage: creatorImage,
                        )),
                  ],
                );
              })),
        ));
  }
}
