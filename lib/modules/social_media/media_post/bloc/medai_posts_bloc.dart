import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/media_posts_api.dart';
import 'package:joy_app/view/hospital_flow/dashboard.dart';

import '../model/media_post.dart';

class MediaPostController extends GetxController {
  RxList<MediaPost> allPost = <MediaPost>[].obs;
  RxList<MediaPost> postsByUserId = <MediaPost>[].obs;
  late DioClient dioClient;
  var imgUrl = ''.obs;
  var imgUploaded = false.obs;
  late MediaPosts mediaPosts;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    mediaPosts = MediaPosts(dioClient);
    getAllPost();
  }

  Future<MediaPostModel> getAllPost() async {
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

  Future<String> imageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception('Image file not found');
    }
    Uint8List imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
