import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/core/utils/constant/constant.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_api.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_friend_request_model.dart';
import 'package:joy_app/modules/social_media/friend_request/model/all_user_list.dart';
import 'package:joy_app/modules/social_media/friend_request/model/search_user_profile_model.dart';
import 'package:joy_app/modules/social_media/friend_request/model/friend_requests_and_suggestions_model.dart';

import '../../../auth/models/user.dart';
import '../../../auth/utils/auth_hive_utils.dart';
import '../model/all_post_id.dart';

class FriendsSocialController extends GetxController {
  RxList<FriendRequest> friendRequest = <FriendRequest>[].obs;
  RxList<Suggestion> friends = <Suggestion>[].obs;
  RxList<Suggestion> filteredFriends = <Suggestion>[].obs;
  RxList<UserList> userList = <UserList>[].obs;
  RxList<UserList> filteredList = <UserList>[].obs;
  RxList<Post> userPostById = <Post>[].obs;
  RxList<Suggestion> suggestions = <Suggestion>[].obs;
  RxList<Suggestion> filteredSuggestions = <Suggestion>[].obs;

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
  var showlist = false.obs;
  var fetchAllUser = false.obs;
  var fetchFriendRequest = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    friendApi = FreindsApi(dioClient);
    getFriendRequestsAndSuggestions();
  }

  Future<FriendRequestsAndSuggestions> getFriendRequestsAndSuggestions() async {
    fetchFriendRequest.value = true;
    try {
      friendRequest.clear();
      friends.clear();
      suggestions.clear();
      UserHive? currentUser = await getCurrentUser();

      FriendRequestsAndSuggestions response =
          await friendApi.getFriendRequestsAndSuggestions(currentUser!.userId);
      if (response.data != null) {
        // Populate friends
        friends.clear();
        filteredFriends.clear();
        if (response.data!.friends != null) {
          response.data!.friends!.forEach((element) {
            friends.add(element);
            filteredFriends.add(element);
          });
        }
        print('📊 [FriendsSocialController] Loaded ${friends.length} friends');
        // Populate friend requests
        if (response.data!.friendRequests != null) {
          response.data!.friendRequests!.forEach((element) {
            friendRequest.add(element);
          });
        }
        // Populate suggestions - only include users (exclude institutions like BLOOD_BANK, HOSPITAL, PHARMACY, DOCTOR)
        if (response.data!.suggestions != null) {
          print('📋 [FriendsSocialController] Raw suggestions from API: ${response.data!.suggestions!.length}');
          response.data!.suggestions!.forEach((element) {
            // Only add suggestions that are regular users
            // Filter out institutions that shouldn't be in "People you may know"
            final userRole = element.userRole?.toUpperCase()?.trim() ?? '';
            print('🔍 [FriendsSocialController] Checking suggestion: ${element.name}, role: "$userRole" (raw: "${element.userRole}")');
            
            // List of roles to exclude (institutions, not regular users)
            final excludedRoles = ['DOCTOR', 'BLOOD_BANK', 'HOSPITAL', 'PHARMACY', 'BLOODBANK'];
            
            // Check if role is in excluded list (institutions)
            if (excludedRoles.contains(userRole)) {
              print('⚠️ [FriendsSocialController] Filtered out suggestion with role: $userRole (${element.name})');
            } else if (userRole == 'USER' || userRole.isEmpty) {
              // Double check: if role is empty, make sure it's not an institution by name
              final name = element.name?.toUpperCase() ?? '';
              final isInstitution = name.contains('BLOOD BANK') || 
                                   name.contains('HOSPITAL') || 
                                   name.contains('PHARMACY') ||
                                   name.contains('CLINIC') ||
                                   name.contains('CENTER');
              
              if (!isInstitution) {
                suggestions.add(element);
                print('✅ [FriendsSocialController] Added suggestion: ${element.name} (role: ${userRole.isEmpty ? "empty/assumed USER" : userRole})');
              } else {
                print('⚠️ [FriendsSocialController] Filtered out institution by name: ${element.name}');
              }
            } else {
              print('⚠️ [FriendsSocialController] Filtered out suggestion with unknown role: $userRole (${element.name})');
            }
          });
          print('📊 [FriendsSocialController] Total suggestions after filtering: ${suggestions.length}');
        }
        // Initialize filtered suggestions after all suggestions are added
        filteredSuggestions.clear();
        filteredSuggestions.addAll(suggestions);
      }
      fetchFriendRequest.value = false;
      return response;
    } catch (error) {
      fetchFriendRequest.value = false;
      // Don't throw if it's a Hive type mismatch - user will need to login again
      if (error.toString().contains('is not a subtype') || 
          error.toString().contains('type cast') ||
          error.toString().contains('subtype')) {
        print('⚠️ [FriendsSocialController] Hive data corruption detected. User needs to login again.');
        return FriendRequestsAndSuggestions(code: 401, sucess: false, message: 'Please login again');
      }
      throw (error);
    } finally {
      fetchFriendRequest.value = false;
    }
  }

  Future<AllFriendRequest> getAllFriendRequest() async {
    fetchFriendRequest.value = true;
    try {
      friendRequest.clear();
      UserHive? currentUser = await getCurrentUser();

      AllFriendRequest response =
          await friendApi.getAllFriendRequest(currentUser!.userId);
      if (response.data != null) {
        response.data!.forEach((element) {
          friendRequest.add(element);
        });
      } else {}
      fetchFriendRequest.value = false;
      return response;
    } catch (error) {
      fetchFriendRequest.value = false;
      // Don't throw if it's a Hive type mismatch - user will need to login again
      if (error.toString().contains('is not a subtype') || 
          error.toString().contains('type cast') ||
          error.toString().contains('subtype')) {
        print('⚠️ [FriendsSocialController] Hive data corruption detected. User needs to login again.');
        return AllFriendRequest(code: 401, sucess: false, message: 'Please login again');
      }
      throw (error);
    } finally {
      fetchFriendRequest.value = false;
    }
  }

  Future<void> AddFriend(friendId, BuildContext context) async {
    updateRequestLoader.value = true;
    try {
      UserHive? currentUser = await getCurrentUser();
      bool response =
          await friendApi.addFriend(currentUser!.userId, friendId);
      if (response == true) {
        showSuccessMessage(context, 'Friend request sent successfully');
        // Remove from suggestions list
        suggestions.removeWhere((suggestion) => suggestion.id.toString() == friendId.toString());
        // Also remove from userList if it exists there
        removeUser(friendId.toString());
        // Refresh the suggestions list
        getFriendRequestsAndSuggestions();
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
      SearchUserProfileDetail response;
      
      // Use getMyProfile API for both own profile and friend profiles
      if (myProfile) {
        // Viewing friend's profile - use their user_id
        if (friendId == null || friendId.toString().isEmpty) {
          print('❌ [FriendsSocialController] Invalid friendId: $friendId');
          userProfileData.value = null;
          profileScreenLoader.value = false;
          return SearchUserProfileDetail(
              code: 400, sucess: false, message: 'Invalid user ID');
        }
        response = await friendApi.getMyProfile(friendId.toString());
      } else if (currentUser != null) {
        // Viewing own profile - use logged-in user_id
        response = await friendApi.getMyProfile(currentUser.userId);
      } else {
        print('❌ [FriendsSocialController] No current user found');
        userProfileData.value = null;
        profileScreenLoader.value = false;
        return SearchUserProfileDetail(
            code: 400, sucess: false, message: 'Invalid user ID');
      }

      // Populate posts for the screen
      userPostById.clear();
      if (!myProfile) {
        // Own profile: use posts nested in getMyProfile response
        final postsFromProfile = response.singleData?.posts ??
            (response.data != null && response.data!.isNotEmpty
                ? response.data!.first.posts
                : []);
        if (postsFromProfile != null) {
          userPostById.addAll(postsFromProfile);
        }
      } else {
        // Viewing friend's profile: fallback to posts-by-id API
        await getAllPostById(myProfile, friendId);
      }

      if (response.data != null && response.data!.isNotEmpty) {
        userProfileData.value = response.data!.first;
      } else if (response.singleData != null) {
        // Handle single object response
        userProfileData.value = response.singleData;
      } else {
        userProfileData.value = null;
      }
      profileScreenLoader.value = false;
      return response;
    } catch (error) {
      profileScreenLoader.value = false;
      userProfileData.value = null;
      print('❌ [FriendsSocialController] getSearchUserProfileData() error: $error');
      // Don't throw if it's a type mismatch - just return empty response
      if (error.toString().contains('is not a subtype') || 
          error.toString().contains('type cast') ||
          error.toString().contains('subtype')) {
        print('⚠️ [FriendsSocialController] Type error detected, returning empty response');
        return SearchUserProfileDetail(code: 400, sucess: false, message: 'Error loading profile');
      }
      throw (error);
    } finally {
      profileScreenLoader.value = false;
    }
  }

  Future<AllUserPostModel> getAllPostById(bool myProfile, friendId) async {
    UserHive? currentUser = await getCurrentUser();
    // userProfileData.value = null;
    try {
      profileScreenLoader.value = true;
      userPostById.value = await [];

      AllUserPostModel response = await friendApi.getAllPostById(
        !myProfile ? currentUser!.userId : friendId.toString(),
      );
      if (response.data != null) {
        response.data!.forEach((element) {
          userPostById.add(element);
        });
      } else {
        profileScreenLoader.value = false;
      }
      return response;
    } catch (error) {
      profileScreenLoader.value = false;

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
        if (status == 'REJECTED') {
          showSuccessMessage(context, 'Friend unfollowed successfully');
          // Remove from friends list immediately
          friends.removeWhere((friend) => friend.id.toString() == friendId.toString());
          filteredFriends.removeWhere((friend) => friend.id.toString() == friendId.toString());
        } else {
          showSuccessMessage(context, 'Friend request ${status}');
        }
        getFriendRequestsAndSuggestions();
        getSearchUserProfileData(false, '', context);
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
    fetchAllUser.value = true;
    try {
      AllUserList response = await friendApi.getAllUserList();
      if (response.data != null) {
        response.data!.forEach((element) {
          userList.add(element);
          filteredList.add(element);
        });
      } else {}
      fetchAllUser.value = false;
      return response;
    } catch (error) {
      fetchAllUser.value = false;
      // Don't throw if it's a Hive type mismatch - user will need to login again
      if (error.toString().contains('is not a subtype') || 
          error.toString().contains('type cast') ||
          error.toString().contains('subtype')) {
        print('⚠️ [FriendsSocialController] Hive data corruption detected in getAllUserList. User needs to login again.');
        return AllUserList(code: 401, sucess: false, message: 'Please login again');
      }
      throw (error);
    } finally {
      fetchAllUser.value = false;
    }
  }

  removeUser(friendId) {
    userList!.removeWhere((user) => user.userId == friendId);
  }

  void searchByName(String query) {
    filteredList.value = userList
        .where((user) => user.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void searchFriends(String query) {
    if (query.isEmpty) {
      filteredFriends.assignAll(friends);
    } else {
      final searchQuery = query.toLowerCase();
      filteredFriends.value = friends.where((friend) {
        final name = friend.name?.toLowerCase() ?? '';
        final location = friend.location?.toLowerCase() ?? '';
        return name.contains(searchQuery) || location.contains(searchQuery);
      }).toList();
    }
  }

  void searchSuggestions(String query) {
    if (query.isEmpty) {
      filteredSuggestions.assignAll(suggestions);
    } else {
      final searchQuery = query.toLowerCase();
      filteredSuggestions.value = suggestions.where((suggestion) {
        final name = suggestion.name?.toLowerCase() ?? '';
        final location = suggestion.location?.toLowerCase() ?? '';
        return name.contains(searchQuery) || location.contains(searchQuery);
      }).toList();
    }
  }

  void searchChat(String query) {
    if (query.isEmpty) {
      showlist.value = false;
    } else {
      showlist.value = true;
    }
    filteredList.value = userList
        .where((user) => user.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<String> getAllUserNames() {
    List<String> names = [];
    final friendsList = userProfileData.value?.friends ?? userProfileData.value?.allFriends ?? [];

    if (userProfileData.value != null && friendsList.isNotEmpty) {
      friendsList.forEach((user) {
        // Filter: Only show friends with ACCEPTED status and friend_details status is not DELETED
        final friendStatus = user.status?.toUpperCase();
        final friendDetailsStatus = user.friendDetails?.status?.toUpperCase();
        if ((friendStatus == 'ACCEPTED') && 
            friendDetailsStatus != 'DELETED' && 
            user.friendDetails?.name != null) {
          names.add(user.friendDetails!.name!.toString());
        }
      });
    }

    return names;
  }

  List<String> getAllUserId() {
    List<String> ids = [];
    final friendsList = userProfileData.value?.friends ?? userProfileData.value?.allFriends ?? [];

    // Check if userProfileData has a value and if data is not null
    if (userProfileData.value != null && friendsList.isNotEmpty) {
      friendsList.forEach((user) {
        // Filter: Only show friends with ACCEPTED status and friend_details status is not DELETED
        final friendStatus = user.status?.toUpperCase();
        final friendDetailsStatus = user.friendDetails?.status?.toUpperCase();
        if ((friendStatus == 'ACCEPTED') && friendDetailsStatus != 'DELETED') {
          final friendId = user.friendId?.toString() ?? user.friendDetails?.userId?.toString() ?? '';
          if (friendId.isNotEmpty) {
            ids.add(friendId);
          }
        }
      });
    }

    return ids;
  }

  List<String> getAllUserAssets() {
    List<String> assets = [];
    final friendsList = userProfileData.value?.friends ?? userProfileData.value?.allFriends ?? [];

    // Check if userProfileData has a value and if data is not null
    if (userProfileData.value != null && friendsList.isNotEmpty) {
      friendsList.forEach((user) {
        // Filter: Only show friends with ACCEPTED status and friend_details status is not DELETED
        final friendStatus = user.status?.toUpperCase();
        final friendDetailsStatus = user.friendDetails?.status?.toUpperCase();
        if ((friendStatus == 'ACCEPTED') && friendDetailsStatus != 'DELETED') {
          final image = user.friendDetails?.image?.toString() ?? '';
          // Don't use the default broken image URL - return empty string to trigger icon display
          final isValidImage = image.isNotEmpty && 
                               image.contains('http') &&
                               !image.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');
          assets.add(isValidImage ? image : '');
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
