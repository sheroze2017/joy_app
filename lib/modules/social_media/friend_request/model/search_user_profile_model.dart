import 'all_post_id.dart';

class SearchUserProfileDetail {
  int? code;
  bool? sucess;
  List<UserProfileData>? data;
  UserProfileData? singleData; // Added for single object response (getMyProfile)
  String? message;

  SearchUserProfileDetail(
      {this.code, this.sucess, this.data, this.singleData, this.message});

  SearchUserProfileDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'] ?? json['success'];
    // Handle both array (old API) and single object (new API) responses
    if (json['data'] != null) {
      if (json['data'] is List) {
        data = <UserProfileData>[];
        json['data'].forEach((v) {
          data!.add(UserProfileData.fromJson(v));
        });
      } else if (json['data'] is Map<String, dynamic>) {
        // Single object response (getMyProfile)
        singleData = UserProfileData.fromJson(json['data']);
        data = [singleData!];
      }
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class UserProfileData {
  dynamic userId; // handle String (_id) or int (legacy)
  String? name;
  String? image;
  String? aboutMe; // profile.demographics.about_me
  String? gender; // profile.demographics.gender
  String? dob; // profile.demographics.dob
  String? location; // location from top level or profile.demographics.location
  List<Post>? posts;
  List<AllFriends>? allFriends;
  List<AllFriends>? friends; // new API
  String? friendshipStatus; // FRIENDS, NONE, REQUEST_RECEIVED, REQUEST_SENT_BY_ME
  dynamic friendsId; // The friends relationship ID if exists

  UserProfileData(
      {this.userId,
      this.name,
      this.image,
      this.posts,
      this.allFriends,
      this.aboutMe,
      this.gender,
      this.dob,
      this.location,
      this.friends,
      this.friendshipStatus,
      this.friendsId});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    userId = json['_id'] ?? json['user_id'];
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    name = json['name'];
    image = json['image']?.toString() ?? '';

    // Get location from top level first, then from profile.demographics
    location = json['location']?.toString();
    
    // profile.demographics.about_me, gender, dob
    if (json['profile'] != null && json['profile'] is Map<String, dynamic>) {
      final profile = json['profile'] as Map<String, dynamic>;
      if (profile['demographics'] != null &&
          profile['demographics'] is Map<String, dynamic>) {
        final demographics = profile['demographics'] as Map<String, dynamic>;
        aboutMe = demographics['about_me']?.toString() ?? '';
        gender = demographics['gender']?.toString() ?? '';
        dob = demographics['dob']?.toString() ?? '';
        // Use location from demographics if top-level location is empty
        if ((location == null || location!.isEmpty) && demographics['location'] != null) {
          location = demographics['location']?.toString();
        }
      }
    }

    if (json['posts'] != null) {
      posts = <Post>[];
      json['posts'].forEach((v) {
        posts!.add(Post.fromJson(v));
      });
    } else {
      posts = [];
    }

    if (json['friends'] != null) {
      friends = <AllFriends>[];
      json['friends'].forEach((v) {
        friends!.add(AllFriends.fromJson(v));
      });
    } else {
      friends = [];
    }

    if (json['all_friends'] != null) {
      allFriends = <AllFriends>[];
      json['all_friends'].forEach((v) {
        allFriends!.add(AllFriends.fromJson(v));
      });
    } else {
      allFriends = [];
    }

    // Parse friendship_status and friends_id from getAnotherUserProfile response
    friendshipStatus = json['friendship_status']?.toString();
    friendsId = json['friends_id'];
    if (friendsId != null && friendsId is! String) {
      friendsId = friendsId.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    if (allFriends != null) {
      data['all_friends'] = allFriends!.map((v) => v.toJson()).toList();
    }
    if (friends != null) {
      data['friends'] = friends!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllFriends {
  String? status;
  dynamic userId; // handle String (_id) or int
  dynamic friendId; // handle String (_id) or int
  FriendDetails? friendDetails;

  AllFriends({this.status, this.userId, this.friendId, this.friendDetails});

  AllFriends.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['_id'] ?? json['user_id'];
    friendId = json['friend_id'] ?? json['_id'];
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    if (friendId != null && friendId is! String) {
      friendId = friendId.toString();
    }
    friendDetails = json['friend_details'] != null
        ? FriendDetails.fromJson(json['friend_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    data['friend_id'] = friendId;
    if (friendDetails != null) {
      data['friend_details'] = friendDetails!.toJson();
    }
    return data;
  }
}

class FriendDetails {
  String? name;
  String? image;
  String? userId;
  String? status; // Added to track friend_details status (e.g., "DELETED")

  FriendDetails({this.name, this.image, this.userId, this.status});

  FriendDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'].toString();
    userId = json['_id']?.toString() ?? json['user_id']?.toString() ?? '';
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['user_id'] = userId;
    data['status'] = status;
    return data;
  }
}
