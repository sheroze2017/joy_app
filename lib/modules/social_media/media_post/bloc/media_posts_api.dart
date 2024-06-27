import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/social_media/media_post/model/media_post.dart';

class MediaPosts {
  final DioClient _dioClient;

  MediaPosts(this._dioClient);

  Future<MediaPostModel> getAllPosts() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllPosts);
      return MediaPostModel.fromJson(result);
    } catch (e) {
      print(e.toString());
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

  Future<bool> createPost(title, description, userId, imgUrl) async {
    try {
      final result = await _dioClient.post(Endpoints.getAllPostById, data: {
        {
          "title": title,
          "description": description,
          "created_by": userId,
          "image_url": imgUrl
        }
      });
      return result['sucess'];
    } catch (e) {
      print(e.toString());
      throw e;
    } finally {}
  }

  Future<String> uploadPhoto(String baseImage64) async {
    try {
      final result = await _dioClient.post(Endpoints.uploadBase64Image,
          data: {"base64Image": baseImage64});
      print(result);
      if (result['sucess'] == true) {
        return result['data'];
      } else {
        return '';
      }
    } catch (e) {
      print(e.toString());
      throw e;
    } finally {}
  }
}
