import '../../media_post/model/media_post.dart';

class AllUserPostModel {
  int? code;
  bool? sucess;
  List<Post>? data;
  String? message;

  AllUserPostModel({this.code, this.sucess, this.data, this.message});

  AllUserPostModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <Post>[];
      json['data'].forEach((v) {
        data!.add(new Post.fromJson(v));
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

class Post {
  int? postId;
  String? image;
  String? title;
  String? description;
  Null? likes;
  int? createdBy;
  String? createdAt;
  String? status;
  int? userId;
  String? name;
  String? userImage;
  String? phone;
  List<Comments>? comments;

  Post(
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
      this.userImage,
      this.phone,
      this.comments});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    image = json['image'] ?? '';
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    likes = json['likes'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    status = json['status'] ?? '';
    userId = json['user_id'];
    name = json['name'] ?? '';
    userImage = json['user_image'] ?? '';
    phone = json['phone'] ?? '';
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
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['user_image'] = this.userImage;
    data['phone'] = this.phone;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
