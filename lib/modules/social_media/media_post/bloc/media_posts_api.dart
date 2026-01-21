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
      print('📸 [MediaPosts] ========== UPLOAD IMAGE FILE START ==========');
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

      // Get file details
      final fileStat = await imageFile.stat();
      final fileSize = fileStat.size;
      final fileExtension = imagePath.split('.').last.toLowerCase();
      String fileName = imagePath.split('/').last;
      
      print('📁 [MediaPosts] File Details:');
      print('   - File Name: $fileName');
      print('   - File Size: ${fileSize} bytes (${(fileSize / 1024).toStringAsFixed(2)} KB)');
      print('   - File Extension: $fileExtension');
      print('   - File Path: $imagePath');
      
      // Use 'file' field name for post images (as per API spec), 'image' for profile
      String fieldName = userId != null ? 'image' : 'file';
      print('🏷️ [MediaPosts] FormData Field Name: "$fieldName"');
      print('🏷️ [MediaPosts] Field Name Logic: userId != null ? "image" : "file"');
      print('🏷️ [MediaPosts] Selected Field: ${userId != null ? "image (profile upload)" : "file (post upload)"}');
      
      final multipartFile = await MultipartFile.fromFile(
        imagePath,
        filename: fileName,
      );
      
      print('📦 [MediaPosts] MultipartFile created:');
      print('   - Field Name: $fieldName');
      print('   - File Name: ${multipartFile.filename}');
      print('   - Content Type: ${multipartFile.contentType}');
      print('   - Length: ${multipartFile.length} bytes');
      
      FormData formData = FormData.fromMap({
        fieldName: multipartFile,
      });
      
      print('📋 [MediaPosts] FormData Structure:');
      print('   - Fields Count: ${formData.fields.length}');
      print('   - Files Count: ${formData.files.length}');
      print('   - FormData Fields: ${formData.fields}');
      print('   - FormData Files:');
      for (var file in formData.files) {
        print('     * Key: "${file.key}", FileName: "${file.value.filename}", Length: ${file.value.length}');
      }

      // Build URL with query parameter if userId is provided
      String endpoint = Endpoints.uploadImage;
      String fullUrl = '${Endpoints.baseUrl}$endpoint';
      if (userId != null && userId.isNotEmpty) {
        endpoint = '${Endpoints.uploadImage}?user_id=$userId';
        fullUrl = '${Endpoints.baseUrl}${Endpoints.uploadImage}?user_id=$userId';
      }

      print('🌐 [MediaPosts] Request Details:');
      print('   - Base URL: ${Endpoints.baseUrl}');
      print('   - Endpoint: $endpoint');
      print('   - Full URL: $fullUrl');
      print('   - User ID: ${userId ?? "null"}');
      print('   - Method: POST');
      print('   - Content-Type: multipart/form-data (auto-set by Dio)');
      print('📤 [MediaPosts] Request will include Authorization: Bearer token (added by interceptor)');
      
      // Clear summary of API call and payload
      print('');
      print('🚀 [MediaPosts] ========== API CALL SUMMARY ==========');
      print('🚀 [MediaPosts] API Endpoint: $fullUrl');
      print('🚀 [MediaPosts] HTTP Method: POST');
      print('🚀 [MediaPosts] Payload Type: FormData (multipart/form-data)');
      print('🚀 [MediaPosts] Payload Structure:');
      print('   📎 Form Field Name: "$fieldName"');
      print('   📎 File Name: "$fileName"');
      print('   📎 File Size: ${fileSize} bytes');
      print('   📎 File Extension: $fileExtension');
      if (userId != null) {
        print('   📎 Query Parameter: user_id=$userId');
      }
      print('🚀 [MediaPosts] Complete Payload:');
      print('   FormData {');
      print('     "$fieldName": MultipartFile(');
      print('       filename: "$fileName",');
      print('       contentType: ${multipartFile.contentType},');
      print('       length: ${multipartFile.length}');
      print('     )');
      print('   }');
      print('🚀 [MediaPosts] =======================================');
      print('');
      
      print('📤 [MediaPosts] Sending upload request...');
      final result = await _dioClient.upload(endpoint, data: formData);
      
      print('');
      print('✅ [MediaPosts] ========== UPLOAD RESPONSE RECEIVED ==========');
      print('✅ [MediaPosts] Response Type: ${result.runtimeType}');
      print('✅ [MediaPosts] Complete Response: $result');
      print('');
      
      // Handle both 'sucess' and 'success' spellings
      print('🔍 [MediaPosts] ========== RESPONSE PARSING ==========');
      if (result is Map) {
        print('🔍 [MediaPosts] Response Structure: Map');
        print('🔍 [MediaPosts] Response Keys: ${result.keys.toList()}');
        print('');
        
        // Log complete response structure
        result.forEach((key, value) {
          print('🔍 [MediaPosts] "$key": ${value.runtimeType} = $value');
          
          // If value is a Map, show its structure
          if (value is Map) {
            print('   └─ Map Keys: ${value.keys.toList()}');
            value.forEach((nestedKey, nestedValue) {
              print('      "$nestedKey": ${nestedValue.runtimeType} = $nestedValue');
              
              // Check for URLs
              if (nestedValue is String && (nestedValue.toString().startsWith('http://') || nestedValue.toString().startsWith('https://'))) {
                print('      🔗 [URL FOUND] $nestedKey: $nestedValue');
              }
              
              // If nested value is also a Map
              if (nestedValue is Map) {
                nestedValue.forEach((deepKey, deepValue) {
                  print('         "$deepKey": ${deepValue.runtimeType} = $deepValue');
                  if (deepValue is String && (deepValue.toString().startsWith('http://') || deepValue.toString().startsWith('https://'))) {
                    print('         🔗 [URL FOUND] $deepKey: $deepValue');
                  }
                });
              }
            });
          }
          
          // If value is a List
          if (value is List) {
            print('   └─ List Length: ${value.length}');
            for (int i = 0; i < value.length && i < 5; i++) {
              print('      [$i]: ${value[i]}');
            }
          }
          
          // Check for URLs in string values
          if (value is String && (value.toString().startsWith('http://') || value.toString().startsWith('https://'))) {
            print('   🔗 [URL FOUND] $key: $value');
          }
        });
        
        print('');
        print('🔍 [MediaPosts] Parsed Values:');
        print('   - code: ${result['code']}');
        print('   - success (sucess): ${result['sucess']}');
        print('   - success (success): ${result['success']}');
        print('   - message: ${result['message']}');
        
        if (result['data'] != null) {
          print('   - data: ${result['data']}');
          print('   - data type: ${result['data'].runtimeType}');
          
          // Check if data contains URL
          if (result['data'] is String) {
            final dataString = result['data'] as String;
            print('   - data (string): $dataString');
            if (dataString.startsWith('http://') || dataString.startsWith('https://')) {
              print('   🔗 [URL IN DATA] $dataString');
            }
          } else if (result['data'] is Map) {
            final dataMap = result['data'] as Map;
            print('   - data (map) keys: ${dataMap.keys.toList()}');
            dataMap.forEach((dataKey, dataValue) {
              print('      "$dataKey": ${dataValue.runtimeType} = $dataValue');
              if (dataValue is String && (dataValue.toString().startsWith('http://') || dataValue.toString().startsWith('https://'))) {
                print('      🔗 [URL IN DATA.$dataKey] $dataValue');
              }
              // Check common URL field names
              if (['url', 'image_url', 'imageUrl', 'image', 'file_url', 'fileUrl', 'link', 'src'].contains(dataKey.toString().toLowerCase())) {
                print('      🔗 [POSSIBLE URL FIELD: $dataKey] $dataValue');
              }
            });
          }
        }
        
        // Check for common URL field names in response
        final urlFields = ['url', 'image_url', 'imageUrl', 'image', 'file_url', 'fileUrl', 'link', 'src', 'media_url', 'mediaUrl'];
        for (var urlField in urlFields) {
          if (result.containsKey(urlField)) {
            print('   🔗 [URL FIELD FOUND: $urlField] ${result[urlField]}');
          }
        }
      } else if (result is String) {
        print('🔍 [MediaPosts] Response Structure: String');
        print('🔍 [MediaPosts] Response Content: $result');
        if (result.startsWith('http://') || result.startsWith('https://')) {
          print('🔗 [URL FOUND IN RESPONSE] $result');
        }
      } else {
        print('🔍 [MediaPosts] Response Structure: ${result.runtimeType}');
        print('🔍 [MediaPosts] Response Content: $result');
      }
      
      print('🔍 [MediaPosts] ===========================================');
      print('');
      
      final isSuccess = result['sucess'] == true || result['success'] == true;
      print('🔍 [MediaPosts] Is Success: $isSuccess');
      
      if (isSuccess) {
        String imageUrl = '';
        if (userId != null) {
          print('👤 [MediaPosts] Processing profile image response...');
          // When userId is provided, response structure can be:
          // 1. data.image (direct image field)
          // 2. data.user.image (nested user object)
          // 3. data.image_url (alternative field name)
          if (result['data'] != null) {
            print('🔍 [MediaPosts] Response data type: ${result['data'].runtimeType}');
            print('🔍 [MediaPosts] Response data: ${result['data']}');
            if (result['data'] is Map) {
              final dataMap = result['data'] as Map;
              print('🔍 [MediaPosts] Data Map keys: ${dataMap.keys.toList()}');
              // Check direct image field first (most common)
              imageUrl = result['data']['image']?.toString() ?? '';
              print('🔍 [MediaPosts] Tried data.image: "$imageUrl"');
              
              // Fallback to nested user.image
              if (imageUrl.isEmpty && result['data']['user'] != null) {
                imageUrl = result['data']['user']['image']?.toString() ?? '';
                print('🔍 [MediaPosts] Tried data.user.image: "$imageUrl"');
              }
              
              // Fallback to image_url
              if (imageUrl.isEmpty) {
                imageUrl = result['data']['image_url']?.toString() ?? '';
                print('🔍 [MediaPosts] Tried data.image_url: "$imageUrl"');
              }
            } else if (result['data'] is String) {
              // If data is a string, it's the URL directly
              imageUrl = result['data'];
              print('🔍 [MediaPosts] Data is string URL: "$imageUrl"');
            }
          } else {
            print('⚠️ [MediaPosts] Response data is null');
          }
          print('✅ [MediaPosts] Profile image uploaded and user updated. URL: $imageUrl');
        } else {
          print('📸 [MediaPosts] Processing post image response...');
          // When userId is not provided, response structure is: data (just the URL string)
          if (result['data'] != null) {
            print('🔍 [MediaPosts] Response data type: ${result['data'].runtimeType}');
            print('🔍 [MediaPosts] Response data: ${result['data']}');
            if (result['data'] is String) {
              imageUrl = result['data'];
              print('🔍 [MediaPosts] Data is string URL: "$imageUrl"');
            } else if (result['data'] is Map) {
              final dataMap = result['data'] as Map;
              print('🔍 [MediaPosts] Data Map keys: ${dataMap.keys.toList()}');
              imageUrl = result['data']['image']?.toString() ?? 
                        result['data']['image_url']?.toString() ?? 
                        '';
              print('🔍 [MediaPosts] Extracted from Map: "$imageUrl"');
            }
          } else {
            print('⚠️ [MediaPosts] Response data is null');
          }
          print('✅ [MediaPosts] Image uploaded successfully. URL: $imageUrl');
        }
        print('📸 [MediaPosts] ========== UPLOAD SUCCESS ==========');
        return imageUrl;
      } else {
        print('⚠️ [MediaPosts] ========== UPLOAD FAILED ==========');
        print('⚠️ [MediaPosts] Upload failed - Response indicates failure');
        print('⚠️ [MediaPosts] Error Code: ${result['code'] ?? "N/A"}');
        print('⚠️ [MediaPosts] Error Message: ${result['message'] ?? 'Unknown error'}');
        print('⚠️ [MediaPosts] Full Error Response: $result');
        print('⚠️ [MediaPosts] ====================================');
        return '';
      }
    } catch (e, stackTrace) {
      print('❌ [MediaPosts] ========== UPLOAD ERROR ==========');
      print('❌ [MediaPosts] uploadImageFile() error: $e');
      print('❌ [MediaPosts] Error Type: ${e.runtimeType}');
      if (e is DioException) {
        print('❌ [MediaPosts] DioException Details:');
        print('   - Type: ${e.type}');
        print('   - Message: ${e.message}');
        print('   - Request Path: ${e.requestOptions.path}');
        print('   - Request Method: ${e.requestOptions.method}');
        print('   - Request Data Type: ${e.requestOptions.data.runtimeType}');
        if (e.requestOptions.data is FormData) {
          final fd = e.requestOptions.data as FormData;
          print('   - FormData Fields: ${fd.fields}');
          print('   - FormData Files Count: ${fd.files.length}');
          for (var file in fd.files) {
            print('     * Key: "${file.key}", FileName: "${file.value.filename}"');
          }
        }
        print('   - Response Status Code: ${e.response?.statusCode}');
        print('   - Response Data: ${e.response?.data}');
        print('   - Response Headers: ${e.response?.headers}');
      }
      print('❌ [MediaPosts] Stack Trace: $stackTrace');
      print('❌ [MediaPosts] ====================================');
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
