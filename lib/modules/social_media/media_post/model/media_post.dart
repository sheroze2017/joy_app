class MediaPostModel {
  int? code;
  bool? sucess;
  List<MediaPost>? data;
  String? message;

  MediaPostModel({this.code, this.sucess, this.data, this.message});

  MediaPostModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    // Handle both 'sucess' (typo) and 'success' (correct spelling) from backend
    sucess = json['sucess'] ?? json['success'];
    if (json['data'] != null) {
      data = <MediaPost>[];
      json['data'].forEach((v) {
        data!.add(new MediaPost.fromJson(v));
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

class PostUser {
  String? userId;
  String? name;
  String? image;

  PostUser({this.userId, this.name, this.image});

  PostUser.fromJson(Map<String, dynamic> json) {
    userId = json['user_id']?.toString() ?? json['_id']?.toString() ?? '';
    name = json['name'] ?? '';
    image = json['image']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class MediaPost {
  dynamic postId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  String? image;
  String? title;
  String? description;
  String? likes;
  dynamic createdBy; // Changed to dynamic to handle both String (MongoDB ObjectId) and int (legacy)
  String? createdAt;
  String? status;
  String? userId;
  String? name;
  String? phone;
  String? user_image;
  List<Comments>? comments;
  bool? isMyLike; // Added to track if current user has liked this post
  List<dynamic>? likedBy; // Array of user IDs who liked this post
  PostUser? createdByUser;

  MediaPost(
      {this.postId,
      this.image,
      this.title,
      this.description,
      this.likes,
      this.createdBy,
      this.createdAt,
      this.status,
      this.userId,
      this.name,
      this.phone,
      this.user_image,
      this.comments,
      this.isMyLike,
      this.likedBy,
      this.createdByUser});

  MediaPost.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'post_id' (legacy) fields
    postId = json['_id'] ?? json['post_id'];
    // Keep postId as string for MongoDB ObjectId (don't convert to hash code)
    // Only convert if it's not already a string
    if (postId != null && postId is! String) {
      postId = postId.toString();
    }
    image = json['image'];
    title = json['title'];
    description = json['description'];
    likes = json['likes']?.toString() ?? '0';
    // Handle both string/int and object for created_by
    final createdByData = json['created_by'];
    if (createdByData is Map<String, dynamic>) {
      createdByUser = PostUser.fromJson(createdByData);
      createdBy = createdByUser?.userId ?? createdBy;
    } else if (createdByData != null) {
      createdBy = createdByData.toString();
    }
    createdAt = json['created_at'];
    status = json['status'];
    userId = json["user_id"]?.toString() ??
        createdByUser?.userId ??
        json["created_by"]?.toString() ??
        '';
    name = json["name"] ?? createdByUser?.name ?? '';
    phone = json["phone"] ?? '';
    user_image =
        json['user_image']?.toString() ?? createdByUser?.image ?? '';
    // Parse is_my_like field (handle both snake_case and camelCase)
    isMyLike = json['is_my_like'] ?? json['isMyLike'] ?? false;
    // Parse liked_by array
    if (json['liked_by'] != null) {
      likedBy = json['liked_by'] as List<dynamic>;
    } else {
      likedBy = [];
    }
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
      // Reverse comments to show newest first (at the top)
      comments = comments!.reversed.toList();
    } else {
      comments = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    data['likes'] = this.likes;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}

class Comments {
  String? comment;
  dynamic commentId; // Changed to dynamic to handle both '_id' (MongoDB) and 'comment_id' (legacy)
  String? createdAt;
  String? name;
  String? userId; // Added userId from response
  String? userImage;
  PostUser? user;
  Comments(
      {this.name,
      this.comment,
      this.commentId,
      this.createdAt,
      this.userId,
      this.userImage,
      this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'comment_id' (legacy) fields
    commentId = json['_id'] ?? json['comment_id'];
    // If commentId is a String (MongoDB ObjectId), convert to int using hash code
    if (commentId is String) {
      commentId = commentId.toString().hashCode.abs();
    }
    comment = json['comment'];
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      user = PostUser.fromJson(json['user']);
    }
    userId = json['user_id']?.toString() ?? user?.userId;
    createdAt = json['created_at'];
    name = json['name'] ?? user?.name ?? ''; // fallback to nested user
    userImage = json['user_image']?.toString() ?? user?.image ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['comment_id'] = this.commentId;
    data['created_at'] = this.createdAt;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['user_image'] = this.userImage;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
