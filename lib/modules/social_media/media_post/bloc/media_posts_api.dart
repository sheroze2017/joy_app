import 'dart:io';
import 'package:dio/dio.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/social_media/media_post/model/media_post.dart';

import '../model/comment_model.dart';
import '../model/create_post_model.dart';

class MediaPosts {
  final DioClient _dioClient;

  MediaPosts(this._dioClient);

  Future<MediaPostModel> getAllPosts(String userId) async {
    try {
      print('📱 [MediaPosts] getAllPosts() called');
      print('📱 [MediaPosts] User ID: $userId');
      final result = await _dioClient.get(Endpoints.getAllPosts, queryParameters: {'user_id': userId});
      print('📡 [MediaPosts] Request URL: ${Endpoints.baseUrl}${Endpoints.getAllPosts}?user_id=$userId');
      print('✅ [MediaPosts] getAllPosts() Response: $result');
      print('📥 [MediaPosts] Response Code: ${result['code']}, Success: ${result['success'] ?? result['sucess']}');
      print('📥 [MediaPosts] Posts Count: ${result['data']?.length ?? 0}');
      final model = MediaPostModel.fromJson(result);
      print('✅ [MediaPosts] Parsed ${model.data?.length ?? 0} posts');
      return model;
    } catch (e) {
      print('❌ [MediaPosts] getAllPosts() error: $e');
      throw e;
    }
  }

  Future<MediaPostModel> getAllPostById(userId) async {
    try {
      final result =
          await _dioClient.get(Endpoints.getAllPostById + '?user_id=${userId}');
      return MediaPostModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<CreatePostModel> createPost(title, description, userId, imgUrl) async {
    try {
      final result = await _dioClient.post(Endpoints.createPost, data: {
        "title": title,
        "description": description,
        "created_by": userId,
        "image_url": imgUrl
      });
      return CreatePostModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    } finally {}
  }

  // New method: Upload image using form-data (multipart)
  // If userId is provided, it will update the user's profile image
  // If userId is null, it will just return the image URL (for posts, etc.)
  Future<String> uploadImageFile(String imagePath, {String? userId}) async {
    try {
      print('📸 [MediaPosts] uploadImageFile() called');
      print('📸 [MediaPosts] Image path: $imagePath');
      if (userId != null) {
        print('👤 [MediaPosts] Uploading profile image for user: $userId');
      } else {
        print('📸 [MediaPosts] Uploading image (no user_id - for posts, etc.)');
      }
      
      File imageFile = File(imagePath);
      if (!imageFile.existsSync()) {
        print('❌ [MediaPosts] Image file not found: $imagePath');
        throw Exception('Image file not found');
      }

      String fileName = imagePath.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        ),
      });

      // Build URL with query parameter if userId is provided
      String endpoint = Endpoints.uploadImage;
      if (userId != null && userId.isNotEmpty) {
        endpoint = '${Endpoints.uploadImage}?user_id=$userId';
      }

      print('📤 [MediaPosts] Uploading image as form-data...');
      print('📤 [MediaPosts] Endpoint: ${Endpoints.baseUrl}$endpoint');
      print('📤 [MediaPosts] User ID: ${userId ?? "null"}');
      print('📤 [MediaPosts] Image file: $fileName');
      print('📤 [MediaPosts] Request will include Authorization: Bearer token (added by interceptor)');
      final result = await _dioClient.upload(endpoint, data: formData);
      print('✅ [MediaPosts] uploadImageFile() response: $result');
      
      // Handle both 'sucess' and 'success' spellings
      final isSuccess = result['sucess'] == true || result['success'] == true;
      if (isSuccess) {
        String imageUrl = '';
        if (userId != null) {
          // When userId is provided, response structure can be:
          // 1. data.image (direct image field)
          // 2. data.user.image (nested user object)
          // 3. data.image_url (alternative field name)
          if (result['data'] != null) {
            if (result['data'] is Map) {
              // Check direct image field first (most common)
              imageUrl = result['data']['image']?.toString() ?? '';
              
              // Fallback to nested user.image
              if (imageUrl.isEmpty && result['data']['user'] != null) {
                imageUrl = result['data']['user']['image']?.toString() ?? '';
              }
              
              // Fallback to image_url
              if (imageUrl.isEmpty) {
                imageUrl = result['data']['image_url']?.toString() ?? '';
              }
            } else if (result['data'] is String) {
              // If data is a string, it's the URL directly
              imageUrl = result['data'];
            }
          }
          print('✅ [MediaPosts] Profile image uploaded and user updated. URL: $imageUrl');
        } else {
          // When userId is not provided, response structure is: data (just the URL string)
          if (result['data'] is String) {
            imageUrl = result['data'];
          } else if (result['data'] is Map) {
            imageUrl = result['data']['image']?.toString() ?? 
                      result['data']['image_url']?.toString() ?? 
                      '';
          }
          print('✅ [MediaPosts] Image uploaded successfully. URL: $imageUrl');
        }
        return imageUrl;
      } else {
        print('⚠️ [MediaPosts] Upload failed: ${result['message'] ?? 'Unknown error'}');
        return '';
      }
    } catch (e) {
      print('❌ [MediaPosts] uploadImageFile() error: $e');
      return '';
    }
  }

  // Legacy method: Upload photo using base64 (kept for backward compatibility)
  Future<String> uploadPhoto(String baseImage64) async {
    print('📸 [MediaPosts] uploadPhoto() called (base64 - legacy)');
    try {
      final result = await _dioClient.post(Endpoints.uploadBase64Image,
          data: {"base64Image": baseImage64});
      print('✅ [MediaPosts] uploadPhoto() response: $result');
      if (result['sucess'] == true) {
        return result['data'];
      } else {
        return '';
      }
    } catch (e) {
      print('❌ [MediaPosts] uploadPhoto() error: $e');
      return '';
    } finally {}
  }

  Future<Comment> addComment(
      String userId, String postId, String comment) async {
    try {
      final result = await _dioClient.post(Endpoints.addComment,
          data: {"user_id": userId, "post_id": postId, "comment": comment});
      return Comment.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    } finally {}
  }

  Future<Map<String, dynamic>> togglePostLike(String userId, String postId) async {
    try {
      print('❤️ [MediaPosts] togglePostLike() called');
      print('❤️ [MediaPosts] User ID: $userId, Post ID: $postId');
      final requestData = {
        "user_id": userId,
        "post_id": postId
      };
      print('📤 [MediaPosts] togglePostLike() Request Data: $requestData');
      final result = await _dioClient.post(Endpoints.togglePostLike, data: requestData);
      print('✅ [MediaPosts] togglePostLike() Response: $result');
      return result;
    } catch (e) {
      print('❌ [MediaPosts] togglePostLike() error: $e');
      throw e;
    }
  }
}
