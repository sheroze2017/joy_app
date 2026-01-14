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
  dynamic commentId; // Changed to dynamic to handle MongoDB _id (string) or comment_id (int)
  dynamic userId; // Changed to dynamic to handle MongoDB string IDs
  String? comment;
  String? status;
  String? createdAt;
  dynamic postId; // Changed to dynamic to handle MongoDB string IDs

  Data(
      {this.commentId,
      this.userId,
      this.comment,
      this.status,
      this.createdAt,
      this.postId});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both _id (MongoDB) and comment_id (legacy)
    if (json['_id'] != null) {
      commentId = json['_id'].toString();
    } else {
      commentId = json['comment_id']?.toString() ?? json['comment_id'];
    }
    
    // Handle user_id - can be string (MongoDB) or int (legacy)
    if (json['user_id'] != null) {
      userId = json['user_id'].toString();
    } else {
      userId = null;
    }
    
    comment = json['comment']?.toString() ?? '';
    status = json['status']?.toString() ?? '';
    createdAt = json['created_at']?.toString() ?? '';
    
    // Handle post_id - can be string (MongoDB) or int (legacy)
    if (json['post_id'] != null) {
      postId = json['post_id'].toString();
    } else {
      postId = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.commentId?.toString();
    data['comment_id'] = this.commentId?.toString();
    data['user_id'] = this.userId?.toString();
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['post_id'] = this.postId?.toString();
    return data;
  }
}
