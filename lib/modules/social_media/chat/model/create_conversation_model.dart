class CreateConversation {
  String? status;
  ConvoId? data;

  CreateConversation({this.status, this.data});

  CreateConversation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new ConvoId.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ConvoId {
  String? sId;
  int? userId;
  int? friendId;
  String? userName;
  String? friendName;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ConvoId(
      {this.sId,
      this.userId,
      this.friendId,
      this.userName,
      this.friendName,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ConvoId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    friendId = json['friendId'];
    userName = json['userName'];
    friendName = json['friendName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['friendId'] = this.friendId;
    data['userName'] = this.userName;
    data['friendName'] = this.friendName;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
