import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_api.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_friend_request_model.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_user_list.dart';
import 'package:joy_app/modules/social_media/friend_request/model/search_user_profile_model.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/media_posts_api.dart';
import 'package:joy_app/modules/hospital/view/dashboard.dart';

import '../../../auth/models/user.dart';
import '../../../auth/utils/auth_hive_utils.dart';

class FriendsSocialController extends GetxController {
  RxList<FriendRequest> friendRequest = <FriendRequest>[].obs;
  RxList<UserList> userList = <UserList>[].obs;
  RxList<UserList> filteredList = <UserList>[].obs;

  final userProfileData = Rxn<UserProfileData>();

  late DioClient dioClient;
  late File profileImg;
  var imgUrl = ''.obs;
  var imgUploaded = false.obs;
  var postUpload = false.obs;
  late FreindsApi friendApi;
  var updateRequestLoader = false.obs;
  var profileUpload = false.obs;
  var profileScreenLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    friendApi = FreindsApi(dioClient);
    getAllFriendRequest();
    getAllUserList();
  }

  Future<AllFriendRequest> getAllFriendRequest() async {
    try {
      friendRequest.clear();
      UserHive? currentUser = await getCurrentUser();

      AllFriendRequest response =
          await friendApi.getAllFriendRequest(currentUser!.userId.toString());
      if (response.data != null) {
        response.data!.forEach((element) {
          friendRequest.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<void> AddFriend(friendId, BuildContext context) async {
    updateRequestLoader.value = true;
    try {
      UserHive? currentUser = await getCurrentUser();

      bool response =
          await friendApi.addFriend(currentUser!.userId.toString(), friendId);
      if (response == true) {
        showSuccessMessage(context, 'Friend request sent successfully');
        removeUser(friendId.toString());
        updateRequestLoader.value = false;
      } else {
        showErrorMessage(context, 'Friend request sended already');
        updateRequestLoader.value = false;
      }
    } catch (error) {
      throw (error);
    } finally {
      updateRequestLoader.value = false;
    }
  }

  Future<SearchUserProfileDetail> getSearchUserProfileData(
      bool myProfile, friendId, BuildContext context) async {
    UserHive? currentUser = await getCurrentUser();
    // userProfileData.value = null;
    try {
      profileScreenLoader.value = true;
      SearchUserProfileDetail response =
          await friendApi.getSearchUserProfileData(
              !myProfile ? currentUser!.userId.toString() : friendId.toString(),
              currentUser!.userId.toString());
      if (response.data != null) {
        userProfileData.value = response.data!.first;
        profileScreenLoader.value = false;
      } else {
        userProfileData.value = null;
        profileScreenLoader.value = false;
      }
      return response;
    } catch (error) {
      profileScreenLoader.value = false;
      userProfileData.value = null;

      throw (error);
    } finally {
      profileScreenLoader.value = false;
    }
  }

  Future<void> updateFriendRequest(
      friendId, status, BuildContext context) async {
    updateRequestLoader.value = true;
    try {
      UserHive? currentUser = await getCurrentUser();

      bool response = await friendApi.updateFriendRequest(status, friendId);
      if (response == true) {
        showSuccessMessage(context, 'Friend request ${status}');
        getAllFriendRequest();
        updateRequestLoader.value = false;
      } else {
        showErrorMessage(context, 'Error while making request');
        updateRequestLoader.value = false;
      }
    } catch (error) {
      updateRequestLoader.value = false;

      throw (error);
    } finally {
      updateRequestLoader.value = false;
    }
  }

  Future<AllUserList> getAllUserList() async {
    try {
      AllUserList response = await friendApi.getAllUserList(20);
      if (response.data != null) {
        response.data!.forEach((element) {
          userList.add(element);
          filteredList.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  removeUser(friendId) {
    userList!.removeWhere((user) => user.userId == friendId);
  }

  void searchByName(String query) {
    filteredList.clear();
    if (query.isEmpty) {
      filteredList.assignAll(userList);
    } else {
      String lowerCaseQuery = query.toLowerCase();
      userList.forEach((user) {
        if (user.name!.toLowerCase().contains(lowerCaseQuery)) {
          filteredList.add(user);
        }
      });
    }
  }

  List<String> getAllUserNames() {
    List<String> names = [];

    // Check if userProfileData has a value and if data is not null
    if (userProfileData.value != null &&
        userProfileData.value!.allFriends!.isNotEmpty) {
      userProfileData.value!.allFriends!.forEach((user) {
        if (user.status == 'Accepted') {
          names.add(user.friendDetails!.name.toString() ??
              ''); // Add each user's name to the list
        }
      });
    }

    return names;
  }

  List<int> getAllUserId() {
    List<int> id = [];

    // Check if userProfileData has a value and if data is not null
    if (userProfileData.value != null &&
        userProfileData.value!.allFriends!.isNotEmpty) {
      userProfileData.value!.allFriends!.forEach((user) {
        if (user.status == 'Accepted') {
          id.add(user.friendId ?? 0);
        }
      });
    }

    return id;
  }

  List<String> getAllUserAssets() {
    List<String> assets = [];

    // Check if userProfileData has a value and if data is not null
    if (userProfileData.value != null &&
        userProfileData.value!.allFriends!.isNotEmpty) {
      userProfileData.value!.allFriends!.forEach((user) {
        if (user.status == 'Accepted') {
          assets.add(user.friendDetails!.image.toString() ??
              'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png'); // Add each user's name to the list
        }
      });
    }

    return assets;
  }

  List<String> getAllProfileImagesUser() {
    List<String> images = [];

    if (userProfileData.value != null && userProfileData.value!.image != null) {
      userProfileData.value!.posts!.forEach((post) {
        if (post.image.toString().contains('http')) {
          images.add(post.image.toString());
        }
      });
    }

    return images;
  }
}
