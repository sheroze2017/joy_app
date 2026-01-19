import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/media_posts_api.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
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
      
      // Get current user ID for profile image upload
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) {
        print('❌ [MediaPostController] No current user found for profile upload');
        profileUpload.value = false;
        showErrorMessage(context, 'User not logged in');
        return '';
      }
      
      String userId = currentUser.userId;
      print('👤 [MediaPostController] Uploading profile image for user: $userId');
      
      // Use form-data upload with user_id to update user profile
      final imageUrl = await mediaPosts.uploadImageFile(imagePath, userId: userId);
      if (imageUrl.isNotEmpty) {
        // Update local storage with new image URL
        print('💾 [MediaPostController] Updating local storage with new image URL: $imageUrl');
        final updatedUser = UserHive(
          userId: currentUser.userId,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          email: currentUser.email,
          password: currentUser.password,
          image: imageUrl, // Update image URL
          userRole: currentUser.userRole,
          authType: currentUser.authType,
          phone: currentUser.phone,
          deviceToken: currentUser.deviceToken,
          token: currentUser.token,
          gender: currentUser.gender,
        );
        await saveUser(updatedUser);
        print('✅ [MediaPostController] Local storage updated with new image');
        
        // Update ProfileController
        try {
          final profileController = Get.find<ProfileController>();
          profileController.image.value = imageUrl;
          profileController.updateUserDetal(); // Refresh profile data
          print('✅ [MediaPostController] ProfileController updated');
        } catch (e) {
          print('⚠️ [MediaPostController] ProfileController not found, skipping update: $e');
        }
        
        profileUpload.value = false;
        print('✅ [MediaPostController] Profile photo uploaded and user updated: $imageUrl');
        showSuccessMessage(context, 'Profile image updated successfully');
        return imageUrl;
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
        Get.back(); // Close modal first
        postUpload.value = false;
        // Reload posts after modal closes to show new post at top
        await getAllPost();
      } else {
        showErrorMessage(context, 'Error adding post');
        postUpload.value = false;
      }
    } catch (error) {
      postUpload.value = false;
      showErrorMessage(context, 'Error creating post: ${error.toString()}');
      // Don't throw error, just show message
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
        // Show success message using Get.snackbar (doesn't require context with overlay)
        Get.snackbar(
          'Success',
          'Comment added',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.check, color: Colors.white),
        );
        
        // Use the actual createdAt from API response, or current time as fallback
        String createdAt = response.data?.createdAt ?? DateTime.now().toIso8601String();
        
        Comments newComment = Comments(
            comment: comment,
            commentId: response.data?.commentId?.toString(),
            createdAt: createdAt,
            name: currentUser.firstName.toString(),
            userId: currentUser.userId.toString(),
            userImage: currentUser.image ?? '',
            user: PostUser(
                userId: currentUser.userId.toString(),
                name: currentUser.firstName,
                image: currentUser.image ?? ''));
        
        // Ensure comments list exists before adding
        if (allPost[postIndex].comments == null) {
          allPost[postIndex].comments = <Comments>[];
        }
        // Add comment at the beginning (index 0) so it appears at the top
        allPost[postIndex].comments!.insert(0, newComment);
        update();
        commentLoad.value = false;
        
        // Refresh posts from server to ensure comment count and data are in sync
        // This ensures the comment appears immediately and stays updated
        await getAllPost();

        return response;
      } else {
        // Show error message using Get.snackbar
        Get.snackbar(
          'Error',
          'Error adding comment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          icon: Icon(Icons.error, color: Colors.white),
        );
        commentLoad.value = false;
        return response;
      }
    } catch (error) {
      commentLoad.value = false;
      // Show error message using Get.snackbar
      Get.snackbar(
        'Error',
        'Failed to add comment: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        icon: Icon(Icons.error, color: Colors.white),
      );
      rethrow;
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
        
        // Update local post state without fetching all posts
        // Note: postIndex is from reversed list, so actual index is (length - 1 - postIndex)
        final actualIndex = allPost.length - 1 - postIndex;
        if (actualIndex >= 0 && actualIndex < allPost.length) {
          final post = allPost[actualIndex];
          
          // Get updated data from response
          final responseData = result['data'];
          if (responseData != null) {
            // Update likes count
            if (responseData['likes'] != null) {
              post.likes = responseData['likes'].toString();
            }
            
            // Update isMyLike status
            if (responseData['is_my_like'] != null) {
              post.isMyLike = responseData['is_my_like'];
            } else if (responseData['isMyLike'] != null) {
              post.isMyLike = responseData['isMyLike'];
            } else {
              // Toggle the current state if API doesn't return it
              post.isMyLike = !(post.isMyLike ?? false);
            }
          } else {
            // Fallback: toggle the current state and increment/decrement likes
            final currentLikes = int.tryParse(post.likes ?? '0') ?? 0;
            final wasLiked = post.isMyLike ?? false;
            post.isMyLike = !wasLiked;
            post.likes = wasLiked ? (currentLikes - 1).toString() : (currentLikes + 1).toString();
          }
          
          // Trigger UI update
          allPost.refresh();
          update();
        }
        
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
