import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/media_posts_api.dart';
import 'package:joy_app/modules/hospital/view/dashboard.dart';

import '../../../auth/utils/auth_hive_utils.dart';
import '../model/comment_model.dart';
import '../model/create_post_model.dart';
import '../model/media_post.dart';

class MediaPostController extends GetxController {
  RxList<MediaPost> allPost = <MediaPost>[].obs;
  RxList<MediaPost> postsByUserId = <MediaPost>[].obs;
  late DioClient dioClient;
  late File profileImg;
  var imgUrl = ''.obs;
  var imgUploaded = false.obs;
  var postUpload = false.obs;
  late MediaPosts mediaPosts;
  var profileUpload = false.obs;
  var commentLoad = false.obs;
  var fetchPostLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    mediaPosts = MediaPosts(dioClient);
    getAllPost();
  }

  Future<MediaPostModel> getAllPost() async {
    fetchPostLoader.value = true;
    try {
      allPost.clear();
      MediaPostModel response = await mediaPosts.getAllPosts();
      if (response.data != null) {
        response.data!.forEach((element) {
          allPost.add(element);
        });
      } else {}
      fetchPostLoader.value = false;

      return response;
    } catch (error) {
      fetchPostLoader.value = false;

      throw (error);
    } finally {
      fetchPostLoader.value = false;
    }
  }

  Future<MediaPostModel> getAllPostById(
      bool isHospital, hosipitalId, BuildContext context) async {
    postsByUserId.clear();
    UserHive? currentUser = await getCurrentUser();
    hosipitalId =
        await isHospital ? currentUser!.userId.toString() : hosipitalId;
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

  Future<void> uploadPhoto(imagePath, BuildContext context) async {
    imgUploaded.value = true;
    imgUrl.value = '';
    try {
      imgUrl.value = '';
      String base64Image = await imageToBase64(imagePath);
      print('Base64 Image: $base64Image');
      final response = await mediaPosts.uploadPhoto(base64Image);
      if (response.isNotEmpty) {
        imgUrl.value = response;
        showSuccessMessage(context, 'Image added sucessfully');
      } else {
        showErrorMessage(context, 'Error adding image');
      }
    } catch (e) {
      showErrorMessage(context, 'Error adding image');

      imgUploaded.value = false;
      throw (e);
    } finally {
      imgUploaded.value = false;
    }
  }

  Future<String> uploadProfilePhoto(imagePath, BuildContext context) async {
    profileUpload.value = true;
    try {
      String base64Image = await imageToBase64(imagePath);
      final response = await mediaPosts.uploadPhoto(base64Image);
      if (response.isNotEmpty) {
        profileUpload.value = false;

        return response;
      } else {
        profileUpload.value = false;

        showErrorMessage(context, 'Error adding image');
        return '';
      }
    } catch (e) {
      profileUpload.value = false;

      showErrorMessage(context, 'Error adding image');
      return '';
    } finally {
      profileUpload.value = false;
    }
  }

  Future<String> imageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception('Image file not found');
    }
    Uint8List imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  createPostByUser(desc, userIdPost, imgPath, BuildContext context) async {
    postUpload.value = true;
    try {
      CreatePostModel response =
          await mediaPosts.createPost('', desc, userIdPost, imgPath);
      if (response.sucess == true) {
        showSuccessMessage(context, 'Post posted successfully');
        getAllPost();
        Get.back();
        postUpload.value = false;
      } else {
        showErrorMessage(context, 'Error adding post');
        postUpload.value = false;
      }
    } catch (error) {
      postUpload.value = false;

      throw (error);
    } finally {
      postUpload.value = false;
    }
  }

  Future<Comment> commentAdd(
      postId, comment, BuildContext context, postIndex) async {
    commentLoad.value = true;
    UserHive? currentUser = await getCurrentUser();

    try {
      Comment response = await mediaPosts.addComment(
          currentUser!.userId.toString(), postId, comment);
      if (response.sucess == true) {
        showSuccessMessage(context, 'Comment added');
        Comments newComment = await Comments(
            comment: comment,
            commentId: response.data!.commentId,
            createdAt: DateTime.now().toString(),
            name: currentUser.firstName.toString());
        allPost[postIndex].comments!.add(newComment);
        update();
        commentLoad.value = false;

        return response;
      } else {
        showErrorMessage(context, 'Error adding comment');
        commentLoad.value = false;
        return response;
      }
    } catch (error) {
      commentLoad.value = false;
      throw (error);
    } finally {
      commentLoad.value = false;
    }
  }
}
