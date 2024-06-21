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
  Null? likes;
  int? createdBy;
  String? createdAt;
  String? status;

  MediaPost(
      {this.postId,
      this.image,
      this.title,
      this.description,
      this.likes,
      this.createdBy,
      this.createdAt,
      this.status});

  MediaPost.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    likes = json['likes'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    status = json['status'];
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
