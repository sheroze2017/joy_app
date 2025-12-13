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
      this.isMyLike});

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
    // Handle both string and int for created_by (MongoDB ObjectId)
    createdBy = json['created_by'];
    if (createdBy != null && createdBy is! String) {
      createdBy = createdBy.toString();
    }
    createdAt = json['created_at'];
    status = json['status'];
    userId = json["user_id"]?.toString() ?? json["created_by"]?.toString() ?? '';
    name = json["name"] ?? '';
    phone = json["phone"] ?? '';
    user_image = json['user_image']?.toString() ?? '';
    // Parse is_my_like field (handle both snake_case and camelCase)
    isMyLike = json['is_my_like'] ?? json['isMyLike'] ?? false;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
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
  Comments({this.name, this.comment, this.commentId, this.createdAt, this.userId});

  Comments.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'comment_id' (legacy) fields
    commentId = json['_id'] ?? json['comment_id'];
    // If commentId is a String (MongoDB ObjectId), convert to int using hash code
    if (commentId is String) {
      commentId = commentId.toString().hashCode.abs();
    }
    comment = json['comment'];
    userId = json['user_id']?.toString();
    createdAt = json['created_at'];
    name = json['name'] ?? ''; // Name might not be in response, will need to fetch from user_id
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['comment_id'] = this.commentId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
