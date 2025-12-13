class SearchUserProfileDetail {
  int? code;
  bool? sucess;
  List<UserProfileData>? data;
  String? message;

  SearchUserProfileDetail({this.code, this.sucess, this.data, this.message});

  SearchUserProfileDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <UserProfileData>[];
      json['data'].forEach((v) {
        data!.add(new UserProfileData.fromJson(v));
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

class UserProfileData {
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  String? name;
  String? image;
  List<Posts>? posts;
  List<AllFriends>? allFriends;

  UserProfileData(
      {this.userId, this.name, this.image, this.posts, this.allFriends});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'user_id' (legacy) fields
    userId = json['_id'] ?? json['user_id'];
    // Convert to String if it's not already
    if (userId != null && userId is! String) {
      userId = userId.toString();
    }
    name = json['name'];
    image = json['image'].toString();
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    } else {
      posts = [];
    }
    if (json['all_friends'] != null) {
      allFriends = <AllFriends>[];
      json['all_friends'].forEach((v) {
        allFriends!.add(new AllFriends.fromJson(v));
      });
    } else {
      allFriends = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    } else {
      posts = [];
    }
    if (this.allFriends != null) {
      data['all_friends'] = this.allFriends!.map((v) => v.toJson()).toList();
    } else {
      allFriends = [];
    }
    return data;
  }
}

class Posts {
  String? image;
  String? title;
  int? postId;
  int? createdBy;
  String? description;

  Posts(
      {this.image, this.title, this.postId, this.createdBy, this.description});

  Posts.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    postId = json['post_id'];
    createdBy = json['created_by'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['title'] = this.title;
    data['post_id'] = this.postId;
    data['created_by'] = this.createdBy;
    data['description'] = this.description;
    return data;
  }
}

class AllFriends {
  String? status;
  dynamic userId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  dynamic friendId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  FriendDetails? friendDetails;

  AllFriends({this.status, this.userId, this.friendId, this.friendDetails});

  AllFriends.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    friendDetails = json['friend_details'] != null
        ? new FriendDetails.fromJson(json['friend_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    if (this.friendDetails != null) {
      data['friend_details'] = this.friendDetails!.toJson();
    }
    return data;
  }
}

class FriendDetails {
  String? name;
  String? image;

  FriendDetails({this.name, this.image});

  FriendDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
