class ProductPurchaseModel {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  ProductPurchaseModel({this.code, this.sucess, this.data, this.message});

  ProductPurchaseModel.fromJson(Map<String, dynamic> json) {
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
  dynamic orderId; // Changed to dynamic to handle both _id (MongoDB string) and order_id (legacy int)
  dynamic userId; // Changed to dynamic to handle both string (MongoDB) and int (legacy)
  String? totalPrice;
  String? status;
  String? createdAt;
  String? quantity;
  String? location;
  String? lat;
  String? lng;
  String? placeId;

  Data(
      {this.orderId,
      this.userId,
      this.totalPrice,
      this.status,
      this.createdAt,
      this.quantity,
      this.location,
      this.lat,
      this.lng,
      this.placeId});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'order_id' (legacy) fields
    if (json['_id'] != null) {
      orderId = json['_id'].toString();
    } else {
      orderId = json['order_id'];
    }
    
    // Handle user_id - can be string (MongoDB) or int (legacy)
    if (json['user_id'] != null) {
      userId = json['user_id'].toString();
    } else {
      userId = null;
    }
    
    // Handle total_price - can be int, double, or string
    if (json['total_price'] != null) {
      if (json['total_price'] is String) {
        totalPrice = json['total_price'];
      } else if (json['total_price'] is num) {
        totalPrice = json['total_price'].toString();
      } else {
        totalPrice = json['total_price']?.toString();
      }
    } else {
      totalPrice = null;
    }
    
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    
    // Handle quantity - can be int or string
    if (json['quantity'] != null) {
      if (json['quantity'] is int) {
        quantity = json['quantity'].toString();
      } else {
        quantity = json['quantity']?.toString();
      }
    } else {
      quantity = null;
    }
    
    location = json['location']?.toString();
    
    // Handle lat and lng - can be double or string
    if (json['lat'] != null) {
      lat = json['lat'].toString();
    } else {
      lat = null;
    }
    
    if (json['lng'] != null) {
      lng = json['lng'].toString();
    } else {
      lng = null;
    }
    
    placeId = json['place_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['quantity'] = this.quantity;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['place_id'] = this.placeId;
    return data;
  }
}
