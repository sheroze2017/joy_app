class CreatePostModel {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  CreatePostModel({this.code, this.sucess, this.data, this.message});

  CreatePostModel.fromJson(Map<String, dynamic> json) {
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
  dynamic postId; // Handle both String (_id) and int
  String? image;
  String? title;
  String? description;
  dynamic likes; // Handle int (0) and other types
  dynamic createdBy; // Handle both String (ObjectId) and int
  String? createdAt;
  String? status;

  Data(
      {this.postId,
      this.image,
      this.title,
      this.description,
      this.likes,
      this.createdBy,
      this.createdAt,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'post_id' (legacy)
    postId = json['_id'] ?? json['post_id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    likes = json['likes']; // Can be int (0) or other types
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
