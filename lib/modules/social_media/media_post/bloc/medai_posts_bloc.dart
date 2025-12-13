import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/media_posts_api.dart';

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

  Rx<TextEditingController> certificateController =
      Rx<TextEditingController>(TextEditingController(text: ""));

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
      print('📱 [MediaPostController] getAllPost() called');
      // Get current user ID
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) {
        print('❌ [MediaPostController] No current user found');
        fetchPostLoader.value = false;
        throw Exception('User not logged in');
      }
      
      // Log stored user details
      print('👤 [MediaPostController] Stored User Details:');
      print('   - UserId (MongoDB ObjectId): ${currentUser.userId}');
      print('   - Name: ${currentUser.firstName}');
      print('   - Email: ${currentUser.email}');
      print('   - Role: ${currentUser.userRole}');
      
      String userId = currentUser.userId; // userId is already String
      print('📱 [MediaPostController] Fetching posts for user: $userId');
      
      allPost.clear();
      MediaPostModel response = await mediaPosts.getAllPosts(userId);
      
      // Check for errors in response
      if (response.sucess == false || response.code != 200) {
        print('❌ [MediaPostController] getAllPost() Error Response:');
        print('   - Code: ${response.code}');
        print('   - Success: ${response.sucess}');
        print('   - Message: ${response.message}');
        fetchPostLoader.value = false;
        return response;
      }
      
      if (response.data != null && response.data!.isNotEmpty) {
        print('✅ [MediaPostController] Adding ${response.data!.length} posts to list');
        print('✅ [MediaPostController] First post ID: ${response.data!.first.postId}');
        print('✅ [MediaPostController] First post isMyLike: ${response.data!.first.isMyLike}');
        print('✅ [MediaPostController] First post title: ${response.data!.first.title}');
        print('✅ [MediaPostController] First post description: ${response.data!.first.description}');
        allPost.clear();
        response.data!.forEach((element) {
          allPost.add(element);
        });
        print('✅ [MediaPostController] Total posts in allPost list: ${allPost.length}');
        print('✅ [MediaPostController] allPost.isEmpty: ${allPost.isEmpty}');
      } else {
        print('⚠️ [MediaPostController] No posts in response');
        allPost.clear();
      }
      fetchPostLoader.value = false;

      return response;
    } catch (error) {
      print('❌ [MediaPostController] getAllPost() Exception: $error');
      fetchPostLoader.value = false;
      // Don't throw if it's a Hive type mismatch - user will need to login again
      if (error.toString().contains('is not a subtype') || 
          error.toString().contains('type cast') ||
          error.toString().contains('subtype')) {
        print('⚠️ [MediaPostController] Hive data corruption detected. User needs to login again.');
        return MediaPostModel(code: 401, sucess: false, message: 'Please login again');
      }
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

  Future<bool> uploadPhoto(imagePath, BuildContext context) async {
    imgUploaded.value = true;
    imgUrl.value = '';
    try {
      imgUrl.value = '';
      print('📸 [MediaPostController] uploadPhoto() called with path: $imagePath');
      // Use form-data upload instead of base64
      final response = await mediaPosts.uploadImageFile(imagePath);
      if (response.isNotEmpty) {
        imgUrl.value = response;
        showSuccessMessage(context, 'Image added sucessfully');
        return true;
      } else {
        showErrorMessage(context, 'Error adding image');
        certificateController.value.clear();
        return false;
      }
    } catch (e) {
      showErrorMessage(context, 'Error adding image');
      imgUploaded.value = false;
      certificateController.value.clear();
      throw (e);
    } finally {
      imgUploaded.value = false;
    }
  }

  Future<String> uploadProfilePhoto(imagePath, BuildContext context) async {
    profileUpload.value = true;
    try {
      print('📸 [MediaPostController] uploadProfilePhoto() called with path: $imagePath');
      // Use form-data upload instead of base64
      final response = await mediaPosts.uploadImageFile(imagePath);
      if (response.isNotEmpty) {
        profileUpload.value = false;
        print('✅ [MediaPostController] Profile photo uploaded: $response');
        return response;
      } else {
        profileUpload.value = false;
        showErrorMessage(context, 'Error adding image');
        return '';
      }
    } catch (e) {
      profileUpload.value = false;
      print('❌ [MediaPostController] uploadProfilePhoto() error: $e');
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
          currentUser!.userId, postId, comment);
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

  Future<bool> toggleLike(String postId, int postIndex, BuildContext context) async {
    try {
      print('❤️ [MediaPostController] toggleLike() called');
      print('❤️ [MediaPostController] Post ID: $postId, Post Index: $postIndex');
      
      // Get current user ID
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) {
        print('❌ [MediaPostController] No current user found');
        showErrorMessage(context, 'User not logged in');
        return false;
      }
      
      // Log stored user details
      print('👤 [MediaPostController] Stored User Details (toggleLike):');
      print('   - UserId (MongoDB ObjectId): ${currentUser.userId}');
      print('   - Name: ${currentUser.firstName}');
      print('   - Email: ${currentUser.email}');
      
      String userId = currentUser.userId; // userId is already String
      
      final result = await mediaPosts.togglePostLike(userId, postId);
      
      // Check response
      bool isSuccess = result['success'] ?? result['sucess'] ?? false;
      int? responseCode = result['code'];
      
      if (isSuccess == true && responseCode == 200) {
        print('✅ [MediaPostController] Like toggled successfully');
        // Refresh posts to get updated like count
        await getAllPost();
        return true;
      } else {
        String errorMessage = result['message'] ?? 'Failed to toggle like';
        print('❌ [MediaPostController] Toggle like failed: $errorMessage');
        showErrorMessage(context, errorMessage);
        return false;
      }
    } catch (error) {
      print('❌ [MediaPostController] toggleLike() Exception: $error');
      showErrorMessage(context, 'Error toggling like');
      return false;
    }
  }
}
