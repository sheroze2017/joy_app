class Comment {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  Comment({this.code, this.sucess, this.data, this.message});

  Comment.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? commentId;
  int? userId;
  String? comment;
  String? status;
  String? createdAt;
  int? postId;

  Data(
      {this.commentId,
      this.userId,
      this.comment,
      this.status,
      this.createdAt,
      this.postId});

  Data.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    userId = json['user_id'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['post_id'] = this.postId;
    return data;
  }
}
