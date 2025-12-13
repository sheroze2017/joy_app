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
  Future<String> uploadImageFile(String imagePath) async {
    try {
      print('📸 [MediaPosts] uploadImageFile() called');
      print('📸 [MediaPosts] Image path: $imagePath');
      
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

      print('📤 [MediaPosts] Uploading image as form-data...');
      final result = await _dioClient.upload(Endpoints.uploadImage, data: formData);
      print('✅ [MediaPosts] uploadImageFile() response: $result');
      
      if (result['sucess'] == true) {
        return result['data'] ?? '';
      } else {
        print('⚠️ [MediaPosts] Upload failed: ${result['message']}');
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
