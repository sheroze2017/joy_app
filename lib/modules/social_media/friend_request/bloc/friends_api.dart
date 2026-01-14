import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_friend_request_model.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_post_id.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_user_list.dart';
import 'package:joy_app/modules/social_media/friend_request/model/search_user_profile_model.dart';
import 'package:joy_app/modules/social_media/friend_request/model/friend_requests_and_suggestions_model.dart';

class FreindsApi {
  final DioClient _dioClient;

  FreindsApi(this._dioClient);

  Future<AllFriendRequest> getAllFriendRequest(userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getAllFriendRequest + '?user_id=${userId}');
      return AllFriendRequest.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> addFriend(userId, friendId) async {
    try {
      final result = await _dioClient.post(Endpoints.addFriend,
          data: {"user_id": userId, "friend_id": friendId});
      return result['code'] == 200 ? result['sucess'] : result['success'];
    } catch (e) {
      return false;
    } finally {}
  }

  Future<SearchUserProfileDetail> getSearchUserProfileData(
      friendId, userId) async {
    try {
      final url = Endpoints.getAllSearchUserDetail;
      print("🌐 [FriendsApi] POST $url friend_id=$friendId user_id=$userId");
      final result = await _dioClient.post(Endpoints.getAllSearchUserDetail,
          data: {"friend_id": friendId, "user_id": userId});
      print("✅ [FriendsApi] Search profile response: code=${result['code']}, success=${result['sucess'] ?? result['success']}, message=${result['message']}");
      return SearchUserProfileDetail.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<AllUserPostModel> getAllPostById(userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getAllPostById + '?user_id=${userId.toString()}');
      return AllUserPostModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<SearchUserProfileDetail> getMyProfile(userId) async {
    try {
      final url = "${Endpoints.getMyProfile}?user_id=${userId.toString()}";
      print("🌐 [FriendsApi] POST $url");
      final result = await _dioClient.post(url);
      print("✅ [FriendsApi] My profile response: code=${result['code']}, success=${result['sucess'] ?? result['success']}, message=${result['message']}");
      return SearchUserProfileDetail.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> updateFriendRequest(String status, String friendId) async {
    try {
      final result = await _dioClient.post(Endpoints.updateFriendRequest,
          data: {"friends_id": friendId, "status": status});
      return result['code'] == 200 ? result['sucess'] : result['success'];
    } catch (e) {
      return false;
    } finally {}
  }

  Future<AllUserList> getAllUserList() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllUser);
      return AllUserList.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<FriendRequestsAndSuggestions> getFriendRequestsAndSuggestions(userId) async {
    try {
      final url = "${Endpoints.getFriendRequestsAndSuggestions}?user_id=${userId.toString()}";
      print("🌐 [FriendsApi] GET $url");
      final result = await _dioClient.get(url);
      print("✅ [FriendsApi] Friend requests and suggestions response: code=${result['code']}, success=${result['sucess'] ?? result['success']}, message=${result['message']}");
      return FriendRequestsAndSuggestions.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
