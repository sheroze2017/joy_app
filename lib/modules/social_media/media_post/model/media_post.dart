class MediaPostModel {
  int? code;
  bool? sucess;
  List<MediaPost>? data;
  String? message;

  MediaPostModel({this.code, this.sucess, this.data, this.message});

  MediaPostModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
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
  int? postId;
  String? image;
  String? title;
  String? description;
  String? likes;
  int? createdBy;
  String? createdAt;
  String? status;
  String? userId;
  String? name;
  String? phone;
  String? user_image;
  List<Comments>? comments;

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
      this.comments});

  MediaPost.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    likes = json['likes'].toString();
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    status = json['status'];
    userId = json["user_id"].toString();
    name = json["name"];
    phone = json["phone"];
    user_image = json['user_image'].toString();
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
  int? commentId;
  String? createdAt;

  Comments({this.comment, this.commentId, this.createdAt});

  Comments.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    commentId = json['comment_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['comment_id'] = this.commentId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
