class MessageResponse {
  String? sId;
  String? conversationId;
  int? senderId;
  int? receiverId;
  String? type;
  String? url;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageResponse(
      {this.sId,
      this.conversationId,
      this.senderId,
      this.receiverId,
      this.type,
      this.url,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MessageResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    type = json['type'];
    url = json['url'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['conversationId'] = this.conversationId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['type'] = this.type;
    data['url'] = this.url;
    data['isRead'] = this.isRead;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
