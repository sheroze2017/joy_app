import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/media_posts_api.dart';
import 'package:joy_app/view/hospital_flow/dashboard.dart';

import '../model/media_post.dart';

class MediaPostController extends GetxController {
  RxList<MediaPost> allPost = <MediaPost>[].obs;
  RxList<MediaPost> postsByUserId = <MediaPost>[].obs;
  late DioClient dioClient;

  late MediaPosts mediaPosts;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    mediaPosts = MediaPosts(dioClient);
  }

  Future<MediaPostModel> getAllPost(BuildContext context) async {
    try {
      allPost.clear();
      MediaPostModel response = await mediaPosts.getAllPosts();
      if (response.data != null) {
        response.data!.forEach((element) {
          allPost.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<MediaPostModel> getAllPostById(
      hosipitalId, BuildContext context) async {
    postsByUserId.clear();

    try {
      MediaPostModel response = await mediaPosts.getAllPostById(hosipitalId);
      if (response.data != null) {
        response.data!.forEach((element) {
          postsByUserId.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }
}
