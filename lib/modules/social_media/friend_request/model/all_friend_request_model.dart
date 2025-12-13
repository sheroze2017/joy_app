class AllFriendRequest {
  int? code;
  bool? sucess;
  List<FriendRequest>? data;
  String? message;

  AllFriendRequest({this.code, this.sucess, this.data, this.message});

  AllFriendRequest.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <FriendRequest>[];
      json['data'].forEach((v) {
        data!.add(new FriendRequest.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class FriendRequest {
  dynamic friendsId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  dynamic friendId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  String? status;
  String? createdAt;
  String? updatedAt;
  FriendDetails? friendDetails;

  FriendRequest(
      {this.friendsId,
      this.userId,
      this.friendId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.friendDetails});

  FriendRequest.fromJson(Map<String, dynamic> json) {
    friendsId = json['friends_id'] ?? json['_id'];
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    friendId = json['friend_id'] ?? json['_id'];
    // Convert to String if they're not already
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    if (friendId != null && friendId is! String) {
      friendId = friendId.toString();
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    friendDetails = json['friend_details'] != null
        ? new FriendDetails.fromJson(json['friend_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['friends_id'] = this.friendsId;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.friendDetails != null) {
      data['friend_details'] = this.friendDetails!.toJson();
    }
    return data;
  }
}

class FriendDetails {
  String? name;
  String? image;
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  List<MutualFriends>? mutualFriends;

  FriendDetails({this.name, this.image, this.userId, this.mutualFriends});

  FriendDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image']?.toString() ?? '';
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    // Convert to String if it's not already
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    if (json['mutual_friends'] != null) {
      mutualFriends = <MutualFriends>[];
      json['mutual_friends'].forEach((v) {
        mutualFriends!.add(new MutualFriends.fromJson(v));
      });
    } else {
      mutualFriends = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['user_id'] = this.userId;
    if (this.mutualFriends != null) {
      data['mutual_friends'] =
          this.mutualFriends!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class MutualFriends {
  int? mutualFriendId;
  String? mutualFriendName;
  String? mutualFriendImage;

  MutualFriends(
      {this.mutualFriendId, this.mutualFriendName, this.mutualFriendImage});

  MutualFriends.fromJson(Map<String, dynamic> json) {
    mutualFriendId = json['mutual_friend_id'];
    mutualFriendName = json['mutual_friend_name'];
    mutualFriendImage = json['mutual_friend_image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mutual_friend_id'] = this.mutualFriendId;
    data['mutual_friend_name'] = this.mutualFriendName;
    data['mutual_friend_image'] = this.mutualFriendImage;
    return data;
  }
}
